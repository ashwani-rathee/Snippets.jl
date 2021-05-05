push!(LOAD_PATH,"../src/")
using Documenter
# Inside make.jl

makedocs(sitename="Documentation",
        pages=[
            "Home" => "index.md"
           ])
deploydocs(repo = "github.com/ashwani-rathee/Snippets.jl")