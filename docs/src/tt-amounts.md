```@meta
DocTestFilters = r"[0-9\.]+ seconds \(.*\)"
```

# Amounts Tutori-Test

This "tutori-test"—i.e., a tutorial/test—goes through `AMOUNTS` instantiation, or quantity
(plain `Number`) tagging with `EngThermBase`:

## Generic Amounts

`EngThermBase` generic amounts are generic and bears no assumptions on units, and thus, can
represent any real quantity of any units, including dimensionless ones.

```jldoctest tt_amounts_generic
julia> using EngThermBase

help?> GenerAmt
search: GenerAmt @generated

  abstract type GenerAmt{𝗽<:PREC,𝘅<:EXAC} <: AMOUNTS{𝗽,𝘅} end

  Abstract supertype for generic, arbitrary unit amounts.

  Hierarchy
  ===========

  GenerAmt <: AMOUNTS <: AbstractTherm <: Any
```

Their concrete type is:

```jldoctest tt_amounts_generic
julia> __amt === __amt{𝗽,𝘅} where {𝗽,𝘅}
true
```

Parameter `𝗽<:Union{Float16, Float32, Float64, BigFloat}` is the precision and `𝘅<:Union{EX,MM}`
is the exactness. Illegal instances include:

```jldoctest tt_amounts_generic
julia> __amt{AbstractFloat}
ERROR: TypeError: in AMOUNTS, in 𝗽, expected 𝗽<:Union{Float16, Float32, Float64, BigFloat}, got Type{AbstractFloat}
[...]

julia> EXAC
EXAC (alias for Union{EX, MM})

julia> __amt{Float32,ExactBase}
ERROR: TypeError: in AMOUNTS, in 𝘅, expected 𝘅<:EXAC, got Type{ExactBase}
[...]
```

### Instantiating Generic Amounts

Generic Amounts can be instantiated with:

- One of the `__amt`'s type constructors;
- The corresponding exported function `_a`; or
- The corresponding exported function alias `𝗔` (`'𝗔': Unicode U+1D5D4` typed as "\bsansA"<tab>)

Input values can be any `Real` plain old data (POD) or unit'ed types.

Instantiating with `__amt`'s type constructors and POD types:

```jldoctest tt_amounts_generic
julia> @time [ __amt(1), __amt(1//1), __amt(0x1) ]
  0.000014 seconds (22 allocations: 992 bytes)
3-element Vector{__amt{Float64, EX}}:
 _₆₄: 1.0000
 _₆₄: 1.0000
 _₆₄: 1.0000

julia> @time [ __amt(𝗶(π)) for 𝗶 in (Float16, Float32, Float64, BigFloat) ]
  0.060191 seconds (78.61 k allocations: 4.146 MiB, 91.92% compilation time)
4-element Vector{__amt{𝗽, EX} where 𝗽}:
 _₁₆: 3.1406
 _₃₂: 3.1416
 _₆₄: 3.1416
 _₂₅₆: 3.1416
```

Instantiating with exported function `_a` and POD types:

```jldoctest tt_amounts_generic
julia> @time [ _a(1), _a(1//1), _a(0x1) ]
  0.000015 seconds (22 allocations: 992 bytes)
3-element Vector{__amt{Float64, EX}}:
 _₆₄: 1.0000
 _₆₄: 1.0000
 _₆₄: 1.0000

julia> @time [ _a(𝗶(π)) for 𝗶 in (Float16, Float32, Float64, BigFloat) ]
  0.053903 seconds (76.23 k allocations: 3.989 MiB, 99.46% compilation time)
4-element Vector{__amt{𝗽, EX} where 𝗽}:
 _₁₆: 3.1406
 _₃₂: 3.1416
 _₆₄: 3.1416
 _₂₅₆: 3.1416
```

Instantiating with exported function alias `𝗔` and POD types:

```jldoctest tt_amounts_generic
julia> @time [ 𝗔(1), 𝗔(1//1), 𝗔(0x1) ]
  0.000021 seconds (28 allocations: 1.062 KiB)
3-element Vector{__amt{Float64, EX}}:
 _₆₄: 1.0000
 _₆₄: 1.0000
 _₆₄: 1.0000

julia> @time [ 𝗔(𝗶(π)) for 𝗶 in (Float16, Float32, Float64, BigFloat) ]
  0.060330 seconds (76.00 k allocations: 3.980 MiB, 99.45% compilation time)
4-element Vector{__amt{𝗽, EX} where 𝗽}:
 _₁₆: 3.1406
 _₃₂: 3.1416
 _₆₄: 3.1416
 _₂₅₆: 3.1416
```

