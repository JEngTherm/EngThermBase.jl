#==============================================================================================#
#                                Concrete Property Combo Types                                 #
#==============================================================================================#

#----------------------------------------------------------------------------------------------#
#                                       ChF Pair Combos                                        #
#----------------------------------------------------------------------------------------------#

#······························································································#
#                                         TvPair{𝕡,𝕩}                                          #
#······························································································#

struct TvPair{𝕡,𝕩,𝕓} <: ChFPair{𝕡,𝕩} where 𝕓
    T::T_amt{𝕡,𝕩}
    v::v_amt{𝕡,𝕩,𝕓}
    # Inner, non-converting constructor
    TvPair(_T::T_amt{𝕡,𝕩}, _v::v_amt{𝕡,𝕩,𝕓}) where {𝕡<:PREC, 𝕩<:EXAC, 𝕓<:IntBase} = begin
        @assert pod(_T) > zero(𝕡)
        @assert pod(_v) > zero(𝕡)
        new{𝕡,𝕩,𝕓}(_T, _v)
    end
    # Fallback constructors
    TvPair(_v::v_amt{𝕡,𝕩,𝕓}, _T::T_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC, 𝕓<:IntBase} = begin
        TvPair(_T, _v)
    end
    TvPair(_x::Tuple{T_amt{𝕡,𝕩}, v_amt{𝕡,𝕩,𝕓}}) where {𝕡<:PREC, 𝕩<:EXAC, 𝕓<:IntBase} = begin
        TvPair(_x...)
    end
    TvPair(_x::Tuple{v_amt{𝕡,𝕩,𝕓}, T_amt{𝕡,𝕩}}) where {𝕡<:PREC, 𝕩<:EXAC, 𝕓<:IntBase} = begin
        TvPair(_x[2], _x[1])
    end
    # Missing argument constructors
    TvPair(_v::v_amt{𝕡,𝕩,𝕓}) where {𝕡<:PREC, 𝕩<:EXAC, 𝕓<:IntBase} = TvPair(T_(𝕡,𝕩), _v)
end

# External, converting constructors
(::TvPair{𝕡,𝕩,𝕓})(x::TvPair{𝕤,𝕪,𝕓}) where {𝕡<:PREC,𝕤<:PREC,𝕩<:EXAC,𝕪<:EXAC,𝕓<:IntBase} = begin
    TvPair(T_amt{𝕡,𝕩}(x.T), v_amt{𝕡,𝕩,𝕓}(x.v))
end

# Promotion rules
promote_rule(::Type{TvPair{𝕤,𝕪}},
             ::Type{TvPair{𝕡,𝕩}}) where {𝕤<:PREC,𝕡<:PREC,𝕪<:EXAC,𝕩<:EXAC} = begin
    TvPair{promote_type(𝕤,𝕡),promote_type(𝕪,𝕩)}
end

# Conversions
convert(::Type{TvPair{𝕤,𝕪}},
        y::TvPair{𝕡,𝕩}) where {𝕤<:PREC,𝕡<:PREC,𝕪<:EXAC,𝕩<:EXAC} = begin
    TvPair{promote_type(𝕤,𝕡),promote_type(𝕪,𝕩)}(y)
end

# Exporting
export TvPair


#----------------------------------------------------------------------------------------------#
#                                       EoS Pair Combos                                        #
#----------------------------------------------------------------------------------------------#

#······························································································#
#                                         TPPair{𝕡,𝕩}                                          #
#······························································································#

struct TPPair{𝕡,𝕩} <: EoSPair{𝕡,𝕩}
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


#······························································································#
#                                         PvPair{𝕡,𝕩}                                          #
#······························································································#

