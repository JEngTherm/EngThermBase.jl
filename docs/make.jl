using Documenter
using EngThermBase

# Translate .jl sources into .md ones
using Literate
Literate.markdown("src/tagging.jl", "src"; credit = false)

DocMeta.setdocmeta!(EngThermBase, :DocTestSetup, :(using EngThermBase); recursive=true)

# EngThermBase docs:
makedocs(
    sitename = "EngThermBase",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == true
    ),
    logo = "assets/logo.svg",
    modules = [EngThermBase],
    pages = Any[
        "Introduction" => "index.md",
        "Examples" => Any[
            "Tagging" => "tagging.md",
        ],
        "TutoriTests" => Any[
            "Amounts" => "tt-amounts.md",
        ],
        "Reference" => "reference.md",
    ],
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
