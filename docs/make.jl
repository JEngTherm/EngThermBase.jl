using Documenter
using EngThermBase

makedocs(
    sitename = "EngThermBase",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == true
    ),
    modules = [EngThermBase],
    pages = [
        "Introduction" => "index.md",
##         "Examples" => "examples.md",
        "Reference" => "_reference.md",
    ],
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
