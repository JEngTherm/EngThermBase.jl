#----------------------------------------------------------------------------------------------#
#                                       settings.test.jl                                       #
#----------------------------------------------------------------------------------------------#

@testset "settings.test.jl: Consistent default value types in settings            " begin
    @test DEF[:IB] <: IntBase
    @test DEF[:EB] <: ExtBase
    @test DEF[:XB] <: ExactBase
    @test DEF[:pprint] isa Bool
    @test DEF[:prec] isa Bool
    @test DEF[:sigD] isa Integer
end

