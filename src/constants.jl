#----------------------------------------------------------------------------------------------#
#                               Fundamental Phys-Chem Constants                                #
#----------------------------------------------------------------------------------------------#

"""
`const _NA = _Amt(measurement("6.0221415(10)e+23") / u"mol")`\n
The Avogadro constant, \$N_A\$, [Lide, D. R., 2006], as a `_Amt{Float64,MM}`.
"""
const _NA = _Amt(measurement("6.0221415(10)e+23") / u"mol")

"""
`NA(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the Avogadro constant as a `_Amt{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
NA(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = _Amt{𝖯,𝖷}(_NA)
NA(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = _Amt{𝖯,𝖷}(_NA)


"""
`const _mu = m(measurement("1.66053886(28)e-27") ,SY)`\n
The atomic mass constant, \$m_u = (1/12)m(¹²C)\$, [Lide, D. R., 2006], as a
`mAmt{Float64,MM,SY}`.
"""
const _mu = m(measurement("1.66053886(28)e-27") ,SY)

"""
`mu(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the atomic mass constant as a `mAmt{𝖯:𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
mu(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = mAmt{𝖯,𝖷}(_mu)
mu(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = mAmt{𝖯,𝖷}(_mu)


"""
`const _R̄ = R(measurement("8.314472(15)"), MO)`\n
The molar gas constant, \$R̄\$, [Lide, D. R., 2006], as a `RAmt{Float64,MM,MO}`.
"""
const _R̄ = R(measurement("8.314472(15)"), MO)

"""
`R(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the molar gas constant as a `RAmt{𝖯:𝖷,MO}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
R(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = RAmt{𝖯,𝖷}(_R̄)
R(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = RAmt{𝖯,𝖷}(_R̄)


"""
`const _kB = _Amt(measurement("1.3806505(24)e-23") * u"J/K")`\n
The Boltzmann constant, \$k_B = R̄/N_A\$, [Lide, D. R., 2006], as a `_Amt{Float64,MM}`.
"""
const _kB = _Amt(measurement("1.3806505(24)e-23") * u"J/K")

"""
`kB(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the Boltzmann constant as a `_Amt{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
kB(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = _Amt{𝖯,𝖷}(_kB)
kB(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = _Amt{𝖯,𝖷}(_kB)

export NA, mu, kB   # as R is already exported on "amounts.jl"


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
`T(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the standard temperature as a `sysT{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
T(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = sysT{𝖯,𝖷}(_stdT)
T(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = sysT{𝖯,𝖷}(_stdT)


"""
`const _stdP = sysP{Float64,MM}(P(101350u"Pa"))`\n
The `sysP{Float64,MM}` representation of the exact standard atmosphere, \$P_0 ≡ 101350Pa\$,
[Lide, D. R., 2006].
"""
const _stdP = sysP{Float64,MM}(P(101350u"Pa"))

"""
`P(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the standard atmosphere as a `sysP{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
P(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = sysP{𝖯,𝖷}(_stdP)
P(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = sysP{𝖯,𝖷}(_stdP)


"""
`const _gn = grav{Float64,MM}(grav(9_806_650u"μm/s^2"))`\n
The `grav{Float64,MM}` representation of the exact standard gravity, \$g_n ≡ 9.80665 m/s^2\$,
[Lide, D. R., 2006].
"""
const _gn = GRAV{Float64,MM}(grav(9_806_650u"μm/s^2"))

"""
`grav(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=E𝖷) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the standard gravity as a `grav{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
grav(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = GRAV{𝖯,𝖷}(_gn)
grav(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = GRAV{𝖯,𝖷}(_gn)


