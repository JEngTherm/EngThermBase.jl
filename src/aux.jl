#----------------------------------------------------------------------------------------------#
#                                       Auxiliary Items                                        #
#----------------------------------------------------------------------------------------------#

struct unvarSerF{𝕡,𝕩} <: AuxFunc where {𝕡<:PREC,𝕩<:EXAC}
    xmin::plnF{𝕡}   # Plain, unitless floats: (≝ Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC)
    xmax::plnF{𝕡}
    xref::plnF{𝕡}
    yref::plnF{𝕡}
    fvec::Vector{Function}
    unvarSerF(amin::𝕡, amax::𝕡, aref::𝕡, bref::𝕡, funv::Vector{<:Function}) where {𝕡<:PREC} = begin
        @assert !isnan(amin)
        @assert !isnan(amax)
        @assert !isnan(aref)
        @assert !isnan(bref)
        @assert amin <= aref <= amax
        @assert length(funv) > 0
        new{𝕡,EX}(amin, amax, aref, bref, funv)
    end
    unvarSerF(amin::Measurement{𝕡},
              amax::Measurement{𝕡},
              aref::Measurement{𝕡},
              bref::Measurement{𝕡},
              funv::Vector{<:Function}) where {𝕡<:PREC} = begin
        @assert !isnan(amin)
        @assert !isnan(amax)
        @assert !isnan(aref)
        @assert !isnan(bref)
        @assert amin <= aref <= amax
        @assert length(funv) > 0
        new{𝕡,MM}(amin, amax, aref, bref, funv)
    end
end

(F::unvarSerF{𝕡,EX})(x::plnF{𝕡}) where {𝕡<:PREC} = begin
    𝑥 = bare( ø_amt{𝕡,EX}(x) )
    𝑢 = F.xref
    @assert !isnan(𝑥)
    @assert F.xmin <= 𝑥 <= F.xmax
    𝑦 = bare( ø_amt{𝕡,EX}( reduce(+, [ 𝑓(𝑥) for 𝑓 in F.fvec ]) ) )
    𝑣 = bare( ø_amt{𝕡,EX}( reduce(+, [ 𝑓(𝑢) for 𝑓 in F.fvec ]) ) )
    𝑦 - 𝑣 + F.yref
end

(F::unvarSerF{𝕡,MM})(x::plnF{𝕡}) where {𝕡<:PREC} = begin
    𝑥 = bare( ø_amt{𝕡,MM}(x) )
    𝑢 = F.xref
    @assert !isnan(𝑥)
    @assert F.xmin <= 𝑥 <= F.xmax
    𝑦 = bare( ø_amt{𝕡,MM}( reduce(+, [ 𝑓(𝑥) for 𝑓 in F.fvec ]) ) )
    𝑣 = bare( ø_amt{𝕡,MM}( reduce(+, [ 𝑓(𝑢) for 𝑓 in F.fvec ]) ) )
    𝑦 - 𝑣 + F.yref
end

export unvarSerF

