#----------------------------------------------------------------------------------------------#
#                                       Auxiliary Items                                        #
#----------------------------------------------------------------------------------------------#

"""
`struct unvarSerF{𝕡,𝕩} <: AuxFunc where {𝕡<:PREC,𝕩<:EXAC}`

Precision- and Exactness- parameterized, scalar-valued, dimensionless, `<:AbstractFloat`,
univariate, series function type with explicit compact (bounded / interval) domain support and
reference domain/codomain elements, or, conversely, reference argument/value or state/value,
respectively.

Depending on the Exactness parameter, *both* function domain and codomain elements are uniformly
of type `𝕡 where {𝕡<:PREC}`, for `𝕩 ≡ EX` — the Exact base; or `Measurement{𝕡} where {𝕡<:PREC}`,
for `𝕩 ≡ MM` — the Measurement base.

Data members include:

    - `xmin::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the domain support interval inferior endpoint;
    - `xmax::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the domain support interval superior endpoint;
\#    - `xref::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the domain reference element/argument/state;
\#    - `yref::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the codomain reference element/value;
    - `fvec::Vector{Function}`: the variable collection of function additive terms;

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
    - Moreover, `𝑓(𝑓.xref) == 𝑓.yref`, by the addition of a constant shift value, independently
    of the form(s) of the `𝑓.fvec`'s term(s);
    - `𝑓.xref` is used as the _default_ inferior integration limit for integrations.

This last convention allows `xref` and `yref` to be freely and simply defined by passing their
respective values to a `unvarSerF` constructor, instead of (i) calculating and (ii) specifying a
constant term to the `fvec` vector.

## Hierarchy

`$(tyArchy(unvarSerF))`\n
"""
struct unvarSerF{𝕡,𝕩} <: AuxFunc where {𝕡<:PREC,𝕩<:EXAC}
    xmin::plnF{𝕡}   # Plain, unitless floats: (≝ Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC)
    xmax::plnF{𝕡}
    #xref::plnF{𝕡}
    #yref::plnF{𝕡}
    fvec::Vector{Function}
    mulf::plnF{𝕡}
    unvarSerF(amin::𝕡, amax::𝕡,
              #aref::𝕡, bref::𝕡,
              funv::Vector{<:Function}) where {𝕡<:PREC} = begin
        @assert !isnan(amin)
        @assert !isnan(amax)
        #@assert !isnan(aref)
        #@assert !isnan(bref)
        @assert amin <= amax
        @assert length(funv) > 0
        #yref = reduce(+, [𝚏(aref) for 𝚏 in funv])
        new{𝕡,EX}(amin, amax,
                  #aref, bref,
                  #Function[x->(bref-yref), funv...],
                  funv,
                  one(𝕡))
    end
    unvarSerF(amin::plnF{𝕡}, amax::plnF{𝕡},
              #aref::plnF{𝕡}, bref::plnF{𝕡},
              funv::Vector{<:Function}, фerr::𝕡) where {𝕡<:PREC} = begin
        @assert !isnan(amin)
        @assert !isnan(amax)
        #@assert !isnan(aref)
        #@assert !isnan(bref)
        #@assert amin <= aref <= amax
        @assert length(funv) > 0
        @assert !isnan(фerr)
        #yref = reduce(+, [𝚏(aref) for 𝚏 in funv])
        new{𝕡,MM}(amin, amax,
                  #aref, bref,
                  #Function[x->(bref-yref), funv...],
                  funv,
                  one(𝕡) ± фerr * 1.0e-2)
    end
end

(F::unvarSerF{𝕡,EX})(x::plnF{𝕡}) where {𝕡<:PREC} = begin
    𝑥 = bare(ø_amt{𝕡,EX}(x))
    @assert !isnan(𝑥)
    @assert F.xmin <= 𝑥 <= F.xmax
    return bare(ø_amt{𝕡,EX}(reduce(+, [𝑓(𝑥) for 𝑓 in F.fvec])))
end

(F::unvarSerF{𝕡,MM})(x::plnF{𝕡}) where {𝕡<:PREC} = begin
    𝑥 = bare(ø_amt{𝕡,MM}(x))
    @assert !isnan(𝑥)
    @assert F.xmin <= 𝑥 <= F.xmax
    return bare(ø_amt{𝕡,MM}(reduce(+, [𝑓(𝑥) for 𝑓 in F.fvec]) * F.mulf))
end

export unvarSerF


