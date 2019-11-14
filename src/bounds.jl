#----------------------------------------------------------------------------------------------#
#                                   Property Bound Constants                                   #
#----------------------------------------------------------------------------------------------#

# Raw bound constants
# -------------------

"""
`const TeraKelvin = T(1u"TK")`\n
A practical, hardcoded temp. upper bound as a `sysT{Float64,EX}`, for state specifications.
"""
const TeraKelvin = T(1u"TK")

"""
`const picoKelvin = T(1u"pK")`\n
A practical, hardcoded temp. lower bound as a `sysT{Float64,EX}`, for state specifications.
"""
const picoKelvin = T(1u"pK")

export TeraKelvin, picoKelvin


"""
`const TeraPascal = P(1u"TPa")`\n
A practical, hardcoded pressure upper bound as a `sysP{Float64,EX}`, for state specifications.
"""
const TeraPascal = P(1u"TPa")

"""
`const picoPascal = T(1u"pPa")`\n
A practical, hardcoded pressure lower bound as a `sysP{Float64,EX}`, for state specifications.
"""
const picoPascal = P(1u"pPa")

export TeraPascal, picoPascal


"""
`const YottaMassVolume = v(1.0e+24, MA)`\n
A practical, hardcoded mass-based specific volume upper bound as a `vAmt{Float64,EX,MA}`, for
state specifications.
"""
const YottaMassVolume = v(1.0e+24, MA)

"""
`const yoctoMassVolume = v(1.0e-24, MA)`\n
A practical, hardcoded mass-based specific volume lower bound as a `vAmt{Float64,EX,MA}`, for
state specifications.
"""
const yoctoMassVolume = v(1.0e-24, MA)

"""
`const YottaMoleVolume = v(1.0e+24, MO)`\n
A practical, hardcoded mole-based specific volume upper bound as a `vAmt{Float64,EX,MO}`, for
state specifications.
"""
const YottaMoleVolume = v(1.0e+24, MO)

"""
`const yoctoMoleVolume = v(1.0e-24, MO)`\n
A practical, hardcoded mole-based specific volume lower bound as a `vAmt{Float64,EX,MO}`, for
state specifications.
"""
const yoctoMoleVolume = v(1.0e-24, MO)


# Bound functions
# ---------------

"""
`minT(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=E𝖷) where {𝗽<:𝖯REC,𝘅<:E𝖷AC}`\n
Returns the hardcoded temperature lower bound as a `sysT{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
minT(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = begin
    sysT{𝖯,𝖷}(max(picoKelvin, T(nextfloat(zero(𝖯)))))   # calls isless()
end
minT(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = begin
    sysT{𝖯,𝖷}(max(picoKelvin, T(nextfloat(zero(𝖯)))))   # calls isless()
end

"""
`maxT(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=E𝖷) where {𝗽<:𝖯REC,𝘅<:E𝖷AC}`\n
Returns the hardcoded temperature upper bound as a `sysT{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
maxT(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = begin
    sysT{𝖯,𝖷}(min(TeraKelvin, T(prevfloat(𝖯(Inf)))))    # calls isless()
end
maxT(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = begin
    sysT{𝖯,𝖷}(min(TeraKelvin, T(prevfloat(𝖯(Inf)))))    # calls isless()
end


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

