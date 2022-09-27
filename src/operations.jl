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
    if      D == dimension(1);              ø_amt(X)     # (Z_, ga, k_, Ma, Pr, vr, _a)
    # --- WholeAmt
    elseif  D == dimension(u"K");           T_amt(X)
    elseif  D == dimension(u"kPa");         P_amt(X)
    elseif  D == dimension(u"m/s");         veamt(X)     # 𝕍 fallback (sp, cs)
    elseif  D == dimension(u"s");           t_amt(X)
    elseif  D == dimension(u"m/s^2");       gvamt(X)
    elseif  D == dimension(u"m");           z_amt(X)
    # --- WholeAmt - Derived
    elseif  D == dimension(inv(u"K"));      beamt(X)
    elseif  D == dimension(inv(u"kPa"));    kTamt(X)    # kT fallback (kS)
    elseif  D == dimension(u"K/kPa");       mJamt(X)    # mJ fallback (mS)
    # --- BasedAmt
    elseif  D == dimension(u"kg");          m_amt(X)
    elseif  D == dimension(u"kg/s");        m_amt(X)
    elseif  D == dimension(u"kg/kmol");     m_amt(X)
    elseif  D == dimension(u"kmol");        n_amt(X)
    elseif  D == dimension(u"kmol/s");      n_amt(X)
    elseif  D == dimension(u"kmol/kg");     n_amt(X)
    elseif  D == dimension(u"m^3");         v_amt(X)
    elseif  D == dimension(u"m^3/s");       v_amt(X)
    elseif  D == dimension(u"m^3/kg");      v_amt(X)
    elseif  D == dimension(u"m^3/kmol");    v_amt(X)
    elseif  D == dimension(u"kJ");          deamt(X)    # energy fallback
    elseif  D == dimension(u"kJ/s");        deamt(X)
    elseif  D == dimension(u"kJ/kg");       deamt(X)
    elseif  D == dimension(u"kJ/kmol");     deamt(X)
    elseif  D == dimension(u"kJ/K");        dsamt(X)    # ntropy fallback
    elseif  D == dimension(u"kJ/K/s");      dsamt(X)
    elseif  D == dimension(u"kJ/K/kg");     dsamt(X)
    elseif  D == dimension(u"kJ/K/kmol");   dsamt(X)
    # --- GenerAmt fallback
    else                                    __amt(X)
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
+(x::u_amt{𝗽,𝘅,𝗯}, y::Pvamt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝗵(+(amt(x), amt(y)))
end
+(y::Pvamt{𝘀,𝘆,𝗯}, x::u_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x + y        # as to fallback

# h - Pv --> u  with Unitful promotion
-(x::h_amt{𝗽,𝘅,𝗯}, y::Pvamt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝘂(-(amt(x), amt(y)))
end
-(y::Pvamt{𝘀,𝘆,𝗯}, x::h_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback

# h - u --> Pv  with Unitful promotion
-(x::h_amt{𝗽,𝘅,𝗯}, y::u_amt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝗣𝘃(-(amt(x), amt(y)))
end
-(y::u_amt{𝘀,𝘆,𝗯}, x::h_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback


#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
#                                           u and a                                            #
#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# a + Ts --> u  with Unitful promotion
+(x::a_amt{𝗽,𝘅,𝗯}, y::Tsamt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝘂(+(amt(x), amt(y)))
end
+(y::Tsamt{𝘀,𝘆,𝗯}, x::a_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x + y        # as to fallback

# u - Ts --> a  with Unitful promotion
-(x::u_amt{𝗽,𝘅,𝗯}, y::Tsamt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝗮(-(amt(x), amt(y)))
end
-(y::Tsamt{𝘀,𝘆,𝗯}, x::u_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback

# u - a --> Ts  with Unitful promotion
-(x::u_amt{𝗽,𝘅,𝗯}, y::a_amt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝗧𝘀(-(amt(x), amt(y)))
end
-(y::a_amt{𝘀,𝘆,𝗯}, x::u_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback


#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
#                                           h and g                                            #
#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# g + Ts --> h  with Unitful promotion
+(x::g_amt{𝗽,𝘅,𝗯}, y::Tsamt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝗵(+(amt(x), amt(y)))
end
+(y::Tsamt{𝘀,𝘆,𝗯}, x::g_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x + y        # as to fallback

# h - Ts --> g  with Unitful promotion
-(x::h_amt{𝗽,𝘅,𝗯}, y::Tsamt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝗴(-(amt(x), amt(y)))
end
-(y::Tsamt{𝘀,𝘆,𝗯}, x::h_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback

# h - g --> Ts  with Unitful promotion
-(x::h_amt{𝗽,𝘅,𝗯}, y::g_amt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝗧𝘀(-(amt(x), amt(y)))
end
-(y::g_amt{𝘀,𝘆,𝗯}, x::h_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback


#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
#                                           a and g                                            #
#⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# a + Pv --> g  with Unitful promotion
+(x::a_amt{𝗽,𝘅,𝗯}, y::Pvamt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝗴(+(amt(x), amt(y)))
end
+(y::Pvamt{𝘀,𝘆,𝗯}, x::a_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x + y        # as to fallback

# g - Pv --> a  with Unitful promotion
-(x::g_amt{𝗽,𝘅,𝗯}, y::Pvamt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝗮(-(amt(x), amt(y)))
end
-(y::Pvamt{𝘀,𝘆,𝗯}, x::g_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback

# g - a --> Pv  with Unitful promotion
-(x::g_amt{𝗽,𝘅,𝗯}, y::a_amt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    𝗣𝘃(-(amt(x), amt(y)))
end
-(y::a_amt{𝘀,𝘆,𝗯}, x::g_amt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = -(x - y)     # as to fallback


#----------------------------------------------------------------------------------------------#
#                               Same-Unit (Same-Base) Operations                               #
#----------------------------------------------------------------------------------------------#

# Diff-{type,parameters} converting/promoting sum,sub of same-base energies
+(x::ENERGYA{𝗽,𝘅,𝗯}, y::ENERGYA{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    +(promote(map(x -> deamt(amt(x)), (x, y))...)...)
end
-(x::ENERGYA{𝗽,𝘅,𝗯}, y::ENERGYA{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    -(promote(map(x -> deamt(amt(x)), (x, y))...)...)
end

# Diff-{type,parameters} converting/promoting sum,sub of same-base entropies
+(x::NTROPYA{𝗽,𝘅,𝗯}, y::NTROPYA{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    +(promote(map(x -> dsamt(amt(x)), (x, y))...)...)
end
-(x::NTROPYA{𝗽,𝘅,𝗯}, y::NTROPYA{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    -(promote(map(x -> dsamt(amt(x)), (x, y))...)...)
end

# Diff-{type,parameters} converting/promoting sum,sub of velocities
+(x::VELOCYP{𝗽,𝘅}, y::VELOCYP{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    +(promote(map(x -> veamt(amt(x)), (x, y))...)...)
end
-(x::VELOCYP{𝗽,𝘅}, y::VELOCYP{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    -(promote(map(x -> veamt(amt(x)), (x, y))...)...)
end

## # Diff-{type,parameters} converting/promoting sum,sub of GenerAmt's
## +(x::GenerAmt{𝗽,𝘅}, y::GenerAmt{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
##     +(promote(map(x -> __amt(amt(x)), (x, y))...)...)
## end
## -(x::GenerAmt{𝗽,𝘅}, y::GenerAmt{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
##     -(promote(map(x -> __amt(amt(x)), (x, y))...)...)
## end

# Diff-{type,parameters} converting/promoting sum,sub of AMOUNTS'
+(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    AMT(amt(+(promote(map(x -> __amt(amt(x)), (x, y))...)...)))
end
-(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    AMT(amt(-(promote(map(x -> __amt(amt(x)), (x, y))...)...)))
end


#----------------------------------------------------------------------------------------------#
#                           Generic (fallback) Sums and Subtractions                           #
#----------------------------------------------------------------------------------------------#

+(x::AMOUNTS, y::Union{Real,Quantity}) =  x + __amt(y)
+(y::Union{Real,Quantity}, x::AMOUNTS) =  x + y          # fallsback
-(x::AMOUNTS, y::Union{Real,Quantity}) =  x - __amt(y)
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
    𝗠𝗮(/(promote(map(x -> amt(x), (x, y))...)...))
end

# γ from entropy amount ratios (as specific heats might auto-convert to dsamt's)
/(x::NTROPYA{𝗽,𝘅}, y::NTROPYA{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    𝝲(/(promote(map(x -> amt(x), (x, y))...)...))
end


    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
    #                           Pv variants                            #
    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# P * v --> Pv
*(x::sysP{𝗽,𝘅}, y::vAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    Pv(*(amt(x), amt(y)))
end
*(y::vAmt{𝘀,𝘆,𝗯}, x::sysP{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x * y           # as to fallback

# Pv / v --> P
/(x::Pvamt{𝘀,𝘆,𝗯}, y::vAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    P(/(amt(x), amt(y)))
end

# Pv / P --> v
/(x::Pvamt{𝘀,𝘆,𝗯}, y::sysP{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    v(/(amt(x), amt(y)))
end


    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
    #                           RT variants                            #
    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# R * T --> RT
*(x::sysT{𝗽,𝘅}, y::RAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    RT(*(amt(x), amt(y)))
end
*(y::RAmt{𝘀,𝘆,𝗯}, x::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x * y           # as to fallback

# RT / T --> R
/(x::RTAmt{𝘀,𝘆,𝗯}, y::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    R(/(amt(x), amt(y)))
end

# RT / R --> T
/(x::RTAmt{𝘀,𝘆,𝗯}, y::RAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    T(/(amt(x), amt(y)))
end


    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
    #                           Ts variants                            #
    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# T * s --> Ts
*(x::sysT{𝗽,𝘅}, y::s_amt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    Ts(*(amt(x), amt(y)))
end
*(y::s_amt{𝘀,𝘆,𝗯}, x::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x * y           # as to fallback

# Ts / T --> s
/(x::Tsamt{𝘀,𝘆,𝗯}, y::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    s(/(amt(x), amt(y)))
end

# Ts / s --> T
/(x::Tsamt{𝘀,𝘆,𝗯}, y::s_amt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    T(/(amt(x), amt(y)))
end


    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
    #                            Z variants                            #
    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# Pv / RT --> Z
/(x::Pvamt{𝗽,𝘅,𝗯}, y::RTAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    Z(/(amt(x), amt(y)))
end

# Pv / Z --> RT
/(x::Pvamt{𝗽,𝘅,𝗯}, y::ZAmt{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    RT(/(amt(x), amt(y)))
end

# Z * RT --> Pv
*(x::ZAmt{𝗽,𝘅}, y::RTAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    Pv(*(amt(x), amt(y)))
end
*(y::RTAmt{𝘀,𝘆,𝗯}, x::ZAmt{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x * y           # as to fallback


    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
    #                       Massieu's j variants                       #
    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# j * T --> -a
*(x::sysT{𝗽,𝘅}, y::jAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    -a(*(amt(x), amt(y)))
end
*(y::jAmt{𝘀,𝘆,𝗯}, x::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x * y           # as to fallback

# a / T --> -j
/(x::a_amt{𝘀,𝘆,𝗯}, y::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    -j(/(amt(x), amt(y)))
end

# a / j --> -T
/(x::a_amt{𝘀,𝘆,𝗯}, y::jAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    -T(/(amt(x), amt(y)))
end


    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#
    #                       Planck's y variants                        #
    #⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅#

# y * T --> -g
*(x::sysT{𝗽,𝘅}, y::yAmt{𝘀,𝘆,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    -g(*(amt(x), amt(y)))
end
*(y::yAmt{𝘀,𝘆,𝗯}, x::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = x * y           # as to fallback

# g / T --> -y
/(x::g_amt{𝘀,𝘆,𝗯}, z::sysT{𝗽,𝘅}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    -y(/(amt(x), amt(z)))
end

# g / y --> -T
/(x::g_amt{𝘀,𝘆,𝗯}, y::yAmt{𝗽,𝘅,𝗯}) where {𝗽,𝘀,𝘅,𝘆,𝗯} = begin
    -T(/(amt(x), amt(y)))
end


#----------------------------------------------------------------------------------------------#
#                          Generic (fallback) Products and Divisions                           #
#----------------------------------------------------------------------------------------------#

*(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝗽,𝘅}) where {𝗽,𝘅} = AMT(*(amt(x), amt(y)))
/(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝗽,𝘅}) where {𝗽,𝘅} = AMT(/(amt(x), amt(y)))

*(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    *(promote(map(x -> __amt(amt(x)), (x, y))...)...)
end
/(x::AMOUNTS{𝗽,𝘅}, y::AMOUNTS{𝘀,𝘆}) where {𝗽,𝘀,𝘅,𝘆} = begin
    /(promote(map(x -> __amt(amt(x)), (x, y))...)...)
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

import Base: log, log2, log10, exp

for FUN in (:log, :log2, :log10, :exp)
    @eval $FUN(x::DIMLESS{𝗽,𝘅}) where {𝗽,𝘅} = ø($FUN(amt(x).val))
end


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


