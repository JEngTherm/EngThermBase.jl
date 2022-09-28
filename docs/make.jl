using Documenter
using EngThermBase

# Thanks to DrWatson's Documenter setup!
using Literate
Literate.markdown("src/tagging.jl", "src"; credit = false)

makedocs(
    sitename = "EngThermBase",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == true
    ),
    modules = [EngThermBase],
    pages = Any[
        "Introduction" => "index.md",
        "Examples" => Any[
            "Tagging" => "tagging.md",
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
