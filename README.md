![EngThermBase](https://github.com/JEngTherm/EngThermBase.jl/blob/master/docs/src/assets/logo-036.png?raw=true)

# EngThermBase.jl

Engineering Thermodynamics understructure in Julia.


# Description

The `EngThermBase.jl` package provides a common platform for engineering thermodynamics packages
and case calculations by implementing:

- Engineering thermodynamics quantity (such as `P`, `T`, `v`, `u`, `h`, `s`, etc.) **tagging**
  and **untagging** facilities;
    - Sample tagging:
        - `T1, P1 = T_(25u"°C"), P_(1u"atm")` yields `(T₆₄: 298.15 K, P₆₄: 101.33 kPa)`;
        - `TPPair(T1, P1)` yields `TPPair{Float64, EX}(T₆₄: 298.15 K, P₆₄: 101.33 kPa)`;
        - `v_(0.2332f0, MO), s_(Float16(6.623))` yields `(v̄₃₂: 0.23320 m³/kmol, s₁₆: 6.6211 kJ/K/kg)`.
    - Sample untagging:
        - `T1()` yields `298.15 K`;
        - `T1(u"°C")` yields `25.0 °C`.
- Floating point precision-, exactness-, and thermodynamic base- parameterized tags:
    - `TvPair(T1, v1)` yields `TvPair{Float64, EX, MA}(T₆₄: 298.15 K, v₆₄: 0.23320 m³/kg)`.
- Default (SI) **units** for tagged quantities—through
  [Unitful.jl](https://github.com/PainterQubits/Unitful.jl);
- **Uncertainty propagation**—through
  [Measurements.jl](https://github.com/JuliaPhysics/Measurements.jl).
- Somewhat configurable thermodynamic amount **pretty-printing**, such as:
    - `P₆₄: 101.35 kPa`,
    - `v₆₄: 1.1800 m³/kg`,
    - `R̄₆₄: (8.3145 ± 1.5e-05 kJ/K/kmol)`,
    - `Ma₆₄: 1.0333 –`,
    - `ṁ₆₄: 3.4560 kg/s`, etc...
- Automatic **re-tagging**, through Julia's multiple dispatch system, such as:
    - `u + P * v --> h`,
    - `u - T * s --> a`,
    - `(P * v) / (R * T) --> Z`, and the like;
- Thermodynamic **bases**, such as:
    - `MA` (mass),
    - `MO` (molar),
    - `SY` (system, or extensive), and
    - `DT` (rate);
- Automatic **re-basing**, such as:
    - `u * m --> U`, (mass-base intensive into extensive by multiplication by mass)
    - `R̄ / M --> R`, (molar-base intensive into mass-base intensive by division by molecular
      mass)
    - `ṁ * q --> Q̇`, etc..., and
- Exports an **abstract type hyerarchy** so as to provide **hooks** for thermodynamic models of
  heat capacity, pure substance (by equation of state, or EoS), mixtures, etc... such as the
  [IdealGasLib.jl](https://github.com/JEngTherm/IdealGasLib.jl).

For additional information and examples, please refer to the package's documentation.

## Author

Prof. C. Naaktgeboren, PhD. [Lattes](http://lattes.cnpq.br/8621139258082919).

Federal University of Technology, Paraná
[(site)](http://portal.utfpr.edu.br/english), Guarapuava Campus.

`NaaktgeborenC <dot!> PhD {at!} gmail [dot!] com`

## License

This project is [licensed](https://github.com/JEngTherm/EngThermBase.jl/blob/master/LICENSE)
under the MIT license.

## Citations

How to cite this project:

```bibtex
@Misc{2023-NaaktgeborenC-EngThermBase,
  author       = {C. Naaktgeboren},
  title        = {{EngThermBase.jl} -- Engineering Thermodynamics understructure in Julia},
  howpublished = {Online},
  month        = {August},
  year         = {2023},
  journal      = {GitHub repository},
  publisher    = {GitHub},
  url          = {https://github.com/JEngTherm/EngThermBase.jl},
  note         = {release 0.3.5 of 23-09-05},
}
```


