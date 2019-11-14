#----------------------------------------------------------------------------------------------#
#                                   Property Bound Constants                                   #
#----------------------------------------------------------------------------------------------#

"""
`const TeraKelvin = T(1u"TK")`\n
A practical, hardcoded temperature upper bound as a `sysT{Float64,EX}`, for state
specifications.
"""
const TeraKelvin = T(1u"TK")

"""
`const picoKelvin = T(1u"TK")`\n
A practical, hardcoded temperature lower bound as a `sysT{Float64,EX}`, for state
specifications.
"""
const picoKelvin = T(1u"pK")

export TeraKelvin, picoKelvin


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