Instantiating with `__amt`'s type constructors and united amounts:

```jldoctest tt_amounts_generic
julia> @time [ __amt(1u"m"), __amt((1//1)u"m"), __amt(0x1*u"m") ]
  0.000014 seconds (25 allocations: 1.016 KiB)
3-element Vector{__amt{Float64, EX}}:
 _₆₄: 1.0000 m
 _₆₄: 1.0000 m
 _₆₄: 1.0000 m

julia> @time [ __amt(𝗶(π)u"kJ") for 𝗶 in (Float16, Float32, Float64, BigFloat) ]
  0.058446 seconds (81.25 k allocations: 4.308 MiB, 99.48% compilation time)
4-element Vector{__amt{𝗽, EX} where 𝗽}:
 _₁₆: 3.1406 kJ
 _₃₂: 3.1416 kJ
 _₆₄: 3.1416 kJ
 _₂₅₆: 3.1416 kJ
```

Instantiating with exported function `_a` and alias `𝗔` and united amounts:

```jldoctest tt_amounts_generic
julia> @time [ F(i*u"°C") for F in (_a, 𝗔) for i in Real[3, (TY(π) for TY in (Float16, Float32, Float64, BigFloat))...] ]
  0.203469 seconds (606.29 k allocations: 31.888 MiB, 99.76% compilation time)
10-element Vector{__amt{𝗽, EX} where 𝗽}:
 _₆₄: 3.0000 °C
 _₁₆: 3.1406 °C
 _₃₂: 3.1416 °C
 _₆₄: 3.1416 °C
 _₂₅₆: 3.1416 °C
 _₆₄: 3.0000 °C
 _₁₆: 3.1406 °C
 _₃₂: 3.1416 °C
 _₆₄: 3.1416 °C
 _₂₅₆: 3.1416 °C
```

## Whole Amounts

`EngThermBase` whole amounts are representative of thermophysical quantities that are unbased,
i.e., not being of per system mass or per system chemical amount, and of fixed units.

```jldoctest tt_amounts_whole
julia> using EngThermBase

help?> WholeAmt
search: WholeAmt

  abstract type WholeAmt{𝗽<:PREC,𝘅<:EXAC} <: AMOUNTS{𝗽,𝘅} end

  Abstract supertype for whole, unbased amounts of fixed units.

  Hierarchy
  ===========

  WholeAmt <: AMOUNTS <: AbstractTherm <: Any
```

`EngThermBase` whole amounts are concrete subtypes of `WholeAmt`, therefore:

```jldoctest tt_amounts_whole
julia> print(tt(WholeAmt, concrete=true)...)
WholeAmt
 ├─ WInteract
 ├─ WProperty
 │   ├─ Maamt
 │   ├─ P_amt
 │   ├─ Pramt
 │   ├─ T_amt
 │   ├─ Z_amt
 │   ├─ beamt
 │   ├─ csamt
 │   ├─ gaamt
 │   ├─ kTamt
 │   ├─ k_amt
 │   ├─ ksamt
 │   ├─ mJamt
 │   ├─ mSamt
 │   ├─ spamt
 │   ├─ veamt
 │   ├─ vramt
 │   └─ x_amt
 └─ WUnranked
     ├─ gvamt
     ├─ t_amt
     ├─ z_amt
     └─ ø_amt
```

### Unranked Whole Amounts

Unranked whole amounts are `<:WUnranked` and are:

```jldoctest tt_amounts_whole
julia> @time [ TY(2.5) for TY in (gvamt, t_amt, z_amt, ø_amt) ]
  0.050186 seconds (70.44 k allocations: 3.809 MiB, 88.72% compilation time)
4-element Vector{WUnranked{Float64, EX}}:
 𝒈₆₄: 2.5000 m/s²
 𝗍₆₄: 2.5000 s
 𝗓₆₄: 2.5000 m
 ø₆₄: 2.5000 –
```

