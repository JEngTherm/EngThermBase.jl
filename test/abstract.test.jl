using InteractiveUtils

function union2vec(theU::Union)
    ret = DataType[]
    while theU isa Union
        push!(ret, theU.a)
        theU = theU.b
    end
    push!(ret, theU)
    return ret
end

#----------------------------------------------------------------------------------------------#
#                                       abstract.test.jl                                       #
#----------------------------------------------------------------------------------------------#

@testset "abstract.test.jl: PREC, EXAC, and BASE type Union tests                 " begin
    # All PREC members must be floats:
    for __t in union2vec(EngThermBase.PREC)
        @test __t <: AbstractFloat
    end
    # EXAC must contain all ExactBase subtypes:
    @test Set(union2vec(EngThermBase.EXAC)) ==
          Set(subtypes(ExactBase))
    # BASE must contain all ThermBase subtypes:
    @test Set(union2vec(EngThermBase.BASE)) == 
          Set(vcat([ subtypes(i) for i in subtypes(ThermBase) ]...))
end

