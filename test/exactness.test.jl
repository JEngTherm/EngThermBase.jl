#----------------------------------------------------------------------------------------------#
#                                      exactness.test.jl                                       #
#----------------------------------------------------------------------------------------------#

@testset "exactness.test.jl: Quantity tests                                       " begin
    _qty = EngThermBase._qty
    for 𝗣 in (Float16, Float32, Float64, BigFloat)
        @test _qty(𝗣(π)) isa Quantity{𝗣, NoDims}
        @test _qty(𝗣(π) ± 𝗣(π/100)) isa Quantity{Measurement{𝗣}, NoDims}
        for 𝗨 in (u"m", u"s", u"N", u"J", u"K", u"mol", u"kJ/kg", u"kJ/kg/K")
            @test _qty(𝗣(ℯ) * 𝗨) isa Quantity{𝗣, dimension(𝗨)}
            @test _qty((𝗣(ℯ) ± 𝗣(ℯ/100)) * 𝗨) isa Quantity{Measurement{𝗣}, dimension(𝗨)}
        end
    end
end

