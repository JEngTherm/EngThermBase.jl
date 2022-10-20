#==============================================================================================#
#                                     Concrete State Types                                     #
#==============================================================================================#

#----------------------------------------------------------------------------------------------#
#                                     Property Pair States                                     #
#----------------------------------------------------------------------------------------------#

#······························································································#
#                                         TPPair{𝕡,𝕩}                                          #
#······························································································#

struct TPPair{𝕡,𝕩} <: PropPair{𝕡,𝕩}
    T::T_amt{𝕡,𝕩}
    P::P_amt{𝕡,𝕩}
    # Inner, non-converting constructor
    TPPair(_T::T_amt{𝕡,𝕩}, _P::P_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC} = begin
        @assert pod(_T) > zero(𝕡)
        @assert pod(_P) > zero(𝕡)
        new{𝕡,𝕩}(_T, _P)
    end
    # Fallback constructors
    TPPair(_P::P_amt{𝕡,𝕩}, _T::T_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC} = TPPair(_T, _P)
    TPPair(_x::Tuple{T_amt{𝕡,𝕩}, P_amt{𝕡,𝕩}}) where {𝕡<:PREC, 𝕩<:EXAC} = TPPair(_x...)
    TPPair(_x::Tuple{P_amt{𝕡,𝕩}, T_amt{𝕡,𝕩}}) where {𝕡<:PREC, 𝕩<:EXAC} = TPPair(_x[2], _x[1])
    # Missing argument constructors
    TPPair(_T::T_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC} = TPPair(_T, P_(𝕡,𝕩))
    TPPair(_P::P_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC} = TPPair(T_(𝕡,𝕩), _P)
    TPPair(P::Type{𝕡}=Float64, X::Type{𝕩}=DEF[:XB]) where {𝕡<:PREC,𝕩<:EXAC} =
        TPPair(T_(𝕡,𝕩), P_(𝕡,𝕩))
end
# External, converting constructors
(::TPPair{𝕡,𝕩})(x::TPPair{𝕤,𝕪}) where {𝕡<:PREC,𝕤<:PREC,𝕩<:EXAC,𝕪<:EXAC} = begin
    TPPair(T_amt{𝕡,𝕩}(x.T), P_amt{𝕡,𝕩}(x.P))
end
# Promotion rules
promote_rule(::Type{TPPair{𝕤,𝕪}},
             ::Type{TPPair{𝕡,𝕩}}) where {𝕤<:PREC,𝕡<:PREC,𝕪<:EXAC,𝕩<:EXAC} = begin
    TPPair{promote_type(𝕤,𝕡),promote_type(𝕪,𝕩)}
end
# Conversions
convert(::Type{TPPair{𝕤,𝕪}},
        y::TPPair{𝕡,𝕩}) where {𝕤<:PREC,𝕡<:PREC,𝕪<:EXAC,𝕩<:EXAC} = begin
    TPPair{promote_type(𝕤,𝕡),promote_type(𝕪,𝕩)}(y)
end
# Exporting
export TPPair


