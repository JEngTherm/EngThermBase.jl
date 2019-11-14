#----------------------------------------------------------------------------------------------#
#                               Fundamental Phys-Chem Constants                                #
#----------------------------------------------------------------------------------------------#

"""
`const _NA = _Amt(measurement("6.0221415(10)e+23") / u"mol")`\n
The Avogadro constant, \$N_A\$, [Lide, D. R., 2006], as a `_Amt{Float64,MM}`.
"""
const _NA = _Amt(measurement("6.0221415(10)e+23") / u"mol")

"""
`NA(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the Avogadro constant as a `_Amt{P,X}`.\n
Arguments `P` and `X` can be ommitted and/or be supplied in any order.
"""
NA(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = _Amt{P,X}(_NA)
NA(X::Type{𝘅}, P::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = _Amt{P,X}(_NA)


"""
`const _mu = m(measurement("1.66053886(28)e-27") ,SY)`\n
The atomic mass constant, \$m_u = (1/12)m(¹²C)\$, [Lide, D. R., 2006], as a
`mAmt{Float64,MM,SY}`.
"""
const _mu = m(measurement("1.66053886(28)e-27") ,SY)

"""
`mu(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the atomic mass constant as a `mAmt{P,X}`.\n
Arguments `P` and `X` can be ommitted and/or be supplied in any order.
"""
mu(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = mAmt{P,X}(_mu)
mu(X::Type{𝘅}, P::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = mAmt{P,X}(_mu)


"""
`const _R̄ = R(measurement("8.314472(15)"), MO)`\n
The molar gas constant, \$R̄\$, [Lide, D. R., 2006], as a `RAmt{Float64,MM,MO}`.
"""
const _R̄ = R(measurement("8.314472(15)"), MO)

"""
`const _kB = _Amt(measurement("1.3806505(24)e-23") * u"J/K")`\n
The Boltzmann constant, \$k_B = R̄/N_A\$, [Lide, D. R., 2006], as a `_Amt{Float64,MM}`.
"""
const _kB = _Amt(measurement("1.3806505(24)e-23") * u"J/K")


#----------------------------------------------------------------------------------------------#
#                                     Reference Constants                                      #
#----------------------------------------------------------------------------------------------#

"""
`const _stdT = sysT{Float64,MM}(T(25u"°C"))`\n
The `sysT{Float64,MM}` representation of the exact standard temperature, \$T_0 ≡ 25°C\$, [Lide,
D. R., 2006].
"""
const _stdT = sysT{Float64,MM}(T(25u"°C"))

"""
`const _stdP = sysP{Float64,MM}(P(101350u"Pa"))`\n
The `sysP{Float64,MM}` representation of the exact standard atmosphere, \$P_0 ≡ 101350Pa\$,
[Lide, D. R., 2006].
"""
const _stdP = sysP{Float64,MM}(P(101350u"Pa"))

"""
`const _gn = grav{Float64,MM}(grav(9_806_650u"μm/s^2"))`\n
The `grav{Float64,MM}` representation of the exact standard gravity, \$g_n ≡ 9.80665 m/s^2\$,
[Lide, D. R., 2006].
"""
const _gn = grav{Float64,MM}(grav(9_806_650u"μm/s^2"))


## #----------------------------------------------------------------------------------------------#
## #                                Typed Thermodynamic Constants                                 #
## #----------------------------------------------------------------------------------------------#
## 
## "`const r̄ = perMole_R{Float64}(8.31447u\"kJ/kmol/K\")`: the universal gas constant"
## const r̄ = perMole_R{Float64}(8.31447u"kJ/kmol/K")
## 
## "`rbar() = r̄`"
## rbar() = r̄
## "`rbar(::Type{Float16}) = perMole_R{Float16}(r̄)`"
## rbar(::Type{Float16}) = perMole_R{Float16}(r̄)
## "`rbar(::Type{Float32}) = perMole_R{Float32}(r̄)`"
## rbar(::Type{Float32}) = perMole_R{Float32}(r̄)
## "`rbar(::Type{Float64}) = perMole_R{Float64}(r̄)`"
## rbar(::Type{Float64}) = perMole_R{Float64}(r̄)
## "`rbar(::Type{BigFloat}) = perMole_R{BigFloat}(r̄)`"
## rbar(::Type{BigFloat}) = perMole_R{BigFloat}(r̄)
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                 Package User Interface -- Constant-related function methods                  #
## #----------------------------------------------------------------------------------------------#
## 
## "`r() = r̄`"
## r() = r̄
## "`r(::Type{MO}) = r̄`"
## r(::Type{MO}) = r̄
## "`r(::Type{𝘁}) where 𝘁<:AbstractFloat = rbar(𝘁)`"
## r(::Type{𝘁}) where 𝘁<:AbstractFloat = rbar(𝘁)
## "`r(::Type{MO}, ::Type{𝘁}) where 𝘁<:AbstractFloat = rbar(𝘁)`"
## r(::Type{MO}, ::Type{𝘁}) where 𝘁<:AbstractFloat = rbar(𝘁)
## "`r(M::perMole_m{𝘁}, ::Type{MA}) where 𝘁 = rbar(𝘁) / M`"
## r(M::perMole_m{𝘁}, ::Type{MA}) where 𝘁 = rbar(𝘁) / M
## "`r(M::perMole_m{𝘁}) where 𝘁 = r(M, DEF[:DB])`"
## r(M::perMole_m{𝘁}) where 𝘁 = r(M, DEF[:DB])
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                                   Standard Property Values                                   #
## #----------------------------------------------------------------------------------------------#
## 
## "`stdT() = T\"298.15\"`: the standard reference temperature"
## stdT() = T"298.15"
## "`stdT(::Type{𝘁}) where 𝘁<:AbstractFloat = system_T{𝘁}(stdT())`"
## stdT(::Type{𝘁}) where 𝘁<:AbstractFloat = system_T{𝘁}(stdT())
## 
## "`stdP() = P\"101.325\"`: the standard reference pressure"
## stdP() = P"101.325"
## "`stdP(::Type{𝘁}) where 𝘁<:AbstractFloat = system_P{𝘁}(stdP())`"
## stdP(::Type{𝘁}) where 𝘁<:AbstractFloat = system_P{𝘁}(stdP())
## 
## "`stdTP() = TPPair(stdT(), stdP())`: the standard reference \$(T, P)\$ state"
## stdTP() = TPPair(stdT(), stdP())
## "`stdTP(::Type{𝘁}) where 𝘁<:AbstractFloat = TPPair(stdT(𝘁), stdP(𝘁))`"
## stdTP(::Type{𝘁}) where 𝘁<:AbstractFloat = TPPair(stdT(𝘁), stdP(𝘁))
## 
## export stdT, stdP, stdTP
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                                   Property Bound Constants                                   #
## #----------------------------------------------------------------------------------------------#
## 
## "`const TeraKelvin = T\"b1.0e+12\"`: a practical, hardcoded temperature upper bound for state specifications"
## const TeraKelvin = T"b1.0e+12"  # since T defaults to K
## "`const picoKelvin = T\"b1.0e-12\"`: a practical, hardcoded temperature lower bound for state specifications"
## const picoKelvin = T"b1.0e-12"  # since T defaults to K
## 
## export TeraKelvin, picoKelvin
## 
## 
## "`const TeraPascal = P\"b1.0e+09\"`: a practical, hardcoded pressure upper bound for state specifications"
## const TeraPascal = P"b1.0e+09"  # since P defaults to kPa
## "`const picoPascal = P\"b1.0e-15\"`: a practical, hardcoded pressure lower bound for state specifications"
## const picoPascal = P"b1.0e-15"  # since P defaults to kPa
## 
## export TeraPascal, picoPascal
## 
## 
## "`const YottaMassVolume = vMA\"b1.0e+24\"`: a practical, hardcoded mass-based specific volume upper bound for state specifications"
## const YottaMassVolume = vMA"b1.0e+24"
## "`const yoctoMassVolume = vMA\"b1.0e-24\"`: a practical, hardcoded mass-based specific volume lower bound for state specifications"
## const yoctoMassVolume = vMA"b1.0e-24"
## 
## "`const YottaMoleVolume = vMO\"b1.0e+24\"`: a practical, hardcoded mole-based specific volume upper bound for state specifications"
## const YottaMoleVolume = vMO"b1.0e+24"
## "`const yoctoMoleVolume = vMO\"b1.0e-24\"`: a practical, hardcoded mole-based specific volume lower bound for state specifications"
## const yoctoMoleVolume = vMO"b1.0e-24"
## 
## 
## "`minT(::Type{𝘁})::system_T{𝘁} where 𝘁`"
## function minT(::Type{𝘁}) where 𝘁<:AbstractFloat
##     max(system_T{𝘁}(picoKelvin), nextfloat(zero(system_T{𝘁})))
## end
## 
## "`maxT(::Type{𝘁})::system_T{𝘁} where 𝘁`"
## function maxT(::Type{𝘁}) where 𝘁<:AbstractFloat
##     min(system_T{𝘁}(TeraKelvin), prevfloat(system_T{𝘁}(Inf)))
## end
## 
## 
## "`minP(::Type{𝘁})::system_P{𝘁} where 𝘁`"
## function minP(::Type{𝘁}) where 𝘁<:AbstractFloat
##     max(system_P{𝘁}(picoPascal), nextfloat(zero(system_P{𝘁})))
## end
## 
## "`maxP(::Type{𝘁})::system_P{𝘁} where 𝘁`"
## function maxP(::Type{𝘁}) where 𝘁<:AbstractFloat
##     min(system_P{𝘁}(TeraPascal), prevfloat(system_P{𝘁}(Inf)))
## end
## 
## 
## "`minv(::Type{𝘁}, ::Type{MA})::perMass_V{𝘁} where 𝘁`"
## function minv(::Type{𝘁}, ::Type{MA}) where 𝘁<:AbstractFloat
##     max(perMass_V{𝘁}(yoctoMassVolume), nextfloat(zero(perMass_V{𝘁})))
## end
## 
## "`minv(::Type{𝘁}, ::Type{MO})::perMole_V{𝘁} where 𝘁`"
## function minv(::Type{𝘁}, ::Type{MO}) where 𝘁<:AbstractFloat
##     max(perMole_V{𝘁}(yoctoMoleVolume), nextfloat(zero(perMole_V{𝘁})))
## end
## 
## "`maxv(::Type{𝘁}, ::Type{MA})::perMass_V{𝘁} where 𝘁`"
## function maxv(::Type{𝘁}, ::Type{MA}) where 𝘁<:AbstractFloat
##     min(perMass_V{𝘁}(YottaMassVolume), prevfloat(perMass_V{𝘁}(Inf)))
## end
## 
## "`maxv(::Type{𝘁}, ::Type{MO})::perMole_V{𝘁} where 𝘁`"
## function maxv(::Type{𝘁}, ::Type{MO}) where 𝘁<:AbstractFloat
##     min(perMole_V{𝘁}(YottaMoleVolume), prevfloat(perMole_V{𝘁}(Inf)))
## end
## 
## 
