# EngThermBase.jl

Basic types and functionality for Engineering Thermodynamics

# Description

The `EngThermBase.jl` package is, as the name suggests, a base package for engineering        
thermodynamic calculations that supports:

- Thermodynamic **amount tagging**,
- **Units** (through `Unitful.jl`), and
- **Uncertainty propagation** (through `Measurements.jl`).

Tagged thermodynamic amounts have default (SI) units following mainstream Engineering
Thermodynamics Textbooks, and are parametric with respect to floating point **precision**,
amount **exactness** — i.e., whether or not the amount has uncertainty: `MM` (measurement) and
`EX` (exact), respectively; and **thermodynamic base**, i.e., whether `MA` (mass) or `MO`
(molar) ones, and also `SY` (system) for extensive amounts and `DT` (time derivative) for
extensive rates:

```julia
julia> using EngThermBase

julia> DEF[:pprint] = false;   # Package has a pretty print option

julia> s1 = s(4.22f0, MA)      # Builds a specific entropy amount in mass base
sAmt{Float32, EX, MA}(4.2200 kJ/K/kg)

julia> s2 = s(3.14f0)          # Default base is applied if the base argument is missing
sAmt{Float32, EX, MA}(3.1400 kJ/K/kg)

julia> DEF[:IB]                # `DEF[:IB]` is the default [I]ntensive [B]ase
MA

julia> u1 = u(500 ± 50)        # Thermodynamic amounts can have uncertainties
uAmt{Float64, MM, MA}(500.00 ± 50. kJ/kg)

julia> T1 = T()                # T() returns the standard temperature
sysT{Float64, EX}(298.15 K)

julia> a1 = u1 - T1 * s1       # An equation for a Helmholtz function, showing type promotions
ΔeAmt{Float64, MM, MA}(-758.19 ± 50. kJ/kg)

julia> a1 = a(a1)              # Re-tagging a generic energy amount (ΔeAmt) into a Helmholtz function
aAmt{Float64, MM, MA}(-758.19 ± 50. kJ/kg)

julia> DEF[:pprint] = true;    # Now turning on the pretty-printing

julia> [a1, s1, u1, T1]        # which is just as informative and more concise
4-element Vector{AMOUNTS}:
 a₆₄: (-758.19 ± 50. kJ/kg)
 s₃₂: 4.2200 kJ/K/kg
 u₆₄: (500.00 ± 50. kJ/kg)
 T₆₄: 298.15 K

julia> DEF[:showPrec] = false; # Turning off the precision-showing flag

julia> [a1, s1, u1, T1]        # causes the output to be a bit more concise
4-element Vector{AMOUNTS}:
 a: (-758.19 ± 50. kJ/kg)
 s: 4.2200 kJ/K/kg
 u: (500.00 ± 50. kJ/kg)
 T: 298.15 K
```

Being a basic package, `EngThermBase.jl` capabilities mainly lie in the type structure it
provides around organizing thermodynamic concepts and amounts. The former is achieved with
abstract types, while the latter with concrete types. Moreover, the package defines some
thermodynamic constants that are not associated with any particular substance.

## Thermodynamic Concepts (Abstract Types)

The kind of thermodynamic concepts dealt with abstract types include `BASES`, `AMOUNTS`, and
`MODELS`:

### Thermodynamic Bases:

```julia
julia> using TypeTree

julia> print(tt(BASES)...)
BASES
 ├─ ExactBase
 │   ├─ EX
 │   └─ MM
 └─ ThermBase
     ├─ ExtBase
     │   ├─ DT
     │   └─ SY
     └─ IntBase
         ├─ MA
         └─ MO
```

The `ExactBase` distinguishes the exact `EX` base from the measurement `MM` one.

`ThermBase`s can either be extensive: `ExtBase`; or intensive: `IntBase`. Extensive bases
distinguishes the system `SY` base from the rate `DT` one; while Intensive bases are either mass
`MA`, or molar `MO`.

### Thermodynamic Amounts:

The thermodynamic amounts are the usual Engineering Thermodynamics quantities, such as `P`, `T`,
`v`, `u`, `h`, `s`, etc.

Abstract `AMOUNTS` have either two or three parameters. Ubiquitous parameters are:

- The **precision** `𝗽 <: PREC`, with `PREC = Union{Float16, Float32, Float64, BigFloat}`;
- The **exactness** `𝘅 <: EXAC`, with `EXAC = Union{EX, MM}`;

while the third parameter:

- The **base** `𝗯 <: BASE`, with `BASE = Union{DT, MA, MO, SY}`;

appears only for `BasedAmt`, i.e., amounts for which a base can be defined, such as the internal
energy, but not temperature and pressure, for instance.

