# EngThermBase.jl

Basic definitions for Engineering Thermodynamics in julia.

# Description

The `EngThermBase.jl` package is, as the name suggests, a base package for engineering        
thermodynamic that provides:

- Engineering thermodynamics quantities **tagging**, such as `P`, `T`, `v`, `u`, `h`, `s`,
  etc...
- Default (SI) **units** for tagged quantities—through
  [`Unitful.jl`](https://github.com/PainterQubits/Unitful.jl);
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
  [`Measurements.jl`](https://github.com/JuliaPhysics/Measurements.jl).
- Exports an **abstract type hyerarchy** so as to provide **hooks** for thermodynamic models of
  heat capacity, pure substance (by equation of state, or EoS), mixtures, etc... such as
  [`IdealGasLib.jl`](https://github.com/JEngTherm/IdealGasLib.jl).

Thus, `EngThermBase.jl` can serve as basis for other (Engineering) Thermodynamics modules and
packages in julia.

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
  title        = {{EngThermBase.jl} -- Basic types and functionality for Engineering Thermodynamics in Julia},
  howpublished = {Online},
  year         = {2022},
  journal      = {GitHub repository},
  publisher    = {GitHub},
  url          = {https://github.com/JEngTherm/EngThermBase.jl},
}
```


