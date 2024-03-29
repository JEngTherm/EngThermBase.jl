```@meta
DocTestFilters = r"[0-9\.]+ seconds \(.*\)"
```

# Amounts Tutori-Test

This "tutori-test"—i.e., a tutorial/test—goes through `AMOUNTS` instantiation, or quantity
(plain `Number`) tagging with `EngThermBase`, as well as through untagging ways:

## Generic Amounts

`EngThermBase` generic amounts are generic and bears no assumptions on units, and thus, can
represent any real quantity of any units, including dimensionless ones. Although they are
capable of, they aren't meant to tag common thermodynamic quantities such as temperature,
pressure, and various forms of energy; rather, it works as a fallback, "one-type-fits-all" type.
For the common thermodynamic quantities, there are the specific amounts, illustrated below.

```julia
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
julia> using EngThermBase

julia> __amt === __amt{𝗽,𝘅} where {𝗽,𝘅}
true
```

Parameter `𝗽<:Union{Float16, Float32, Float64, BigFloat}` is the precision and `𝘅<:Union{EX,MM}`
is the exactness. Illegal instances include those of inespecific (abstract) precision and
exactness parameters:

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

Notice the pretty-printing in action for tagged quantities. The pretty-printing is meant to
provide a visual indication to the interacting user of what the tagging process has
accomplished, meaning: it has "labeled" the quantity as a generic one (indicated by the
underscore `_` - other quantity types (shown below) have far more meaningful and interesting
labels); moreover, the underlying floating point precision is made explicit by the numeric
subscripts; moreover, the value is obviously printed (with a globally adjustable number of
significant digits).

Instantiating with exported function `_a` and POD types (this is not to be confused with the
exported function for the various forms (intensive, extensive, etc.) of the Helmholtz energy,
`a_`):

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

Instantiating with non-Engineerign Thermodynamic quantities with the exported function `AMT`,
which attempts guessing what the "most adequate" label should be. Only non-Engineering
Thermodynamic quantities fallback to the `__amt` conbstructor:

```jldoctest tt_amounts_generic
julia> AMT(1u"m^4")
_₆₄: 1.0000 m^4

julia> AMT(3u"kV")
_₆₄: 3.0000 kV
```

!!! warning
    Spoiler alert - the following example jumps way ahead.

For the sake of counter example, if, for instance, known Engineering Thermodynamics quantities
are passed, then, diferent amount types will be built, using different constructors that accepts
the input units. `EngThermBase` `AMOUNTS` Constructors for united amounts store quantities in
pre-defined units.

```jldoctest tt_amounts_generic
julia> [ AMT(i) for i in (-40u"°F", 1.6u"L", 1u"btu/lb", 114u"km/hr") ]
4-element Vector{AMOUNTS{Float64, EX}}:
 T₆₄: 233.15 K
 V₆₄: 0.0016000 m³
 Δe₆₄: 2.3260 kJ/kg
 𝕍₆₄: 1.0014 √(kJ/kg)

```

!!! tip
    And we're back to the spoiler-free, normal pace.

## Untagging amounts

Despite `EngThermBase` defining operations on it's types, most `julia` packages aren't written
to deal with `EngThermBase` quantities. This is the need for unpacking (untagging) quantities,
so that the underlying values are passed and processed outside of `EngThermBase`, and (possibly)
re-tagged in their way back.

Therefore, untagging must be simple and easy, and must stand out of one's way as much as
possible. `EngThermBase` provide various mechanisms for untagging, giving the user full control.
All instances of an `AMOUNT`'s concrete subtype stores the value as a unit-ed `Quantity`, even
for dimensionless `AMOUNTS`:

```jldoctest tt_untagging
julia> using EngThermBase

julia> ratio = _a(0.75)
_₆₄: 0.75000

julia> dump(ratio)
__amt{Float64, EX}
  amt: Quantity{Float64, NoDims, Unitful.FreeUnits{(), NoDims, nothing}}
      val: Float64 0.75
```

