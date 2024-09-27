using Test, Documenter, EngThermBase

# EngTherm top-level tests
include("abstract.test.jl")
include("settings.test.jl")
include("exactness.test.jl")
include("amounts.test.jl")

# DocTests
@testset "DocTests for EngThermBase                                               " begin
    doctest(EngThermBase; manual = false)
end

