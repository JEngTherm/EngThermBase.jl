#----------------------------------------------------------------------------------------------#
#                                       Auxiliary Items                                        #
#----------------------------------------------------------------------------------------------#


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

    - `𝑓{𝕡,EX}(𝑥)::𝕡 where 𝕡<:PREC`, meaning the return type precision is `EX`;
    - `𝑓{𝕡,MM}(𝑥)::Measurement{𝕡} where 𝕡<:PREC`, meaning the return type precision is `MM`;

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

(F::unvarSerF{𝕡,𝕩})(x::Union{REAL,𝕢}) where {𝕡<:PREC,𝕢<:PREC,𝕩<:EXAC} = F(𝕡(x))

(F::unvarSerF{𝕡,𝕩})(x::Measurement{𝕢}) where {𝕡<:PREC,𝕢<:PREC,𝕩<:EXAC} = F(Measurement{𝕡}(x))

export unvarSerF


#----------------------------------------------------------------------------------------------#
#                                     unvarSerF Factories                                      #
#----------------------------------------------------------------------------------------------#

#······························································································#
#                                         Derivatives                                          #
#······························································································#

using ForwardDiff

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


#······························································································#
#                                          Integrals                                           #
#······························································································#

using QuadGK

function ∫dx(𝑓::unvarSerF{𝕡,EX},
             xref::plnF{𝕡}=𝑓.xmin,
             yref::plnF{𝕡}=zero(𝕡))::unvarSerF{𝕡,EX} where 𝕡<:PREC
    𝑟 = bare(ø_amt{𝕡,EX}(xref))
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[x->yref, [x->quadgk(fi, 𝑟, x)[1] for fi in 𝑓.fvec]...]
    )
end

function ∫dx(𝑓::unvarSerF{𝕡,MM},
             xref::plnF{𝕡}=𝑓.xmin,
             yref::plnF{𝕡}=zero(𝕡))::unvarSerF{𝕡,MM} where 𝕡<:PREC
    𝑟 = bare(ø_amt{𝕡,MM}(xref))
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[x->yref, [
                x->(
                    (i, e) = bare.(ø_amt{𝕡,MM}.(quadgk(fi, 𝑟, x)));
                    (i.val ± √(i.err^2 + e.val^2))
                ) for fi in 𝑓.fvec
            ]...
        ],
        𝑓.mulf.err / 𝕡(1.0e-2)
    )
end

function ∫dlnx(𝑓::unvarSerF{𝕡,EX},
               xref::plnF{𝕡}=𝑓.xmin,
               yref::plnF{𝕡}=zero(𝕡))::unvarSerF{𝕡,EX} where 𝕡<:PREC
    𝑟 = bare(ø_amt{𝕡,EX}(xref))
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[x->yref, [x->quadgk(𝑥->fi(𝑥)/𝑥, 𝑟, x)[1] for fi in 𝑓.fvec]...]
    )
end

function ∫dlnx(𝑓::unvarSerF{𝕡,MM},
               xref::plnF{𝕡}=𝑓.xmin,
               yref::plnF{𝕡}=zero(𝕡))::unvarSerF{𝕡,MM} where 𝕡<:PREC
    𝑟 = bare(ø_amt{𝕡,MM}(xref))
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[x->yref, [
                x->(
                    (i, e) = bare.(ø_amt{𝕡,MM}.(quadgk(𝑥->fi(𝑥)/𝑥, 𝑟, x)));
                    (i.val ± √(i.err^2 + e.val^2))
                ) for fi in 𝑓.fvec
            ]...
        ],
        𝑓.mulf.err / 𝕡(1.0e-2)
    )
end

export ∫dx, ∫dlnx


#······························································································#
#                                   Add / Sub by a constant                                    #
#······························································································#

+(𝑎::Union{REAL, 𝕢}, 𝑓::unvarSerF{𝕡,EX})::unvarSerF{𝕡,EX} where {𝕡<:PREC,𝕢<:PREC} = begin
    𝚊 = 𝕡(𝑎)
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[x->𝚊, 𝑓.fvec...]
    )
end

+(𝑎::Measurement{𝕢}, 𝑓::unvarSerF{𝕡,EX})::unvarSerF{𝕡,EX} where {𝕡<:PREC,𝕢<:PREC} = begin
    𝚊 = 𝕡(𝑎.val)
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[x->𝚊, 𝑓.fvec...]
    )
end

+(𝑎::Union{REAL, 𝕢}, 𝑓::unvarSerF{𝕡,MM})::unvarSerF{𝕡,MM} where {𝕡<:PREC,𝕢<:PREC} = begin
    𝚊 = bare(ø_amt{𝕡,MM}(𝑎))
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[x->𝚊, 𝑓.fvec...],
        𝑓.mulf.err / 𝕡(1.0e-2)
    )
end

+(𝑎::Measurement{𝕢}, 𝑓::unvarSerF{𝕡,MM})::unvarSerF{𝕡,MM} where {𝕡<:PREC,𝕢<:PREC} = begin
    𝚊 = Measurement{𝕡}(𝑎)
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[x->𝚊, 𝑓.fvec...],
        𝑓.mulf.err / 𝕡(1.0e-2)
    )
end

+(𝑓::unvarSerF{𝕡,𝕩}, 𝑎::Union{REAL,AbstractFloat}) where {𝕡<:PREC,𝕩<:EXAC} = +(𝑎, 𝑓) # Fallback

-(𝑓::unvarSerF{𝕡,EX}) where 𝕡<:PREC = begin
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[[x->(-fi(x)) for fi in 𝑓.fvec]...]
    )
end

-(𝑓::unvarSerF{𝕡,MM}) where 𝕡<:PREC = begin
    return unvarSerF(
        𝑓.xmin,
        𝑓.xmax,
        Function[[x->(-fi(x)) for fi in 𝑓.fvec]...],
        𝑓.mulf.err / 𝕡(1.0e-2)
    )
end

-(𝑓::unvarSerF{𝕡,𝕩}, 𝑎::Union{REAL,AbstractFloat}) where {𝕡<:PREC,𝕩<:EXAC} = +(-𝑎, 𝑓) # Fallback

-(𝑎::Union{REAL,AbstractFloat}, 𝑓::unvarSerF{𝕡,𝕩}) where {𝕡<:PREC,𝕩<:EXAC} = +(𝑎, -𝑓) # Fallback


#----------------------------------------------------------------------------------------------#
#                             Other Functions involving unvarSerF                              #
#----------------------------------------------------------------------------------------------#



