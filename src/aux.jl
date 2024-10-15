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

Recall the definitions of `PREC` and `EXAC` being:

`const PREC = Union{Float16,Float32,Float64,BigFloat}`

`const EXAC = Union{EX,MM}`

Data members include:

    - `xmin::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the domain support interval inferior endpoint;
    - `xmax::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the domain support interval superior endpoint;
    - `xref::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the domain reference element/argument/state;
    - `yref::Union{𝕡, Measurement{𝕡}} where 𝕡<:PREC`: the codomain reference element/value;
    - `fvec::Vector{Function}`: the variable collection of function additive terms;

The inner constructors enforce the following standards/restrictions:

    - No input value `[xy]{min,max,ref}` shall be a NaN;
    - `xmin <= xref <= xmax`;
    - `fvec` must not be empty.

## Hierarchy

`unvarSerF <: $(tyArchy(unvarSerF))`\n
"""
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

