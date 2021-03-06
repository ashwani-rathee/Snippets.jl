### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ e8e1bfa8-aa94-11eb-1665-615377b9f122
begin

using BSON
# using CUDA
using DrWatson: struct2dict
using Flux
using Flux: @functor, chunk
using Flux.Losses: logitbinarycrossentropy
using Flux.Data: DataLoader
using Images
using Logging: with_logger
using MLDatasets
using Parameters: @with_kw
using ProgressMeter: Progress, next!
using TensorBoardLogger: TBLogger, tb_overwrite
using Random

end

# ╔═╡ 5b2732f8-aa97-11eb-069d-7f85576ab103
begin
# load MNIST images and return loader
function get_data(batch_size)
    xtrain, ytrain = MLDatasets.MNIST.traindata(Float32)
    xtrain = reshape(xtrain, 28^2, :)
    DataLoader((xtrain, ytrain), batchsize=batch_size, shuffle=true)
end
end

# ╔═╡ 6c8a981c-aa97-11eb-25ca-438266bc787d
begin
	
struct Encoder
    linear
    μ
    logσ
end
@functor Encoder
 
Encoder(input_dim::Int, latent_dim::Int, hidden_dim::Int) = Encoder(
    Dense(input_dim, hidden_dim, tanh),   # linear
    Dense(hidden_dim, latent_dim),        # μ
    Dense(hidden_dim, latent_dim),        # logσ
)

function (encoder::Encoder)(x)
    h = encoder.linear(x)
    encoder.μ(h), encoder.logσ(h)
end
	
end

# ╔═╡ b4a9f1bc-aa97-11eb-04d9-65eab1b329ce
begin
Decoder(input_dim::Int, latent_dim::Int, hidden_dim::Int) = Chain(
    Dense(latent_dim, hidden_dim, tanh),
    Dense(hidden_dim, input_dim)
)
	
end

# ╔═╡ be1b1244-aa97-11eb-2d31-19d26ed93cd1
begin
function reconstuct(encoder, decoder, x, device)
    μ, logσ = encoder(x)
    z = μ + device(randn(Float32, size(logσ))) .* exp.(logσ)
    μ, logσ, decoder(z)
end	
end

# ╔═╡ c74b6f6c-aa97-11eb-383f-d91ff310910b
begin
function model_loss(encoder, decoder, λ, x, device)
    μ, logσ, decoder_z = reconstuct(encoder, decoder, x, device)
    len = size(x)[end]
    # KL-divergence
    kl_q_p = 0.5f0 * sum(@. (exp(2f0 * logσ) + μ^2 -1f0 - 2f0 * logσ)) / len

    logp_x_z = -logitbinarycrossentropy(decoder_z, x, agg=sum) / len
    # regularization
    reg = λ * sum(x->sum(x.^2), Flux.params(decoder))
    
    -logp_x_z + kl_q_p + reg
end	
end

# ╔═╡ cfbae2f4-aa97-11eb-0a1b-5fa1a30d6634
begin

function convert_to_image(x, y_size)
    Gray.(permutedims(vcat(reshape.(chunk(x |> cpu, y_size), 28, :)...), (2, 1)))
end	
end

# ╔═╡ a88b2124-aa96-11eb-3cfb-57b10bf0bd54
begin

# arguments for the `train` function 
@with_kw mutable struct Args
    η = 1e-3                # learning rate
    λ = 0.01f0              # regularization paramater
    batch_size = 128        # batch size
    sample_size = 10        # sampling size for output    
    epochs = 20             # number of epochs
    seed = 0                # random seed
    cuda = true             # use GPU
    input_dim = 28^2        # image size
    latent_dim = 2          # latent dimension
    hidden_dim = 500        # hidden dimension
    verbose_freq = 10       # logging for every verbose_freq iterations
    tblogger = false        # log training with tensorboard
    save_path = "output"    # results path
end

end

# ╔═╡ 72553fa6-aa97-11eb-05e1-a37cbe1c5e61
begin
function train(; kws...)
    # load hyperparamters
    args = Args(; kws...)
    args.seed > 0 && Random.seed!(args.seed)

    # GPU config
    if args.cuda && CUDA.has_cuda()
        device = gpu
        @info "Training on GPU"
    else
        device = cpu
        @info "Training on CPU"
    end

    # load MNIST images
    loader = get_data(args.batch_size)
    
    # initialize encoder and decoder
    encoder = Encoder(args.input_dim, args.latent_dim, args.hidden_dim) |> device
    decoder = Decoder(args.input_dim, args.latent_dim, args.hidden_dim) |> device

    # ADAM optimizer
    opt = ADAM(args.η)
    
    # parameters
    ps = Flux.params(encoder.linear, encoder.μ, encoder.logσ, decoder)

    !ispath(args.save_path) && mkpath(args.save_path)

    # logging by TensorBoard.jl
    if args.tblogger
        tblogger = TBLogger(args.save_path, tb_overwrite)
    end

    # fixed input
    original, _ = first(get_data(args.sample_size^2))
    original = original |> device
    image = convert_to_image(original, args.sample_size)
    image_path = joinpath(args.save_path, "original.png")
    save(image_path, image)

    # training
    train_steps = 0
    @info "Start Training, total $(args.epochs) epochs"
    for epoch = 1:args.epochs
        @info "Epoch $(epoch)"
        progress = Progress(length(loader))

        for (x, _) in loader 
            loss, back = Flux.pullback(ps) do
                model_loss(encoder, decoder, args.λ, x |> device, device)
            end
            grad = back(1f0)
            Flux.Optimise.update!(opt, ps, grad)
            # progress meter
            next!(progress; showvalues=[(:loss, loss)]) 

            # logging with TensorBoard
            if args.tblogger && train_steps % args.verbose_freq == 0
                with_logger(tblogger) do
                    @info "train" loss=loss
                end
            end

            train_steps += 1
        end
        # save image
        _, _, rec_original = reconstuct(encoder, decoder, original, device)
        rec_original = sigmoid.(rec_original)
        image = convert_to_image(rec_original, args.sample_size)
        image_path = joinpath(args.save_path, "epoch_$(epoch).png")
        save(image_path, image)
        @info "Image saved: $(image_path)"
    end

    # save model
    model_path = joinpath(args.save_path, "model.bson") 
    let encoder = cpu(encoder), decoder = cpu(decoder), args=struct2dict(args)
        BSON.@save model_path encoder decoder args
        @info "Model saved: $(model_path)"
    end
end
end

# ╔═╡ 898aba0c-aa97-11eb-2d36-db7280da954e
train(Args)

# ╔═╡ Cell order:
# ╠═e8e1bfa8-aa94-11eb-1665-615377b9f122
# ╠═5b2732f8-aa97-11eb-069d-7f85576ab103
# ╠═6c8a981c-aa97-11eb-25ca-438266bc787d
# ╠═72553fa6-aa97-11eb-05e1-a37cbe1c5e61
# ╠═b4a9f1bc-aa97-11eb-04d9-65eab1b329ce
# ╠═be1b1244-aa97-11eb-2d31-19d26ed93cd1
# ╠═c74b6f6c-aa97-11eb-383f-d91ff310910b
# ╠═cfbae2f4-aa97-11eb-0a1b-5fa1a30d6634
# ╠═a88b2124-aa96-11eb-3cfb-57b10bf0bd54
# ╠═898aba0c-aa97-11eb-2d36-db7280da954e
