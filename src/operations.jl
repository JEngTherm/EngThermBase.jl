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
    elseif  D == dimension(u"s");           time(X)
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
#                              Known-type Products and Divisions                               #
#----------------------------------------------------------------------------------------------#



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