struct PvPair{𝕡,𝕩,𝕓} <: EoSPair{𝕡,𝕩} where 𝕓
    P::P_amt{𝕡,𝕩}
    v::v_amt{𝕡,𝕩,𝕓}
    # Inner, non-converting constructor
    PvPair(_P::P_amt{𝕡,𝕩}, _v::v_amt{𝕡,𝕩,𝕓}) where {𝕡<:PREC, 𝕩<:EXAC, 𝕓<:IntBase} = begin
        @assert pod(_P) > zero(𝕡)
        @assert pod(_v) > zero(𝕡)
        new{𝕡,𝕩,𝕓}(_P, _v)
    end
    # Fallback constructors
    PvPair(_v::v_amt{𝕡,𝕩,𝕓}, _P::P_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC, 𝕓<:IntBase} = begin
        PvPair(_P, _v)
    end
    PvPair(_x::Tuple{P_amt{𝕡,𝕩}, v_amt{𝕡,𝕩,𝕓}}) where {𝕡<:PREC, 𝕩<:EXAC, 𝕓<:IntBase} = begin
        PvPair(_x...)
    end
    PvPair(_x::Tuple{v_amt{𝕡,𝕩,𝕓}, P_amt{𝕡,𝕩}}) where {𝕡<:PREC, 𝕩<:EXAC, 𝕓<:IntBase} = begin
        PvPair(_x[2], _x[1])
    end
    # Missing argument constructors
    PvPair(_v::v_amt{𝕡,𝕩,𝕓}) where {𝕡<:PREC, 𝕩<:EXAC, 𝕓<:IntBase} = PvPair(P_(𝕡,𝕩), _v)
end

# External, converting constructors
(::PvPair{𝕡,𝕩,𝕓})(x::PvPair{𝕤,𝕪,𝕓}) where {𝕡<:PREC,𝕤<:PREC,𝕩<:EXAC,𝕪<:EXAC,𝕓<:IntBase} = begin
    PvPair(P_amt{𝕡,𝕩}(x.P), v_amt{𝕡,𝕩,𝕓}(x.v))
end

# Promotion rules
promote_rule(::Type{PvPair{𝕤,𝕪}},
             ::Type{PvPair{𝕡,𝕩}}) where {𝕤<:PREC,𝕡<:PREC,𝕪<:EXAC,𝕩<:EXAC} = begin
    PvPair{promote_type(𝕤,𝕡),promote_type(𝕪,𝕩)}
end

# Conversions
convert(::Type{PvPair{𝕤,𝕪}},
        y::PvPair{𝕡,𝕩}) where {𝕤<:PREC,𝕡<:PREC,𝕪<:EXAC,𝕩<:EXAC} = begin
    PvPair{promote_type(𝕤,𝕡),promote_type(𝕪,𝕩)}(y)
end

# Exporting
export PvPair


#----------------------------------------------------------------------------------------------#
#                             PropPair Property Combo Type Unions                              #
#----------------------------------------------------------------------------------------------#

# Pairs having temperature
hasTPair{𝕡,𝕩} = Union{TPPair{𝕡,𝕩},TvPair{𝕡,𝕩}} where {𝕡<:PREC,𝕩<:EXAC}

# Pairs having pressure
hasPPair{𝕡,𝕩} = Union{TPPair{𝕡,𝕩},PvPair{𝕡,𝕩}} where {𝕡<:PREC,𝕩<:EXAC}

# Pairs having specific volume
hasvPair{𝕡,𝕩,𝕓} = Union{TvPair{𝕡,𝕩,𝕓},PvPair{𝕡,𝕩,𝕓}} where {𝕡<:PREC,𝕩<:EXAC,𝕓<:IntBase}

# Export
export hasTPair, hasPPair, hasvPair


#----------------------------------------------------------------------------------------------#
#                                     Property Trio Combos                                     #
#----------------------------------------------------------------------------------------------#

#······························································································#
#                                         TPxTrio{𝕡,𝕩}                                         #
#······························································································#

