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
`R(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the molar gas constant as a `RAmt{P,X,MO}`.\n
Arguments `P` and `X` can be ommitted and/or be supplied in any order.
"""
R(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = RAmt{P,X}(_R̄)
R(X::Type{𝘅}, P::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = RAmt{P,X}(_R̄)


"""
`const _kB = _Amt(measurement("1.3806505(24)e-23") * u"J/K")`\n
The Boltzmann constant, \$k_B = R̄/N_A\$, [Lide, D. R., 2006], as a `_Amt{Float64,MM}`.
"""
const _kB = _Amt(measurement("1.3806505(24)e-23") * u"J/K")

"""
`kB(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the Boltzmann constant as a `_Amt{P,X}`.\n
Arguments `P` and `X` can be ommitted and/or be supplied in any order.
"""
kB(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = _Amt{P,X}(_kB)
kB(X::Type{𝘅}, P::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = _Amt{P,X}(_kB)

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
`T(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the standard temperature as a `sysT{P,X}`.\n
Arguments `P` and `X` can be ommitted and/or be supplied in any order.
"""
T(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = sysT{P,X}(_stdT)
T(X::Type{𝘅}, P::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = sysT{P,X}(_stdT)


"""
`const _stdP = sysP{Float64,MM}(P(101350u"Pa"))`\n
The `sysP{Float64,MM}` representation of the exact standard atmosphere, \$P_0 ≡ 101350Pa\$,
[Lide, D. R., 2006].
"""
const _stdP = sysP{Float64,MM}(P(101350u"Pa"))

"""
`P(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the standard atmosphere as a `sysP{P,X}`.\n
Arguments `P` and `X` can be ommitted and/or be supplied in any order.
"""
P(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = sysP{P,X}(_stdP)
P(X::Type{𝘅}, P::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = sysP{P,X}(_stdP)


"""
`const _gn = grav{Float64,MM}(grav(9_806_650u"μm/s^2"))`\n
The `grav{Float64,MM}` representation of the exact standard gravity, \$g_n ≡ 9.80665 m/s^2\$,
[Lide, D. R., 2006].
"""
const _gn = grav{Float64,MM}(grav(9_806_650u"μm/s^2"))

"""
`grav(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC}`\n
Returns the standard gravity as a `grav{P,X}`.\n
Arguments `P` and `X` can be ommitted and/or be supplied in any order.
"""
grav(P::Type{𝗽}=Float64, X::Type{𝘅}=EX) where {𝗽<:PREC,𝘅<:EXAC} = grav{P,X}(_gn)
grav(X::Type{𝘅}, P::Type{𝗽}=Float64) where {𝗽<:PREC,𝘅<:EXAC} = grav{P,X}(_gn)


