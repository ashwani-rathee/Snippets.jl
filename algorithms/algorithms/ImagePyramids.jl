### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ e37b7694-2e72-11eb-0df0-f31f9c0e23d6
using ImageCore,TestImages,Images,Plots,FileIO

# ╔═╡ 2334d8de-2ee4-11eb-3a0f-9ba248f3f668
begin
	using OffsetArrays # provide `OffsetArray`
	red_patch = fill(RGBA(1., 0., 0., 1), 24, 24)
green_patch = fill(RGBA(0., 1., 0., 1), 32, 32)
mosaicview(red_patch, green_patch; npad=20, nrow=1, fillvalue=colorant"white")

red_o = OffsetArray(red_patch, 1, 1)
r, g = paddedviews(Gray(0.2), red_patch, red_o)
end

# ╔═╡ 7c6dc98c-2e72-11eb-1f7e-03e5315e6d69
md"""

# Build image pyramids

The pyramid_gaussian function takes an image and yields successive images shrunk by a constant scale factor. Image pyramids are often used, e.g., to implement algorithms for denoising, texture discrimination, and scale-invariant detection.

"""

# ╔═╡ c89cf29c-2e72-11eb-09d2-7d238d3c5518
img=testimage("lighthouse")

# ╔═╡ 9b6c4150-2e73-11eb-299f-25f7d1fe01d3
size(img)

# ╔═╡ baf751be-2e72-11eb-0438-ef780beafc0c
pyramid = gaussian_pyramid(img, 3, 0.5, 0.7)

# ╔═╡ ba220798-2e72-11eb-22b2-4f60df1dd02f
size(pyramid[1])

# ╔═╡ 9268754c-2e73-11eb-2281-716743cbbad9
size(pyramid[2])

# ╔═╡ a1378662-2e73-11eb-22bd-3fc0e230d339
size(pyramid[4])

# ╔═╡ 8f11ad40-2e74-11eb-158e-ebcda5bfca6e
typeof(img)


# ╔═╡ 0bdc7418-2eed-11eb-28f8-21d8142b8b8c
mosaicview(pyramid[4],pyramid[3],pyramid[2],pyramid[1];nrow=1)

# ╔═╡ 42215cfa-2e75-11eb-1dfc-9fa08e32c70f
cat=load("cat.jpg")

# ╔═╡ 521ed0ec-2e75-11eb-32f4-a9a00dde754d
typeof(cat)

# ╔═╡ 615183e8-2e75-11eb-094c-e3935b6f2fa7
typeof(pyramid[1])

# ╔═╡ 3a17a6a4-2ed9-11eb-11f6-fba1f7f8011d
begin
img1 = testimage("lighthouse")
p = plot(
    axis = false,
    layout = @layout([a [b [c [d;_]; _]; _]]),
    size = (800,400)
)

for i=1:4
    plot!(p[i], img1, ratio=1)
end
p
end

# ╔═╡ 6649d296-2edf-11eb-3a86-5975289dc1b6
A=[pyramid[1],pyramid[2],pyramid[3]]

# ╔═╡ 4ca19ac6-2ee5-11eb-1584-d979ae9ad8ad
size(red_patch)

# ╔═╡ 452d38fe-2ee5-11eb-033b-d19b25b22f6e
red=PaddedView(Gray(0.2),red_patch, (100, 24))

# ╔═╡ Cell order:
# ╠═7c6dc98c-2e72-11eb-1f7e-03e5315e6d69
# ╠═e37b7694-2e72-11eb-0df0-f31f9c0e23d6
# ╠═c89cf29c-2e72-11eb-09d2-7d238d3c5518
# ╠═9b6c4150-2e73-11eb-299f-25f7d1fe01d3
# ╠═baf751be-2e72-11eb-0438-ef780beafc0c
# ╠═ba220798-2e72-11eb-22b2-4f60df1dd02f
# ╠═9268754c-2e73-11eb-2281-716743cbbad9
# ╠═a1378662-2e73-11eb-22bd-3fc0e230d339
# ╠═8f11ad40-2e74-11eb-158e-ebcda5bfca6e
# ╠═0bdc7418-2eed-11eb-28f8-21d8142b8b8c
# ╠═42215cfa-2e75-11eb-1dfc-9fa08e32c70f
# ╠═521ed0ec-2e75-11eb-32f4-a9a00dde754d
# ╠═615183e8-2e75-11eb-094c-e3935b6f2fa7
# ╠═3a17a6a4-2ed9-11eb-11f6-fba1f7f8011d
# ╠═6649d296-2edf-11eb-3a86-5975289dc1b6
# ╠═2334d8de-2ee4-11eb-3a0f-9ba248f3f668
# ╠═4ca19ac6-2ee5-11eb-1584-d979ae9ad8ad
# ╠═452d38fe-2ee5-11eb-033b-d19b25b22f6e
