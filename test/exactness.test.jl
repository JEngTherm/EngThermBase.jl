#----------------------------------------------------------------------------------------------#
#                                      exactness.test.jl                                       #
#----------------------------------------------------------------------------------------------#

@testset "exactness.test.jl: Quantity tests                                       " begin
    _qty = EngThermBase._qty
    for 𝗣 in (Float16, Float32, Float64, BigFloat)
        @test _qty(𝗣(π)) isa Quantity{𝗣, NoDims}
        @test _qty(𝗣(π) ± 𝗣(π/100)) isa Quantity{Measurement{𝗣}, NoDims}
        for 𝗨 in (
            u"m", u"s", u"m/s", u"N", u"N/m^2", u"J", u"J/s", u"K", u"1/K", u"mol",
            u"mol/s", u"kg/kmol", u"kJ/kg", u"kJ/kg/s", u"kJ/kg/K", u"kJ/kg/K/s",
        )
            @test _qty(𝗣(ℯ) * 𝗨) isa Quantity{𝗣, dimension(𝗨)}
            @test _qty((𝗣(ℯ) ± 𝗣(ℯ/100)) * 𝗨) isa Quantity{Measurement{𝗣}, dimension(𝗨)}
        end
    end
end

@testset "exactness.test.jl: Promotion rules                                      " begin
    @test promote_type(EX, EX) == EX
    @test promote_type(EX, MM) == MM
    @test promote_type(MM, EX) == MM
    @test promote_type(MM, MM) == MM
end