Therefore, there are several ways to untag or recover the underlying value: (i) by direct access
(discouraged), (ii) by type-stable `EngThermBase` functions, and (iii) using amounts as
`functors`.

### Untagging by direct access (discouraged)

One can simply access the `amt` field of every `AMOUNT` subtype instance:

```jldoctest tt_untagging
julia> ratio.amt
0.75

julia> typeof(ratio.amt)
Quantity{Float64, NoDims, Unitful.FreeUnits{(), NoDims, nothing}}

julia> ratio.amt.val
0.75

julia> typeof(ratio.amt.val)
Float64
```

Unfortunately, this is not type-stable, so the preferred way is described next:

### Untagging by type-stable `EngThermBase` functions

These are the `amt`, `bare`, and `pod` functions. In simple terms, the `amt()` function returns,
in a type-stable fashion, it's arguments' `amt` field (usually a `Quantity`). The `bare()`
function strips-off any units from the passed argument, thus returning an `AbstractFloat`
concrete subtype, which can be a `Measurement` type. Finally, the `pod()` function always
returns a "plain-old data", i.e., a value stripped off of units and uncertainty information:

```jldoctest tt_untagging
julia> other = _a(0.75 ± 0.05)
_₆₄: (0.75000 ± 0.050

julia> amt(other)
0.75 ± 0.05

julia> bare(other)
0.75 ± 0.05

julia> pod(other)
0.75

julia> typeof.([ F(other) for F in (amt, bare, pod) ])
3-element Vector{DataType}:
 Quantity{Measurement{Float64}, NoDims, Unitful.FreeUnits{(), NoDims, nothing}}
 Measurement{Float64}
 Float64
```

A corrollary is that, for exact `AMOUNTS`, both `bare()` and `pod()` functions return the same
thing:

```jldoctest tt_untagging
julia> exact = _a(0.75)
_₆₄: 0.75000

julia> typeof.([ F(exact) for F in (amt, bare, pod) ])
3-element Vector{DataType}:
 Quantity{Float64, NoDims, Unitful.FreeUnits{(), NoDims, nothing}}
 Float64
 Float64

julia> bare(exact) === pod(exact)
true
```

### Untagging by using `AMOUNTS` as `functors`

Sometimes the added syntax `.amt`, or `amt()`, or `bare()`, or `pod()` gets in the user's way by
making an expression longer and less readable than their untagging counterparts. Starting on
`v0.3.3`, all `AMOUNTS` are now callable, i.e., objects that can be used as functions, or,
`functors`.

The advantage of using `functors` includes the minimal added syntax — a mere `()` after the
identifier, which is more readable than the previously presented options. Moreover, the
`functor` usage allows for parameters to be passed, which is a very convenient way of not only
untagging the quantity, but also performing unit conversion.

```jldoctest tt_untagging
julia> ratio()
0.75

julia> ratio() === amt(ratio) === ratio.amt
true

julia> ratio(u"percent")
75.0 %
```

Hopefully this last example gives a hint of how useful the `functor` functionality has become
for Engineering Thermodynamic `AMOUNTS`.


## Whole Amounts

`EngThermBase` whole amounts are representative of thermophysical quantities that are unbased,
i.e., not being of per system mass or per system chemical amount, and of fixed units.

```jldoctest tt_amounts_whole
julia> using EngThermBase

```

```julia
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
julia> using TypeTree

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

```julia
help?> ø_
"ø_" can be typed by \o<tab>_

search: ø_ ø_amt

  Function to return generic dimensionless ratio amounts in (–).
```

### Property Whole Amounts

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

!!! note
	Function `amt()` is faster than accessing `amount.amt` because it is written in a
	type-stable manner.

The standard temperature and pressure are returned from corresponding functions with no numeric
arguments. For standard values, precision and exactness arguments are allowed:

```jldoctest tt_amounts_whole
julia> [ T_(), P_() ]
2-element Vector{WProperty{Float64, EX}}:
 T₆₄: 298.15 K
 P₆₄: 101.35 kPa

