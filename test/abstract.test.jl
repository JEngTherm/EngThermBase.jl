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

@testset "abstract.test.jl: BASES branch                                          " begin
    # All PREC members must be floats:
    for __t in union2vec(EngThermBase.PREC)
        @test __t <: AbstractFloat
    end
end

