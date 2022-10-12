using TheGraphOpt
using Documenter

DocMeta.setdocmeta!(TheGraphOpt, :DocTestSetup, :(using TheGraphOpt); recursive=true)

makedocs(;
    modules=[TheGraphOpt],
    authors="Semiotic AI Inc.",
    repo="https://github.com/semiotic-ai/TheGraphOpt.jl/blob/{commit}{path}#{line}",
    sitename="TheGraphOpt.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://semiotic-ai.github.io/TheGraphOpt.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/semiotic-ai/TheGraphOpt.jl",
    devbranch="main",
)