julia> [ T_(Float32, MM), P_(Float32, MM) ]
2-element Vector{WProperty{Float32, MM}}:
 T₃₂: (298.15 ± 5.7e-14 K)
 P₃₂: (101.35 ± 1.4e-14 kPa)
```

## Based Amounts

`EngThermBase` based amounts have a third parameter—the base `𝗯<:BASE=Union{DT, MA, MO, SY}`—on
top of everything that whole amounts have, such as precision- and exactness- parameters and
fixed units (for the System, `SY` base, and different and derivable units for the other, `{DT,
MA, MO}`, bases).

```jldoctest tt_amounts_based
julia> using EngThermBase

```

```julia
help?> BasedAmt
search: BasedAmt

  abstract type BasedAmt{𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} <: AMOUNTS{𝗽,𝘅} end

  Abstract supertype for based amount groups of fixed units.

  Hierarchy
  ===========

  BasedAmt <: AMOUNTS <: AbstractTherm <: Any
```

`EngThermBase` based amounts are concrete subtypes of `BasedAmt`, which itself subdivides into

- Interactions, `BInteract`,
- Properties, `BProperty`, and
- Unranked, `BUnranked`.

The distinctions between properties (`BProperty`) and interactions (`BInteract`) follow the
corresponding concepts in Engineering Thermodynamics. The unkanked (`BUnranked`) category exists
currently as an extension, for based physical amounts that do not fit the property/interaction
classification, and is currently devoid of concrete subtypes.

```jldoctest tt_amounts_based
julia> using TypeTree

julia> print(tt(BasedAmt, concrete=false)...)
BasedAmt
 ├─ BInteract{𝗽, 𝘅, 𝗯} where {𝗽, 𝘅, 𝗯<:BASE}
 ├─ BProperty{𝗽, 𝘅, 𝗯} where {𝗽, 𝘅, 𝗯<:BASE}
 └─ BUnranked{𝗽, 𝘅, 𝗯} where {𝗽, 𝘅, 𝗯<:BASE}
```

If a `BasedAmt` concrete subtype has (fixed) units of `kJ` for the System, `SY`, base; then it
will have units of `kJ/s` for the Rate, `DT`, base; units of `kJ/kg` for the mass, `MA`, base;
and units of `kJ/kmol` for the molar, `MO`, base. Therefore, the base parameter `𝗯` can be
inferred from:

- The fixed unit for the `SY` base, and
- The unit of a suitable input parameter (a `Number` with units).


## Based Interactions

Based interactions are concrete subtypes of `BInteract`, and include:

```jldoctest tt_amounts_based
julia> print(tt(BInteract, concrete=true)...)
BInteract
 ├─ deamt
 ├─ dsamt
 ├─ i_amt
 ├─ q_amt
 └─ w_amt
```

That is:

- Heat, in various bases:
	- total heat in `kJ`;
	- heat rate in `kJ/s`;
    - heat per system mass in `kJ/kg`;
    - heat per system chemical amount in `kJ/kmol`;
- Work, in various bases:
	- total work in `kJ`;
	- work rate in `kJ/s`;
    - work per system mass in `kJ/kg`;
    - work per system chemical amount in `kJ/kmol`;
- Energy variation (as of energy balance terms), in various bases; and
- Entropy variation (as of entropy balance terms), in various bases.

In the following examples, the base is inferred from the argument units:

```jldoctest tt_amounts_based
julia> [ q_(3.15 * i) for i in (u"kJ", u"kJ/s", u"kJ/kg", u"kJ/kmol") ]
4-element Vector{q_amt{Float64, EX}}:
 Q₆₄: 3.1500 kJ
 Q̇₆₄: 3.1500 kJ/s
 q₆₄: 3.1500 kJ/kg
 q̄₆₄: 3.1500 kJ/kmol