struct TPxTrio{𝕡,𝕩} <: PropTrio{𝕡,𝕩}
    T::T_amt{𝕡,𝕩}
    P::P_amt{𝕡,𝕩}
    x::x_amt{𝕡,𝕩}
    # Inner, non-converting constructor
    TPxTrio(_T::T_amt{𝕡,𝕩}, _P::P_amt{𝕡,𝕩}, _x::x_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC} = begin
        @assert pod(_T) > zero(𝕡)
        @assert pod(_P) > zero(𝕡)
        @assert pod(_x) >= zero(𝕡)
        @assert pod(_x) <= one(𝕡)
        new{𝕡,𝕩}(_T, _P, _x)
    end
    # Fallback constructors -- all 6 argument permutations
    TPxTrio(_x::x_amt{𝕡,𝕩}, _T::T_amt{𝕡,𝕩}, _P::P_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC} = begin
        TPxTrio(_T, _P, _x)
    end
    TPxTrio(_P::P_amt{𝕡,𝕩}, _x::x_amt{𝕡,𝕩}, _T::T_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC} = begin
        TPxTrio(_T, _P, _x)
    end
    TPxTrio(_P::P_amt{𝕡,𝕩}, _T::T_amt{𝕡,𝕩}, _x::x_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC} = begin
        TPxTrio(_T, _P, _x)
    end
    TPxTrio(_x::x_amt{𝕡,𝕩}, _P::P_amt{𝕡,𝕩}, _T::T_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC} = begin
        TPxTrio(_T, _P, _x)
    end
    TPxTrio(_T::T_amt{𝕡,𝕩}, _x::x_amt{𝕡,𝕩}, _P::P_amt{𝕡,𝕩}) where {𝕡<:PREC, 𝕩<:EXAC} = begin
        TPxTrio(_T, _P, _x)
    end
    # Fallback Tuple constructor
    TPxTrio(_y::NTuple{3,Union{T_amt, P_amt, x_amt}}) = TPxTrio(_y...)
end

# External, converting constructors
(::TPxTrio{𝕡,𝕩})(y::TPxTrio{𝕤,𝕪}) where {𝕡<:PREC,𝕤<:PREC,𝕩<:EXAC,𝕪<:EXAC} = begin
    TPxTrio(T_amt{𝕡,𝕩}(y.T), P_amt{𝕡,𝕩}(y.P), x_amt{𝕡,𝕩}(y.x))
end

# Promotion rules
promote_rule(::Type{TPxTrio{𝕤,𝕪}},
             ::Type{TPxTrio{𝕡,𝕩}}) where {𝕤<:PREC,𝕡<:PREC,𝕪<:EXAC,𝕩<:EXAC} = begin
    TPxTrio{promote_type(𝕤,𝕡),promote_type(𝕪,𝕩)}
end

# Conversions
convert(::Type{TPxTrio{𝕤,𝕪}},
        y::TPxTrio{𝕡,𝕩}) where {𝕤<:PREC,𝕡<:PREC,𝕪<:EXAC,𝕩<:EXAC} = begin
    TPxTrio{promote_type(𝕤,𝕡),promote_type(𝕪,𝕩)}(y)
end

# Exporting
export TPxTrio


#----------------------------------------------------------------------------------------------#
#                             PropTrio Property Combo Type Unions                              #
#----------------------------------------------------------------------------------------------#

# Trios having temperature
hasTTrio{𝕡,𝕩} = Union{TPxTrio{𝕡,𝕩}} where {𝕡<:PREC,𝕩<:EXAC}

# Trios having pressure
hasPTrio{𝕡,𝕩} = Union{TPxTrio{𝕡,𝕩}} where {𝕡<:PREC,𝕩<:EXAC}

# Trios having title / quality
hasxTrio{𝕡,𝕩} = Union{TPxTrio{𝕡,𝕩}} where {𝕡<:PREC,𝕩<:EXAC}

# Export
export hasTTrio, hasPTrio, hasxTrio


#----------------------------------------------------------------------------------------------#
#                              Generic Property Combo Type Unions                              #
#----------------------------------------------------------------------------------------------#

# Combos having [___] (names are self-explanatory):
# 2-parameter ones:
hasT{𝕡,𝕩} = Union{hasTPair{𝕡,𝕩}, hasTTrio{𝕡,𝕩}} where {𝕡<:PREC,𝕩<:EXAC}
hasP{𝕡,𝕩} = Union{hasPPair{𝕡,𝕩}, hasPTrio{𝕡,𝕩}} where {𝕡<:PREC,𝕩<:EXAC}
hasx{𝕡,𝕩} = Union{hasxTrio{𝕡,𝕩}} where {𝕡<:PREC,𝕩<:EXAC}

# 3-parameter ones:
hasv{𝕡,𝕩,𝕓} = Union{hasvPair{𝕡,𝕩,𝕓}} where {𝕡<:PREC,𝕩<:EXAC,𝕓<:IntBase}

export hasT, hasP, hasx, hasv


