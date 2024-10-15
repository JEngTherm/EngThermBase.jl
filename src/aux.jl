#----------------------------------------------------------------------------------------------#
#                                       Auxiliary Items                                        #
#----------------------------------------------------------------------------------------------#

using ForwardDiff


#----------------------------------------------------------------------------------------------#
#                                        unvarSerF{𝕡,𝕩}                                        #
#----------------------------------------------------------------------------------------------#

"""
`struct unvarSerF{𝕡,𝕩} <: AuxFunc where {𝕡<:PREC,𝕩<:EXAC}`

Precision- and Exactness- parameterized, scalar-valued, dimensionless, `<:AbstractFloat`,
univariate, series function type with explicit compact (bounded / interval) domain support.

Depending on the Exactness parameter, *both* function domain and codomain elements are uniformly
of type `𝕡 where {𝕡<:PREC}`, for `𝕩 ≡ EX` — the Exact base; or `Measurement{𝕡} where {𝕡<:PREC}`,
for `𝕩 ≡ MM` — the Measurement base.

Data members include:

    - `xmin::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the domain support interval inferior endpoint;
    - `xmax::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the domain support interval superior endpoint;
    - `fvec::Vector{Function}`: the variable collection of function additive terms;
    - `mulf::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the multiplicative factor, for %error;

The inner constructors enforce the following standards/restrictions:

    - No input value `{xmin,xmax}` shall be a NaN;
    - `xmin <= xmax`;
    - `fvec` must not be empty.

Instances of `unvarSerF` are `functors`, meaning they can be used as functions (as expected).
The functor implementation enforce the following standard: if `𝑓::unvarSerF{𝕡,𝕩} ...`, then:

    - The argument `𝑥` of `𝑓{𝕡,EX}(𝑥)` can be `𝑥::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`;
    - However, `𝑓{𝕡,EX}(𝑥)::𝕡 where 𝕡<:PREC`, meaning the return type precision is `EX`;
    - The argument `𝑥` of `𝑓{𝕡,MM}(𝑥)` can be `𝑥::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`;
    - However, `𝑓{𝕡,MM}(𝑥)::Measurement{𝕡} where 𝕡<:PREC`, meaning the return type precision is `MM`;

## Hierarchy

`$(tyArchy(unvarSerF))`\n
"""
struct unvarSerF{𝕡,𝕩} <: AuxFunc where {𝕡<:PREC,𝕩<:EXAC}
    xmin::plnF{𝕡}   # Plain, unitless floats: (≝ Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC)
    xmax::plnF{𝕡}
    fvec::Vector{Function}
    mulf::plnF{𝕡}
    unvarSerF(amin::𝕡, amax::𝕡, funv::Vector{<:Function}) where {𝕡<:PREC} = begin
        @assert !isnan(amin)
        @assert !isnan(amax)
        @assert amin <= amax
        @assert length(funv) > 0
        new{𝕡,EX}(amin, amax, funv, one(𝕡))
    end
    unvarSerF(amin::plnF{𝕡}, amax::plnF{𝕡}, funv::Vector{<:Function}, фerr::𝕡) where {𝕡<:PREC} = begin
        @assert !isnan(amin)
        @assert !isnan(amax)
        @assert amin <= amax
        @assert length(funv) > 0
        @assert !isnan(фerr)
        new{𝕡,MM}(amin, amax, funv, one(𝕡) ± (фerr * 𝕡(1.0e-2)))
    end
end

(F::unvarSerF{𝕡,EX})(x::plnF{𝕡}) where {𝕡<:PREC} = begin
    @assert !isnan(x)
    @assert F.xmin <= x <= F.xmax
    return bare(ø_amt{𝕡,EX}(reduce(+, [𝑓(x) for 𝑓 in F.fvec])))
end

(F::unvarSerF{𝕡,MM})(x::plnF{𝕡}) where {𝕡<:PREC} = begin
    @assert !isnan(x)
    @assert F.xmin <= x <= F.xmax
    return bare(ø_amt{𝕡,MM}(reduce(+, [𝑓(x) for 𝑓 in F.fvec]) * F.mulf))
end

export unvarSerF


#----------------------------------------------------------------------------------------------#
#                                     unvarSerF Factories                                      #
#----------------------------------------------------------------------------------------------#


function ddx(𝑓::unvarSerF{𝕡,EX})::unvarSerF{𝕡,EX} where 𝕡<:PREC
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[x->ForwardDiff.derivative(fi, x) for fi in 𝑓.fvec ]
    )
end

function ddx(𝑓::unvarSerF{𝕡,MM})::unvarSerF{𝕡,MM} where 𝕡<:PREC
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[x->ForwardDiff.derivative(fi, x) for fi in 𝑓.fvec ],
        𝑓.mulf.err / 𝕡(1.0e-2)
    )
end

export ddx


#----------------------------------------------------------------------------------------------#
#                             Other Functions involving unvarSerF                              #
#----------------------------------------------------------------------------------------------#



