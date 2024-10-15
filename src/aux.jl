#----------------------------------------------------------------------------------------------#
#                                       Auxiliary Items                                        #
#----------------------------------------------------------------------------------------------#

struct unvarSerF{𝕡<:PREC,𝕩<:EXAC} <: AuxFunc
    xmin::plnF{𝕡}   # Plain, unitless floats: (≝ Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC)
    xmax::plnF{𝕡}
    yref::plnF{𝕡}
    fvec::Vector{Function}
    unvarSerF(amin::𝕡, amax::𝕡, bref::𝕡, funv::Vector{Function}) = begin
        @assert !isnan(amin)
        @assert !isnan(amax)
        @assert !isnan(bref)
        @assert amin < amax
        @assert length(funv) > 0
        new{𝕡,EX}(amin, amax, bref, funv)
    end
    unvarSerF(amin::Measurement{𝕡},
              amax::Measurement{𝕡},
              bref::Measurement{𝕡},
              funv::Vector{Function}) = begin
        @assert !isnan(amin)
        @assert !isnan(amax)
        @assert !isnan(bref)
        @assert amin < amax
        @assert length(funv) > 0
        new{𝕡,MM}(amin, amax, bref, funv)
    end
end