That is—gravity (`gvamt`), time (`t_amt`), altitude (`z_amt`), and generic dimensionless ratio
(`ø_amt`), with default units applied and shown above.

Constructors perform unit checking and conversion when necessary:

```jldoctest tt_amounts_whole
julia> gv(3.14u"m") # Wrong unit dimensions
ERROR: MethodError: no method matching gvamt(::Quantity{Float64, 𝐋, Unitful.FreeUnits{(m,), 𝐋, nothing}})
[...]

julia> t_(1u"minute")
𝗍₆₄: 60.000 s
```

Moreover, for all concrete types `<:AMOUNTS` except `__amt`, the type's corresponding exported
function is formed by the type's first two characters, so the `t_()` function used above calls a
pertinent `t_amt` type constructor (through Julia's multiple dispatch, based on its input
argument type).

Further, all concrete types `<:AMOUNTS` are expressed as strings of 5 ASCII characters
(including `ø_amt` that starts with `'ø': Unicode U+00F8 (category Ll: Letter, lowercase)`):

```jldoctest tt_amounts_whole
help?> ø_
"ø_" can be typed by \o<tab>_

search: ø_ ø_amt

  Function to return generic dimensionless ratio amounts in (–).
```

## Property Whole Amounts

Property whole amounts include the following:

- `Maamt` for Mach numbers in (–);
- `P_amt` for pressures in (kPa);
- `Pramt` for relative pressures in (–);
- `T_amt` for temperatures in (K);
- `Z_amt` for generalized compressibility factor in (–);
- `beamt` for coefficient of volume expansion in (1/K);
- `csamt` for adiabatic speeds of sound in (√(kJ/kg));
- `gaamt` for specific heat ratios in (–);
- `kTamt` for isothermal compressibility in (1/kPa);
- `k_amt` for isentropic expansion exponents in (–);
- `ksamt` for isentropic compressibility in (1/kPa);
- `mJamt` for Joule-Thomson coefficient in (K/kPa);
- `mSamt` for isentropic expansion coefficient in (K/kPa);
- `spamt` for speed amounts in (m/s);
- `veamt` for velocity amounts in (√(kJ/kg));
- `vramt` for relative specific volume in (–);
- `x_amt` for saturated vapor mass fraction (quality) in (–);

```jldoctest tt_amounts_whole
julia> @time [ TY(0.125) for TY in (Maamt, P_amt, Pramt, T_amt, Z_amt, beamt, csamt, gaamt, kTamt, k_amt, ksamt, mJamt, mSamt, spamt, veamt, vramt, x_amt) ]
  0.050951 seconds (91.74 k allocations: 5.068 MiB, 96.66% compilation time)
17-element Vector{WProperty{Float64, EX}}:
 Ma₆₄: 0.12500 –
 P₆₄: 0.12500 kPa
 Pr₆₄: 0.12500 –
 T₆₄: 0.12500 K
 Z₆₄: 0.12500 –
 β₆₄: 0.12500 /K
 𝕔₆₄: 0.12500 √(kJ/kg)
 γ₆₄: 0.12500 –
 κT₆₄: 0.12500 /kPa
 k₆₄: 0.12500 –
 κs₆₄: 0.12500 /kPa
 μJ₆₄: 0.12500 K/kPa
 μS₆₄: 0.12500 K/kPa
 𝕧₆₄: 0.12500 m/s
 𝕍₆₄: 0.12500 √(kJ/kg)
 vr₆₄: 0.12500 –
 x₆₄: 0.12500 –
```

Sample unit conversions:

```jldoctest tt_amounts_whole
julia> 𝑣 = 120u"km/hr"
120 km hr^-1

julia> sp(𝑣)
𝕧₆₄: 33.333 m/s

julia> ve(𝑣)
𝕍₆₄: 1.0541 √(kJ/kg)

julia> sp(ve(1))
𝕧₆₄: 31.623 m/s

julia> uconvert(u"km/hr", amt(sp(ve(1))))
113.84199576606166 km hr^-1
```

On the above example, the `amt()` function is used as to extract the amount from any concrete
type `<:AMOUNTS`.

```@info
Function `amt()` is faster than accessing `amount.amt` because it is written in a type-stable
manner.
```