Abstract `AMOUNTS` sub-types include: `BasedAmt`, `WholeAmt`, and a general fallback `GenerAmt`:

```julia
julia> print(tt(AMOUNTS, concrete=false)...)
AMOUNTS
 ├─ BasedAmt{𝗽, 𝘅} where ...
 │   ├─ BInteract{𝗽, 𝘅, 𝗯} where ...
 │   ├─ BProperty{𝗽, 𝘅, 𝗯} where ...
 │   └─ BUnranked{𝗽, 𝘅, 𝗯} where ...
 ├─ GenerAmt{𝗽, 𝘅} where ...
 └─ WholeAmt{𝗽, 𝘅} where ...
     ├─ WInteract{𝗽, 𝘅} where ...
     ├─ WProperty{𝗽, 𝘅} where ...
     └─ WUnranked{𝗽, 𝘅} where ...
```

Either "based-" and "whole-" amounts — respectively `BasedAmt`, and `WholeAmt` — distinguishes
whether the quantity (amount) is a:

- **property**, i.e., a thermodynamic state function, whose variation are
  process-path-independent and have an exact differential; or an

- **interaction**, whose value is process-path-dependent and have an inexact differential; or an

- **unranked** one, i.e., one who is not classified in the above scheme.


HERE HERE HERE


- `AMOUNTS`: whether properties or interactions, based or otherwise thermodynamic quantities,
  with a precision (floating-point width) parameter;
- `MODELS`: for substance (medium), it's heat-capacity, and systems; and etc.

Moreover, parameter in types are also used to label the numerical precision, one of: `Float16`,
`Float32`, `Float64`, and `BigFloat`.

## Amounts (Concrete Types)

Concrete types include many thermodynamic *properties* and *interactions*, their conversions and
operations.

## Constants (Concrete Type Instances)

Some thermodynamic constants that aren't associated with any particular substance, are defined
in this packages, such as:

- The standard temperature and pressure;
- The universal gas constant;
- The constants (numbers) of Avogadro and Boltzmann.

# Examples

## Amount instantiation, display, and basic operations:

```julia
julia> using EngThermBase

julia> heat, work_rate, period = q(1250u"J"), w(-0.65u"kW"), TIME(2u"minute")
(Q₆₄: 1.2500 kJ, Ẇ₆₄: -0.65000 kJ/s, 𝗍₆₄: 120.00 s)

julia> work = work_rate * period
W₆₄: -78.000 kJ

julia> DEF[:pprint] = false # Disables pretty-printing of quantities
false

julia> heat, work
(qAmt{Float64, EX, SY}(1.2500 kJ), wAmt{Float64, EX, SY}(-78.000 kJ))

julia> heat + work
ΔeAmt{Float64, EX, SY}(-76.750 kJ)
```

This example shows that:

1. Thermodynamic quantities are stored and displayed with standard engineering units;
2. Certain usual known-type operations are implemented, such as `work_rate * period` yielding a
   `work` amount (correctly labeled as such);
3. Package behavior can be changed, such as whether or not to "pretty-print" quantities;
4. Same-unit quantities can be added (such as `heat + work`, as in an energy balance), resulting
   in a correctly labeled energy variation quantity.

## Amount inference:

```julia
julia> [ i isa Interact for i in (heat, work, work_rate, period) ]
4-element Vector{Bool}:
 1
 1
 1
 0

julia> [ i isa Property for i in (heat, work, work_rate, period) ]
4-element Vector{Bool}:
 0
 0
 0
 0

julia> [ i isa EngThermBase.ENERGYI for i in (heat, work, work_rate, period) ]
4-element Vector{Bool}:
 1
 1
 1
 0

julia> [ i isa EngThermBase.ENERGYP for i in (heat, work, work_rate, period) ]
4-element Vector{Bool}:
 0
 0
 0
 0

```

Thus `heat`, `work`, and `work_rate`:

1. They are    `Interact` (i.e., interactions);
2. They aren't `Property` (i.e., properties);
3. They are    `ENERGYI`  (i.e., energy interactions);
4. They aren't `ENERGYP`  (i.e., energy properties).

Moreover:

```julia
julia> [ i isa BInteract{Float64, EX, DT} for i in (heat, work, work_rate, period) ]
4-element Vector{Bool}:
 0
 0
 1
 0

```

5. Only `work_rate` is a `BInteract{Float64, EX, DT}`, i.e., a based
   interaction (`BInteract`), with an exact (`EX`) `Float64` precision
   *time-derivative* (`DT`) amount among `heat`, `work`, and `work_rate`, and
   `period`.

