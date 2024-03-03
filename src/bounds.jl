#----------------------------------------------------------------------------------------------#
#                                   Property Bound Constants                                   #
#----------------------------------------------------------------------------------------------#

# Raw bound constants
# -------------------

"""
`const TeraKelvin = T_(1u"TK")`\n
A practical, hardcoded temp. upper bound as a `T_amt{Float64,EX}`, for state specifications.
"""
const TeraKelvin = T_(1u"TK")

"""
`const picoKelvin = T_(1u"pK")`\n
A practical, hardcoded temp. lower bound as a `T_amt{Float64,EX}`, for state specifications.
"""
const picoKelvin = T_(1u"pK")

export TeraKelvin, picoKelvin


"""
`const TeraPascal = P_(1u"TPa")`\n
A practical, hardcoded pressure upper bound as a `P_amt{Float64,EX}`, for state specifications.
"""
const TeraPascal = P_(1u"TPa")

"""
`const picoPascal = T_(1u"pPa")`\n
A practical, hardcoded pressure lower bound as a `P_amt{Float64,EX}`, for state specifications.
"""
const picoPascal = P_(1u"pPa")

export TeraPascal, picoPascal


"""
`const YottaMassVolume = v_(1.0e+24, MA)`\n
A practical, hardcoded mass-based specific volume upper bound as a `v_amt{Float64,EX,MA}`, for
state specifications.
"""
const YottaMassVolume = v_(1.0e+24, MA)

"""
`const yoctoMassVolume = v_(1.0e-24, MA)`\n
A practical, hardcoded mass-based specific volume lower bound as a `v_amt{Float64,EX,MA}`, for
state specifications.
"""
const yoctoMassVolume = v_(1.0e-24, MA)

"""
`const YottaMoleVolume = v_(1.0e+24, MO)`\n
A practical, hardcoded mole-based specific volume upper bound as a `v_amt{Float64,EX,MO}`, for
state specifications.
"""
const YottaMoleVolume = v_(1.0e+24, MO)

"""
`const yoctoMoleVolume = v_(1.0e-24, MO)`\n
A practical, hardcoded mole-based specific volume lower bound as a `v_amt{Float64,EX,MO}`, for
state specifications.
"""
const yoctoMoleVolume = v_(1.0e-24, MO)


# Bound functions
# ---------------

"""
`minT(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=E𝖷) where {𝗽<:𝖯REC,𝘅<:E𝖷AC}`\n
Returns the hardcoded temperature lower bound as a `T_amt{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
minT(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = begin
    T_amt{𝖯,𝖷}(max(picoKelvin, T_(nextfloat(zero(𝖯)))))   # calls isless()
end
minT(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = begin
    T_amt{𝖯,𝖷}(max(picoKelvin, T_(nextfloat(zero(𝖯)))))   # calls isless()
end

"""
`maxT(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=E𝖷) where {𝗽<:𝖯REC,𝘅<:E𝖷AC}`\n
Returns the hardcoded temperature upper bound as a `T_amt{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
maxT(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = begin
    T_amt{𝖯,𝖷}(min(TeraKelvin, T_(prevfloat(𝖯(Inf)))))    # calls isless()
end
maxT(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = begin
    T_amt{𝖯,𝖷}(min(TeraKelvin, T_(prevfloat(𝖯(Inf)))))    # calls isless()
end


