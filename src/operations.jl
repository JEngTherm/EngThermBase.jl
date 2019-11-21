#----------------------------------------------------------------------------------------------#
#                                 Dimensions-based Conversions                                 #
#----------------------------------------------------------------------------------------------#

"""
`function AMT(x::Number)`\n
Generates the default `AMOUNTS` from `a`, based on its unit dimensions.  The eltype-undecorated
`Quantity` constructors are evoked, so that the resulting type precision is taken from the `x`
argument. This function is extensively used in operations that result in a unit change.
"""
function AMT(x::Number)
    X, D = float(real(x)), dimension(x)
    # --- GenerAmt default
    if      D == dimension(1);              _Amt(X)
    # --- WholeAmt
    elseif  D == dimension(u"K");           sysT(X)
    elseif  D == dimension(u"kPa");         sysP(X)
    elseif  D == dimension(u"m/s");         VELO(X)
    elseif  D == dimension(u"s");           TIME(X)
    elseif  D == dimension(u"m/s^2");       grav(X)
    elseif  D == dimension(u"m");           alti(X)
    # --- BasedAmt
    elseif  D == dimension(u"kg");          mAmt(X)
    elseif  D == dimension(u"kg/s");        mAmt(X)
    elseif  D == dimension(u"kg/kmol");     mAmt(X)
    elseif  D == dimension(u"kmol");        nAmt(X)
    elseif  D == dimension(u"kmol/s");      nAmt(X)
    elseif  D == dimension(u"kmol/kg");     nAmt(X)
    elseif  D == dimension(u"m^3");         vAmt(X)
    elseif  D == dimension(u"m^3/s");       vAmt(X)
    elseif  D == dimension(u"m^3/kg");      vAmt(X)
    elseif  D == dimension(u"m^3/kmol");    vAmt(X)
    elseif  D == dimension(u"kJ");          ΔeAmt(X)    # energy fallback
    elseif  D == dimension(u"kJ/s");        ΔeAmt(X)
    elseif  D == dimension(u"kJ/kg");       ΔeAmt(X)
    elseif  D == dimension(u"kJ/kmol");     ΔeAmt(X)
    elseif  D == dimension(u"kJ/K");        ΔsAmt(X)    # ntropy fallback
    elseif  D == dimension(u"kJ/K/s");      ΔsAmt(X)
    elseif  D == dimension(u"kJ/K/kg");     ΔsAmt(X)
    elseif  D == dimension(u"kJ/K/kmol");   ΔsAmt(X)
    # --- GenerAmt fallback
    else                                    _Amt(X)
    end
end

export AMT


#----------------------------------------------------------------------------------------------#
#                                     Same-Type Operations                                     #
#----------------------------------------------------------------------------------------------#

+(x::AMOUNTS) = x
-(x::AMOUNTS) = (typeof(x).name.wrapper)(-amt(x))


#----------------------------------------------------------------------------------------------#
#                               Same-Unit (Same-Base) Operations                               #
#----------------------------------------------------------------------------------------------#

