using Documenter
using EngThermBase

makedocs(
    sitename = "EngThermBase",
    format = Documenter.HTML(),
    modules = [EngThermBase]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
