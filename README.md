# EngThermBase.jl

Basic definitions for Engineering Thermodynamics in Julia.

# Description

The `EngThermBase.jl` package aims at providing a common platform for engineering
thermodynamics packages and case calculations by implementing:

- Engineering thermodynamics quantities **tagging**, such as `P`, `T`, `v`, `u`, `h`, `s`,
  etc...
- Default (SI) **units** for tagged quantities—through
  [Unitful.jl](https://github.com/PainterQubits/Unitful.jl);
- Somewhat configurable thermodynamic amount **pretty-printing**, such as:
    - `P₆₄: 101.35 kPa`,
    - `v₆₄: 1.1800 m³/kg`,
    - `R̄₆₄: 8.3145 kJ/K/kmol`,
    - `Ma₆₄: 1.0333 –`,
    - `ṁ₆₄: 3.4560 kg/s`, etc...
- Automatic **re-tagging**, such as:
    - `u + P * v --> h`,
    - `u - T * s --> a`,
    - `(P * v) / (R * T) --> Z`, and the like;
- Thermodynamic **bases**, such as:
    - `MA` (mass),
    - `MO` (molar), etc... ones;
- Automatic **re-basing**, such as:
    - `u * m --> U`,
    - `R̄ / M --> R`,
    - `ṁ * q --> Q̇`, etc..., and
- **Uncertainty propagation**—through
  [Measurements.jl](https://github.com/JuliaPhysics/Measurements.jl).
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
@Misc{2022-NaaktgeborenC-EngThermBase,
  author       = {C. Naaktgeboren},
  title        = {{EngThermBase.jl} -- Basic definitions for Engineering Thermodynamics in Julia},
  howpublished = {Online},
  year         = {2022},
  journal      = {GitHub repository},
  publisher    = {GitHub},
  url          = {https://github.com/JEngTherm/EngThermBase.jl},
}
```


