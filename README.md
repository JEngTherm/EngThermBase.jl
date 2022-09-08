# EngThermBase.jl
Basic types and functionality for Engineering Thermodynamics

# Description
The `EngThermBase.jl` package is, as the name suggests, a base package for engineering
thermodynamic calculations that supports units (through `Unitful.jl`) and uncertainty
propagation (though `Measurements.jl`).

Being a basic package, `EngThermBase.jl` capabilities mainly lie in the type structure it
provides around organizing thermodynamic concepts and amounts. The former is achieved with
abstract types, while the latter with concrete types. Moreover, the package defines some
thermodynamic constants that are not associated with any particular substance.

## Structure (Abstract Types)

The kind of thermodynamic concepts dealt with abstract types include:

- `BASES`: whether mass `MA`, or molar `MO`; exact `EX`, or measurement `MM`; System `SY`, or
  rate `DT` for thermodynamic amounts;
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

