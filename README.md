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

Amount inferences:

```julia
julia> using EngThermBase

julia> heat, work_rate, period = q(1250u"J"), w(-0.65u"kW"), TIME(2u"minute")
(Q₆₄: 1.2500 kJ, Ẇ₆₄: -0.65000 kJ/s, 𝗍₆₄: 120.00 s)

julia> work = work_rate * period
W₆₄: -78.000 kJ
```