julia> [ w_(3.15 * i) for i in (u"kJ", u"kJ/s", u"kJ/kg", u"kJ/kmol") ]
4-element Vector{w_amt{Float64, EX}}:
 W₆₄: 3.1500 kJ
 Ẇ₆₄: 3.1500 kJ/s
 w₆₄: 3.1500 kJ/kg
 w̄₆₄: 3.1500 kJ/kmol
```

Note how based quantities in different bases display differently and according to mainstream
Engineering Thermodynamics textbooks, i.e., with lowercase letters for intensive quantities,
with the molar base indicated by an overbar, and rate indicated by an overdot.

In the following example, unitless amounts are passed to the constructors, which apply the
default intensive base, `DEF[:IB]`:

```jldoctest tt_amounts_based
julia> DEF[:IB]
MA

julia> [ F(300.0) for F in (q_, w_, de, ds) ]
4-element Vector{BInteract{Float64, EX, MA}}:
 q₆₄: 300.00 kJ/kg
 w₆₄: 300.00 kJ/kg
 Δe₆₄: 300.00 kJ/kg
 Δs₆₄: 300.00 kJ/K/kg
```

This exists as a shortcut, so that the user doesn't have to input units as to conveniently build
quantities, nor enter them as floating points if they aren't, as in the following energy balance
LHS example:

```jldoctest tt_amounts_based
julia> ENERGY_BALANCE_LHS = q_(200) - w_(150)
Δe₆₄: 50.000 kJ/kg

julia> [ q_(200), w_(150) ]
2-element Vector{BInteract{Float64, EX, MA}}:
 q₆₄: 200.00 kJ/kg
 w₆₄: 150.00 kJ/kg
```

Note that the primitives `q_(200)` and `w_(150)` build `q_amt` and `w_amt`, both `<:
BInteract{Float64, EX, MA}`. However, their sum (in the example energy balance) was
automatically re-labeled as a `deamt{Float64, EX, MA}`. The automatic re-labeling is one
proeminent feature of `EngThermBase`, and is explained in greater detail in the "Operations"
part of the documentation.


## Based Properties

Based properties are concrete subtypes of `BProperty`, and include:

```jldoctest tt_amounts_based
julia> print(tt(BProperty, concrete=true)...)
BProperty
 ├─ N_amt
 ├─ Pvamt
 ├─ RTamt
 ├─ R_amt
 ├─ Tsamt
 ├─ a_amt
 ├─ c_amt
 ├─ cpamt
 ├─ cvamt
 ├─ dpamt
 ├─ dxamt
 ├─ e_amt
 ├─ ekamt
 ├─ epamt
 ├─ g_amt
 ├─ h_amt
 ├─ j_amt
 ├─ m_amt
 ├─ psamt
 ├─ s_amt
 ├─ u_amt
 ├─ v_amt
 ├─ xiamt
 └─ y_amt
```

Their naming follow mainstream Engineering Thermodynamics textbooks, such as `v_`, `R_`,
`m_amt`, and `N_amt`, respectively for volume, gas constant, mass, and chemical amount; `u_`,
`h_`, `s_`, `a_`, and `g_`, respectively for internal energy, enthalpy, entropy, and Helmholtz
and Gibbs energy functions; `cp`, `cv`, `c_`, `ek`, `ep`, respectively for specific heat at
constant pressure, volume, incompressible substance specific heat, and kinetic and potential
energies; as well as `j_` and `r_` for the Massieu and Planck functions, as well as the `Pv`,
`RT`, and `Ts` products.

Beyond base inferring (from input dimensions) and default base application, the base can be
explicitly specified:

```jldoctest tt_amounts_based
julia> [ u_(200, __b) for __b in (SY, DT, MA, MO) ]
4-element Vector{u_amt{Float64, EX}}:
 U₆₄: 200.00 kJ
 U̇₆₄: 200.00 kJ/s
 u₆₄: 200.00 kJ/kg
 ū₆₄: 200.00 kJ/kmol
