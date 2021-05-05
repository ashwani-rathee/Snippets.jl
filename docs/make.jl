using Documenter,ImageDraw
# Inside make.jl
push!(LOAD_PATH,"../src/")

makedocs(sitename="Documentation",
            format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"))
deploydocs(repo = "github.com/ashwani-rathee/Snippets.jl")