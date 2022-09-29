# Thanks to DrWatson's Documenter setup!
cd(@__DIR__)
using Pkg
CI = get(ENV, "CI", nothing) == "true" || get(ENV, "GITHUB_TOKEN", nothing) !== nothing
CI && Pkg.activate(@__DIR__)
CI && Pkg.instantiate()

using Documenter
using DocumenterTools: Themes

using EngThermBase

# %%
# download the themes
for file in (
        "juliadynamics-lightdefs.scss",
        "juliadynamics-darkdefs.scss",
        "juliadynamics-style.scss"
    )
    download(
        "https://raw.githubusercontent.com/JuliaDynamics/doctheme/master/$file",
        joinpath(@__DIR__, file)
    )
end

# create the themes
for w in ("light", "dark")
    header = read(joinpath(@__DIR__, "juliadynamics-style.scss"), String)
    theme = read(joinpath(@__DIR__, "juliadynamics-$(w)defs.scss"), String)
    write(joinpath(@__DIR__, "juliadynamics-$(w).scss"), header*"\n"*theme)
end

# compile the themes
Themes.compile(
    joinpath(@__DIR__, "juliadynamics-light.scss"),
    joinpath(@__DIR__, "src/assets/themes/documenter-light.css"))
Themes.compile(
    joinpath(@__DIR__, "juliadynamics-dark.scss"),
    joinpath(@__DIR__, "src/assets/themes/documenter-dark.css"))

# Translate .jl sources into .md ones
using Literate
Literate.markdown("src/tagging.jl", "src"; credit = false)

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
        "Reference" => "reference.md",
    ],
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