# Diff-{type,parameters} converting/promoting sum,sub of same-base energies
+(x::ENERGYA{𝗽,𝘅,𝗯}, y::ENERGYA{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    +(promote(map(x -> ΔeAmt(amt(x)), (x, y))...)...)
end
-(x::ENERGYA{𝗽,𝘅,𝗯}, y::ENERGYA{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    -(promote(map(x -> ΔeAmt(amt(x)), (x, y))...)...)
end

# Diff-{type,parameters} converting/promoting sum,sub of same-base entropies
+(x::NTROPYA{𝗽,𝘅,𝗯}, y::NTROPYA{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    +(promote(map(x -> ΔsAmt(amt(x)), (x, y))...)...)
end
-(x::NTROPYA{𝗽,𝘅,𝗯}, y::NTROPYA{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    -(promote(map(x -> ΔsAmt(amt(x)), (x, y))...)...)
end

# Diff-{type,parameters} converting/promoting sum,sub of velocities
+(x::VELOCYP{𝗽,𝘅}, y::VELOCYP{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    +(promote(map(x -> VELO(amt(x)), (x, y))...)...)
end
-(x::VELOCYP{𝗽,𝘅}, y::VELOCYP{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    -(promote(map(x -> VELO(amt(x)), (x, y))...)...)
end

## # Diff-{type,parameters} converting/promoting sum,sub of GenerAmt's
## +(x::GenerAmt{𝗽,𝘅}, y::GenerAmt{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
##     +(promote(map(x -> _Amt(amt(x)), (x, y))...)...)
## end
## -(x::GenerAmt{𝗽,𝘅}, y::GenerAmt{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
##     -(promote(map(x -> _Amt(amt(x)), (x, y))...)...)
## end

# Diff-{type,parameters} converting/promoting sum,sub of AMOUNTS'
+(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    AMT(amt(+(promote(map(x -> _Amt(amt(x)), (x, y))...)...)))
end
-(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    AMT(amt(-(promote(map(x -> _Amt(amt(x)), (x, y))...)...)))
end


#----------------------------------------------------------------------------------------------#
#                              Known-type Products and Divisions                               #
#----------------------------------------------------------------------------------------------#

# MA-based * mass => SY-based; with Unitful promotion
*(x::BasedAmt{𝗽,𝘅,MA}, y::mAmt{𝘀,𝘆,SY}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(*(amt(x), amt(y)))
end
*(y::mAmt{𝘀,𝘆,SY}, x::BasedAmt{𝗽,𝘅,MA}) where {𝗽,𝘀,𝘅,𝘆} = x * y     # as to fallback

# MO-based * mole => SY-based; with Unitful promotion
*(x::BasedAmt{𝗽,𝘅,MO}, y::nAmt{𝘀,𝘆,SY}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(*(amt(x), amt(y)))
end
*(y::nAmt{𝘀,𝘆,SY}, x::BasedAmt{𝗽,𝘅,MO}) where {𝗽,𝘀,𝘅,𝘆} = x * y     # as to fallback

# DT-based * TIME => SY-based; with Unitful promotion
*(x::BasedAmt{𝗽,𝘅,DT}, y::TIME{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(*(amt(x), amt(y)))
end
*(y::TIME{𝘀,𝘆}, x::BasedAmt{𝗽,𝘅,DT}) where {𝗽,𝘀,𝘅,𝘆} = x * y        # as to fallback


# SY-based / mass => MA-based; with Unitful promotion
# SY-based / mole => MO-based; with Unitful promotion
# SY-based / TIME => DT-based; with Unitful promotion
/(x::BasedAmt{𝗽,𝘅,SY}, y::Union{mAmt{𝘀,𝘆,SY},nAmt{𝘀,𝘆,SY},TIME{𝘀,𝘆}}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(/(amt(x), amt(y)))
end


# MA-based * MO-based mass => MO-based; with Unitful promotion
*(x::BasedAmt{𝗽,𝘅,MA}, y::mAmt{𝘀,𝘆,MO}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(*(amt(x), amt(y)))
end
*(y::mAmt{𝘀,𝘆,MO}, x::BasedAmt{𝗽,𝘅,MA}) where {𝗽,𝘀,𝘅,𝘆} = x * y     # as to fallback

# MO-based * MA-based mole => MA-based; with Unitful promotion
*(x::BasedAmt{𝗽,𝘅,MO}, y::nAmt{𝘀,𝘆,MA}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(*(amt(x), amt(y)))
end
*(y::nAmt{𝘀,𝘆,MA}, x::BasedAmt{𝗽,𝘅,MO}) where {𝗽,𝘀,𝘅,𝘆} = x * y     # as to fallback


#----------------------------------------------------------------------------------------------#
#                          Generic (fallback) Products and Divisions                           #
#----------------------------------------------------------------------------------------------#

*(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝗽,𝘅}) where {𝗽,𝘅} = AMT(*(amt(x), amt(y)))
/(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝗽,𝘅}) where {𝗽,𝘅} = AMT(/(amt(x), amt(y)))

*(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    *(promote(map(x -> _Amt(amt(x)), (x, y))...)...)
end
/(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    /(promote(map(x -> _Amt(amt(x)), (x, y))...)...)
end


#----------------------------------------------------------------------------------------------#
#                                    Other Base operations                                     #
#----------------------------------------------------------------------------------------------#

import Base: inv

inv(x::AMOUNTS) = AMT(inv(amt(x)))


import Base: ^, sqrt, cbrt

^(x::AMOUNTS, y::Real) = AMT(^(amt(x), y))
sqrt(x::AMOUNTS) = AMT(sqrt(amt(x)))
cbrt(x::AMOUNTS) = AMT(cbrt(amt(x)))


import Base: log, log2, log10

log(x::AMOUNTS) = _Amt(log(amt(x).val))
log2(x::AMOUNTS) = _Amt(log2(amt(x).val))
log10(x::AMOUNTS) = _Amt(log10(amt(x).val))


import Base: real, float, abs, abs2, min, max

real(x::AMOUNTS) = x
float(x::AMOUNTS) = x
abs(x::𝗧) where 𝗧<:AMOUNTS = 𝗧(abs(amt(x)))
abs2(x::AMOUNTS) = x^2

min(x::𝗧...) where 𝗧<:AMOUNTS = 𝗧(min((amt(i) for i in x)...))
max(x::𝗧...) where 𝗧<:AMOUNTS = 𝗧(max((amt(i) for i in x)...))


import Base: widen, eps

widen(::Type{𝗧}) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗧.name.wrapper{widen(𝗽)}
widen(x::AMOUNTS) = widen(typeof(x))(x)

eps(::Type{𝗧}) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = (𝗧.name.wrapper)(eps(𝗽))
eps(x::𝗧) where 𝗧<:AMOUNTS = (𝗧.name.wrapper)(eps(amt(x)))

"""
`precof(::Type{𝗧} | x::𝗧) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗽`\n
Returns the precision of the `AMOUNTS` subtype or instance as a `DataType`.
"""
precof(::Type{𝗧}) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗽
precof(x::𝗧) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗽

"""
`exacof(::Type{𝗧} | x::𝗧) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗽`\n
Returns the exactness of the `AMOUNTS` subtype or instance as a `DataType`.
"""
exacof(::Type{𝗧}) where 𝗧<:AMOUNTS{𝗽,𝘅} where {𝗽,𝘅} = 𝘅
exacof(x::𝗧) where 𝗧<:AMOUNTS{𝗽,𝘅} where {𝗽,𝘅} = 𝘅

"""
`baseof(::Type{𝗧} | x::𝗧) where 𝗧<:BasedAmt{𝗽,𝘅,𝗯} where {𝗽,𝘅,𝗯} = 𝗯`\n
Returns the thermodynamic base of the `AMOUNTS` subtype or instance as a `DataType`.
"""
baseof(::Type{𝗧}) where 𝗧<:BasedAmt{𝗽,𝘅,𝗯} where {𝗽,𝘅,𝗯} = 𝗯
baseof(x::𝗧) where 𝗧<:BasedAmt{𝗽,𝘅,𝗯} where {𝗽,𝘅,𝗯} = 𝗯

export precof, exacof, baseof



