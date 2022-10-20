#==============================================================================================#
#                                     Concrete State Types                                     #
#==============================================================================================#

#----------------------------------------------------------------------------------------------#
#                                     Property Pair States                                     #
#----------------------------------------------------------------------------------------------#

#······························································································#
#                                         TPPair{𝗽,𝘅}                                          #
#······························································································#

struct TPPair{𝗽,𝘅} <: PropPair{𝗽,𝘅}
    T::T_amt{𝗽,𝘅}
    P::P_amt{𝗽,𝘅}
    # Inner, non-converting constructor
    TPPair(_T::T_amt{𝗽,𝘅}, _P::P_amt{𝗽,𝘅}) where {𝗽<:PREC, 𝘅<:EXAC} = begin
        @assert pod(_T) > zero(𝗽)
        @assert pod(_P) > zero(𝗽)
        new{𝗽,𝘅}(_T, _P)
    end
    # Fallback constructors
    TPPair(_P::P_amt{𝗽,𝘅}, _T::T_amt{𝗽,𝘅}) where {𝗽<:PREC, 𝘅<:EXAC} = TPPair(_T, _P)
    TPPair(_x::Tuple{T_amt{𝗽,𝘅}, P_amt{𝗽,𝘅}}) where {𝗽<:PREC, 𝘅<:EXAC} = TPPair(_x...)
    TPPair(_x::Tuple{P_amt{𝗽,𝘅}, T_amt{𝗽,𝘅}}) where {𝗽<:PREC, 𝘅<:EXAC} = TPPair(_x[2], _x[1])
    # Missing argument constructors
    TPPair(_T::T_amt{𝗽,𝘅}) where {𝗽<:PREC, 𝘅<:EXAC} = TPPair(_T, P_(𝗽,𝘅))
    TPPair(_P::P_amt{𝗽,𝘅}) where {𝗽<:PREC, 𝘅<:EXAC} = TPPair(T_(𝗽,𝘅), _P)
    TPPair(p::PREC=Float64, x::EXAC=DEF[:XB]) = TPPair(T_(𝗽,𝘅), P_(𝗽,𝘅))
end
# External, converting constructors
(TPPair{𝗽,𝘅})(x::TPPair{𝘀,𝘆}) where {𝗽<:PREC,𝘀<:PREC,𝘅<:EXAC,y<:EXAC} = begin
    TPPair(T_amt{𝗽,𝘅}(x.T), P_amt{𝗽,𝘅}(x.P))
end
# Promotion rules
promote_rule(::Type{TPPair{𝘀,𝘆}},
             ::Type{TPPair{𝗽,𝘅}}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
    TPPair{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}
end
# Conversions
convert(::Type{TPPair{𝘀,𝘆}},
        y::TPPair{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
    TPPair{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}(y)
end
# Exporting
export TPPair


