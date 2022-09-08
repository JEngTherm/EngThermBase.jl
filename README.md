# EngThermBase.jl
Basic types and functionality for Engineering Thermodynamics

# Description
The `EngThermBase.jl` package is, as the name suggests, a base package for engineering
thermodynamic calculations that supports units (through `Unitful.jl`) and uncertainty
propagation (though `Measurements.jl`).

Being a basic package, `EngThermBase.jl` capabilities mainly lie in the type structure it
provides around organizing thermodynamic concepts and amounts. The former is achieved with
abstract types, while the latter with concrete types.

The kind of thermodynamic concepts dealt with abstract types include:

- `BASES`, whether mass `MA`, or molar `MO` for thermodynamic amounts;
- System (or total) `SY` or Rate (or time derivative) `DT` bases;
- Exact `EX`, or Measurement `MM` bases for thermodynamic amounts.



with limited capabilities
in the field of engineering thermodynamic calculations.



It _defines various abstract types_ as to organize thermodynamic
information
