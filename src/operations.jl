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
    if      D == dimension(1);              _Amt(X)     # gen.fallback (Z, γ, k, Ma, Pr, vr)
    # --- WholeAmt
    elseif  D == dimension(u"K");           sysT(X)
    elseif  D == dimension(u"kPa");         sysP(X)
    elseif  D == dimension(u"m/s");         VELO(X)     # 𝕍   fallback (𝕧, 𝕔)
    elseif  D == dimension(u"s");           TIME(X)
    elseif  D == dimension(u"m/s^2");       grav(X)
    elseif  D == dimension(u"m");           alti(X)
    # --- WholeAmt - Derived
    elseif  D == dimension(inv(u"K"));      beta(X)
    elseif  D == dimension(inv(u"kPa"));    kapT(X)     # κT  fallback (κS)
    elseif  D == dimension(u"K/kPa");       muJT(X)     # μJT fallback (μS)
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
#                                   Known-type Sums and Subs                                   #
#----------------------------------------------------------------------------------------------#

#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
#                                           u and h                                            #
#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# u + Pv --> h  with Unitful promotion
+(x::uAmt{𝗽,𝘅,𝗯}, y::PvAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    h(+(amt(x), amt(y)))
end
+(y::PvAmt{𝘀,𝘆,𝗯}, x::uAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x + y        # as to fallback
# u + RT --> h  with Unitful promotion
+(x::uAmt{𝗽,𝘅,𝗯}, y::RTAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    h(+(amt(x), amt(y)))
end
+(y::RTAmt{𝘀,𝘆,𝗯}, x::uAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x + y        # as to fallback

# h - Pv --> u  with Unitful promotion
-(x::hAmt{𝗽,𝘅,𝗯}, y::PvAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    u(-(amt(x), amt(y)))
end
-(y::PvAmt{𝘀,𝘆,𝗯}, x::hAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback
# h - RT --> u  with Unitful promotion
-(x::hAmt{𝗽,𝘅,𝗯}, y::RTAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    u(-(amt(x), amt(y)))
end
-(y::RTAmt{𝘀,𝘆,𝗯}, x::hAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback


#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
#                                           u and a                                            #
#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# a + Ts --> u  with Unitful promotion
+(x::aAmt{𝗽,𝘅,𝗯}, y::TsAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    u(+(amt(x), amt(y)))
end
+(y::TsAmt{𝘀,𝘆,𝗯}, x::aAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x + y        # as to fallback

# u - Ts --> a  with Unitful promotion
-(x::uAmt{𝗽,𝘅,𝗯}, y::TsAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    a(-(amt(x), amt(y)))
end
-(y::TsAmt{𝘀,𝘆,𝗯}, x::uAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback


#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
#                                           h and g                                            #
#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# g + Ts --> h  with Unitful promotion
+(x::gAmt{𝗽,𝘅,𝗯}, y::TsAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    h(+(amt(x), amt(y)))
end
+(y::TsAmt{𝘀,𝘆,𝗯}, x::gAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x + y        # as to fallback

# h - Ts --> g  with Unitful promotion
-(x::hAmt{𝗽,𝘅,𝗯}, y::TsAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    g(-(amt(x), amt(y)))
end
-(y::TsAmt{𝘀,𝘆,𝗯}, x::hAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback


#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
#                                           a and g                                            #
#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# a + Pv --> g  with Unitful promotion
+(x::aAmt{𝗽,𝘅,𝗯}, y::PvAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    g(+(amt(x), amt(y)))
end
+(y::PvAmt{𝘀,𝘆,𝗯}, x::aAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x + y        # as to fallback
# a + RT --> g  with Unitful promotion
+(x::aAmt{𝗽,𝘅,𝗯}, y::RTAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    g(+(amt(x), amt(y)))
end
+(y::RTAmt{𝘀,𝘆,𝗯}, x::aAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x + y        # as to fallback

# g - Pv --> a  with Unitful promotion
-(x::gAmt{𝗽,𝘅,𝗯}, y::PvAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    a(-(amt(x), amt(y)))
end
-(y::PvAmt{𝘀,𝘆,𝗯}, x::gAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback
# g - RT --> a  with Unitful promotion
-(x::gAmt{𝗽,𝘅,𝗯}, y::RTAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    a(-(amt(x), amt(y)))
end
-(y::RTAmt{𝘀,𝘆,𝗯}, x::gAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback


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
#                           Generic (fallback) Sums and Subtractions                           #
#----------------------------------------------------------------------------------------------#

+(x::AMOUNTS, y::Union{Real,Quantity}) =  x + _Amt(y)
+(y::Union{Real,Quantity}, x::AMOUNTS) =  x + y          # fallsback
-(x::AMOUNTS, y::Union{Real,Quantity}) =  x - _Amt(y)
-(y::Union{Real,Quantity}, x::AMOUNTS) = -x + y          # fallsback


#----------------------------------------------------------------------------------------------#
#                              Known-type Products and Divisions                               #
#----------------------------------------------------------------------------------------------#

# MA-based * mass => SY-based; with Unitful promotion
*(x::BasedAmt{𝗽,𝘅,MA}, y::mAmt{𝘀,𝘆,SY}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(*(amt(x), amt(y)))
end
*(y::mAmt{𝘀,𝘆,SY}, x::BasedAmt{𝗽,𝘅,MA}) where {𝗽,𝘀,𝘅,𝘆} = x * y     # as to fallback

# MA-based * mass-DT => DT-based; with Unitful promotion
*(x::BasedAmt{𝗽,𝘅,MA}, y::mAmt{𝘀,𝘆,DT}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(*(amt(x), amt(y)))
end
*(y::mAmt{𝘀,𝘆,DT}, x::BasedAmt{𝗽,𝘅,MA}) where {𝗽,𝘀,𝘅,𝘆} = x * y     # as to fallback

# MO-based * mole => SY-based; with Unitful promotion
*(x::BasedAmt{𝗽,𝘅,MO}, y::nAmt{𝘀,𝘆,SY}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(*(amt(x), amt(y)))
end
*(y::nAmt{𝘀,𝘆,SY}, x::BasedAmt{𝗽,𝘅,MO}) where {𝗽,𝘀,𝘅,𝘆} = x * y     # as to fallback

# MO-based * mole-DT => SY-based; with Unitful promotion
*(x::BasedAmt{𝗽,𝘅,MO}, y::nAmt{𝘀,𝘆,DT}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(*(amt(x), amt(y)))
end
*(y::nAmt{𝘀,𝘆,DT}, x::BasedAmt{𝗽,𝘅,MO}) where {𝗽,𝘀,𝘅,𝘆} = x * y     # as to fallback

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


# DT-based / mass-DT => MA-based; with Unitful promotion
# DT-based / mole-DT => MO-based; with Unitful promotion
/(x::BasedAmt{𝗽,𝘅,DT}, y::Union{mAmt{𝘀,𝘆,DT},nAmt{𝘀,𝘆,DT}}) where {𝗽,𝘀,𝘅,𝘆} = begin
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


# MA-based / MA-based mole => MO-based; with Unitful promotion
/(x::BasedAmt{𝗽,𝘅,MA}, y::nAmt{𝘀,𝘆,MA}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(/(amt(x), amt(y)))
end

# MO-based / MO-based mass => MA-based; with Unitful promotion
/(x::BasedAmt{𝗽,𝘅,MO}, y::mAmt{𝘀,𝘆,MO}) where {𝗽,𝘀,𝘅,𝘆} = begin
    (typeof(x).name.wrapper)(/(amt(x), amt(y)))
end


# Ma from velocity ratios (as this is just labeling dimensionless velocity ratios)
/(x::VELOCYP{𝗽,𝘅}, y::VELOCYP{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    Ma(/(promote(map(x -> amt(x), (x, y))...)...))
end

# γ from entropy amount ratios (as specific heats might auto-convert to ΔsAmt's)
/(x::NTROPYA{𝗽,𝘅}, y::NTROPYA{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    γ(/(promote(map(x -> amt(x), (x, y))...)...))
end


# P * v --> Pv
*(x::sysP{𝗽,𝘅}, y::vAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    Pv(*(amt(x), amt(y)))
end
*(y::vAmt{𝘀,𝘆,𝗯}, x::sysP{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x * y           # as to fallback

# R * T --> RT
*(x::sysT{𝗽,𝘅}, y::RAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    RT(*(amt(x), amt(y)))
end
*(y::RAmt{𝘀,𝘆,𝗯}, x::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x * y           # as to fallback

# T * s --> Ts
*(x::sysT{𝗽,𝘅}, y::sAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    Ts(*(amt(x), amt(y)))
end
*(y::sAmt{𝘀,𝘆,𝗯}, x::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x * y           # as to fallback


# RT / T --> R
/(x::RTAmt{𝘀,𝘆,𝗯}, y::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    R(/(amt(x), amt(y)))
end

# Ts / T --> s
/(x::TsAmt{𝘀,𝘆,𝗯}, y::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    s(/(amt(x), amt(y)))
end

# Pv / RT --> Z
/(x::PvAmt{𝗽,𝘅,𝗯}, y::RTAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    Z(/(amt(x), amt(y)))
end

# Pv / Z --> RT
/(x::PvAmt{𝗽,𝘅,𝗯}, y::ZAmt{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    RT(/(amt(x), amt(y)))
end

# Z * RT --> Pv
*(x::ZAmt{𝗽,𝘅}, y::RTAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    Pv(*(amt(x), amt(y)))
end
*(y::RTAmt{𝘀,𝘆,𝗯}, x::ZAmt{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x * y           # as to fallback


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


#----------------------------------------------------------------------------------------------#

import Base: ^, sqrt, cbrt

^(x::AMOUNTS, y::Real) = AMT(^(amt(x), y))
sqrt(x::AMOUNTS) = AMT(sqrt(amt(x)))
cbrt(x::AMOUNTS) = AMT(cbrt(amt(x)))


#----------------------------------------------------------------------------------------------#

import Base: log, log2, log10

log(x::AMOUNTS) = _Amt(log(amt(x).val))
log2(x::AMOUNTS) = _Amt(log2(amt(x).val))
log10(x::AMOUNTS) = _Amt(log10(amt(x).val))


#----------------------------------------------------------------------------------------------#

import Base: real, float, abs, abs2, min, max

real(x::AMOUNTS) = x
float(x::AMOUNTS) = x
abs(x::𝗧) where 𝗧<:AMOUNTS = (𝗧.name.wrapper)(abs(amt(x)))
abs2(x::AMOUNTS) = x^2

min(x::𝗧...) where 𝗧<:AMOUNTS = (𝗧.name.wrapper)(min((amt(i) for i in x)...))
max(x::𝗧...) where 𝗧<:AMOUNTS = (𝗧.name.wrapper)(max((amt(i) for i in x)...))


#----------------------------------------------------------------------------------------------#

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


#----------------------------------------------------------------------------------------------#

import Base: prevfloat, nextfloat, zero, one, typemin, typemax

prevfloat(x::𝗧) where 𝗧<:AMOUNTS = (𝗧.name.wrapper)(prevfloat(amt(x)))
nextfloat(x::𝗧) where 𝗧<:AMOUNTS = (𝗧.name.wrapper)(nextfloat(amt(x)))

zero(::Type{𝗧}) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗧(zero(𝗽))
zero(x::𝗧) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗧(zero(𝗽))

one(::Type{𝗧}) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗧(one(𝗽))
one(x::𝗧) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗧(one(𝗽))

typemin(::Type{𝗧}) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗧(typemin(𝗽))
typemin(x::𝗧) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗧(typemin(𝗽))

typemax(::Type{𝗧}) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗧(typemax(𝗽))
typemax(x::𝗧) where 𝗧<:AMOUNTS{𝗽} where 𝗽 = 𝗧(typemax(𝗽))


#----------------------------------------------------------------------------------------------#

import Base: floor, ceil, trunc, round, sign, signbit

for FUN in (:floor, :ceil, :trunc, :round)
    @eval $FUN(x::𝗧) where 𝗧<:AMOUNTS = (𝗧.name.wrapper)(($FUN)(amt(x).val) * unit(amt(x)))
end

round(x::𝗧, r::RoundingMode; digits, sigdigits, base) where 𝗧<:AMOUNTS = begin
    (𝗧.name.wrapper)(round(amt(x).val, r,
                           digits=digits,
                           sigdigits=sigdigits,
                           base=base) * unit(amt(x)))
end

for FUN in (:sign, :signbit)
    @eval $FUN(x::𝗧) where 𝗧<:AMOUNTS = ($FUN)(amt(x))
end


#----------------------------------------------------------------------------------------------#

import Base: isfinite, isnan, isinf

for FUN in (:isfinite, :isnan, :isinf)
    @eval $FUN(x::𝗧) where 𝗧<:AMOUNTS = ($FUN)(amt(x))
end


#----------------------------------------------------------------------------------------------#


import Base: ==, >, <, isequal, isless, isapprox

==(x::𝗧, y::𝗧) where 𝗧<:AMOUNTS = begin
    # We don't care about the 3 least significant bits of the wider type
    RTOL = (1<<3) * Base.rtoldefault(amt(x), amt(y), 0)
    isapprox(amt(x), amt(y), rtol=RTOL)
end

for FUN in (:>, :<, :isequal, :isless)
    @eval ($FUN)(x::𝗧, y::𝗧) where 𝗧<:AMOUNTS = ($FUN)(amt(x),amt(y))
end

function isapprox(x::𝗧, y::𝗧; atol::Real=0,
                  rtol::Real = Base.rtoldefault(amt(x), amt(y), atol),
                  nans::Bool=false) where 𝗧<:AMOUNTS
    isapprox(amt(x), amt(y), atol=atol, rtol=rtol, nans=nans)
end