```

Moreover, unit conversions are performed, if needed:

```jldoctest tt_amounts_based
julia> u_(1u"btu")
U₆₄: 1.0551 kJ

julia> u_(1u"btu/lb")
u₆₄: 2.3260 kJ/kg
```

The gas constant, `R_`; mass, `m_`; and chemical amount, `N_`; have interesting representations
and values in different bases:

```jldoctest tt_amounts_based
julia> [ R_(0.5, __b) for __b in (SY, DT, MA, MO) ]
4-element Vector{R_amt{Float64, EX}}:
 mR₆₄: 0.50000 kJ/K
 ṁR₆₄: 0.50000 kJ/K/s
 R₆₄: 0.50000 kJ/K/kg
 R̄₆₄: 0.50000 kJ/K/kmol
```

The gas constant in the `(SY, DT, MA, MO)` bases represent, respectively (i) an `mR` product,
(ii) an `ṁR` product, (iii) a gas constant, and (iv) a molar gas constant, or universal gas
constant tag—`R_()` with no paramaters actually returns the universal gas constant:

```jldoctest tt_amounts_based
julia> R_()
R̄₆₄: 8.3145 kJ/K/kmol
```

The mass in the `(SY, DT, MA, MO)` bases represent, respectively (i) a system's mass, (ii) a
mass rate, (iii) a mass fraction, and (iv) a molar mass, or molecular mass (weight):

```jldoctest tt_amounts_based
julia> [ m_(0.5, __b) for __b in (SY, DT, MA, MO) ]
4-element Vector{m_amt{Float64, EX}}:
 m₆₄: 0.50000 kg
 ṁ₆₄: 0.50000 kg/s
 mf₆₄: 0.50000 kg/kg
 M₆₄: 0.50000 kg/kmol
```

The chemical amount in the `(SY, DT, MA, MO)` bases represent, respectively (i) a system's
chemical amount, (ii) a chemical amount rate, (iii) a specific chemical amount, and (iv) a molar
fraction:

```jldoctest tt_amounts_based
julia> [ N_(0.5, __b) for __b in (SY, DT, MA, MO) ]
4-element Vector{N_amt{Float64, EX}}:
 N₆₄: 0.50000 kmol
 Ṅ₆₄: 0.50000 kmol/s
 n₆₄: 0.50000 kmol/kg
 y₆₄: 0.50000 kmol/kmol
```

Product quantities can be build directly or from their defining products:

```jldoctest tt_amounts_based
julia> PV = [ P_() * v_(12, SY) ]
1-element Vector{Pvamt{Float64, EX, SY}}:
 PV₆₄: 1216.2 kJ

julia> mRT = [ m_(2, SY) * R_(2) * T_(300) ]
1-element Vector{RTamt{Float64, EX, SY}}:
 mRT₆₄: 1200.0 kJ
```

"Canonical", or defining ratios, such as ``Pv / RT`` or ``PV / mRT`` (≝ ``Z``), return the
amount defined by them:

```jldoctest tt_amounts_based
julia> PV ./ mRT
1-element Vector{Z_amt{Float64, EX}}:
 Z₆₄: 1.0135 –

julia> ( P_() * v_(12, MA) ) / ( R_(2, MA) * T_(300) )
Z₆₄: 2.0270 –

julia> ( P_() * v_(12, MO) ) / ( R_(2, MO) * T_(300) )
Z₆₄: 2.0270 –

julia> ( P_() * v_(12, SY) ) / ( R_(2, SY) * T_(300) )
Z₆₄: 2.0270 –

julia> ( P_() * v_(12, DT) ) / ( R_(2, DT) * T_(300) )
Z₆₄: 2.0270 –
```


