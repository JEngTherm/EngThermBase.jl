#----------------------------------------------------------------------------------------------#
#                               Fundamental Phys-Chem Constants                                #
#----------------------------------------------------------------------------------------------#

"""
`const _NA = __amt(measurement("6.0221415(10)e+23") / u"mol")`\n
The Avogadro constant, \$N_A\$, [Lide, D. R., 2006], as a `__amt{Float64,MM}`.
"""
const _NA = __amt(measurement("6.0221415(10)e+23") / u"mol")

"""
`NA(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the Avogadro constant as a `__amt{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
NA(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = __amt{𝖯,𝖷}(_NA)
NA(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = __amt{𝖯,𝖷}(_NA)


"""
`const _mu = m_amt(measurement("1.66053886(28)e-27") ,SY)`\n
The atomic mass constant, \$m_u = (1/12)m(¹²C)\$, [Lide, D. R., 2006], as a
`m_amt{Float64,MM,SY}`.
"""
const _mu = m_amt(measurement("1.66053886(28)e-27") ,SY)

"""
`mu(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the atomic mass constant as a `m_amt{𝖯:𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
mu(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = m_amt{𝖯,𝖷}(_mu)
mu(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = m_amt{𝖯,𝖷}(_mu)


"""
`const _R̄ = R_amt(measurement("8.314472(15)"), MO)`\n
The molar gas constant, \$R̄\$, [Lide, D. R., 2006], as a `R_amt{Float64,MM,MO}`.
"""
const _R̄ = R_amt(measurement("8.314472(15)"), MO)

"""
`R_(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the molar gas constant as a `R_amt{𝖯:𝖷,MO}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
R_(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = R_amt{𝖯,𝖷}(_R̄)
R_(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = R_amt{𝖯,𝖷}(_R̄)


"""
`const _kB = __amt(measurement("1.3806505(24)e-23") * u"J/K")`\n
The Boltzmann constant, \$k_B = R̄/N_A\$, [Lide, D. R., 2006], as a `__amt{Float64,MM}`.
"""
const _kB = __amt(measurement("1.3806505(24)e-23") * u"J/K")

"""
`kB(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the Boltzmann constant as a `__amt{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
kB(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = __amt{𝖯,𝖷}(_kB)
kB(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = __amt{𝖯,𝖷}(_kB)

export NA, mu, kB   # as R is already exported on "amounts.jl"


#----------------------------------------------------------------------------------------------#
#                                     Reference Constants                                      #
#----------------------------------------------------------------------------------------------#

"""
`const _stdT = T_amt{Float64,MM}(25u"°C")`\n
The `T_amt{Float64,MM}` representation of the exact standard temperature, \$T_0 ≡ 25°C\$, [Lide,
D. R., 2006].
"""
const _stdT = T_amt{Float64,MM}(25u"°C")

"""
`T_(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the standard temperature as a `T_amt{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
T_(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = T_amt{𝖯,𝖷}(_stdT)
T_(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = T_amt{𝖯,𝖷}(_stdT)


"""
`const _stdP = P_amt{Float64,MM}(101350u"Pa")`\n
The `P_amt{Float64,MM}` representation of the exact standard atmosphere, \$P_0 ≡ 101350Pa\$,
[Lide, D. R., 2006].
"""
const _stdP = P_amt{Float64,MM}(101350u"Pa")

"""
`P_(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the standard atmosphere as a `P_amt{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
P_(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = P_amt{𝖯,𝖷}(_stdP)
P_(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = P_amt{𝖯,𝖷}(_stdP)


"""
`const _gn = gvamt{Float64,MM}(9_806_650u"μm/s^2")`\n
The `gvamt{Float64,MM}` representation of the exact standard gravity, \$g_n ≡ 9.80665 m/s^2\$,
[Lide, D. R., 2006].
"""
const _gn = gvamt{Float64,MM}(9_806_650u"μm/s^2")

"""
`gv(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=E𝖷) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the standard gravity as a `gvamt{𝖯,𝖷}`.\n
Arguments `𝖯` and `𝖷` can be ommitted and/or be supplied in any order.
"""
gv(𝖯::Type{𝗽}=Float64, 𝖷::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = gvamt{𝖯,𝖷}(_gn)
gv(𝖷::Type{𝘅}, 𝖯::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = gvamt{𝖯,𝖷}(_gn)


