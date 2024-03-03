![EngThermBase](https://github.com/JEngTherm/EngThermBase.jl/blob/master/docs/src/assets/logo-036.png?raw=true)

# EngThermBase.jl

Engineering Thermodynamics infrastructure in Julia.


# Description

The `EngThermBase.jl` package provides a common platform for:
- Engineering thermodynamics packages, and
- Case calculations.

## Engineering thermodynamics quantity tagging:

```julia
julia> using EngThermBase

julia> pars = [ T_(500u"°C"), P_(1u"MPa"), q_(800u"kJ/kg") ]
3-element Vector{AMOUNTS{Float64, EX}}:
 T₆₄: 773.15 K
 P₆₄: 1000.0 kPa
 q₆₄: 800.00 kJ/kg
```

In the above example, by respectivly using the  `T_`,  `P_`,  and  `q_`  constructors  (from
`EngThermBase.jl`),  the  respective  argument  quantities  of  `500u"°C"`,  `1u"MPa"`,  and
`800u"kJ/kg"` were **tagged** (or  labeled)  as  a  temperature,  a  pressure,  and  a  heat
interaction.

Once tagged, the quantity is stored and shown in **default units** for each  quantity  type,
meaning in the `T_(500u"°C")` constructor call, there was a unit conversion from 500 °C into
773.15 K, in the `P_(1u"MPa")` constructor call, there was a unit conversion from 1 MPa into
1000 kPa, and no unit conversion in the `q_(800u"kJ/kg")` constructor call.

Moreover, the quantities also pretty-print with a pre-settable amount of significant digits,
and optional floating point precision, as in the `T₆₄: 773.15 K` output, the  `T`  indicates
the quantity type---a temperature; the `₆₄` the underlying floating point precision  (of  64
bits), while `773.15 K` is the amount, powered by `Unitful.jl`.

```julia
julia> typeof(pars[1])
T_amt{Float64, EX}

julia> typeof(pars[3])
q_amt{Float64, EX, MA}
```

It is worth noting that amounts are parameterized. Amounts such as temperature and  pressure
are (1) floating-point precision-,  and  (2)  exactness-  parameterized,  for  instance,  in
`T_amt{Float64, EX}`, the precision  is  `Float64`,  and  the  exactness  is  `EX`,  meaning
"exact".

Due to `EngThermBase.jl` tagging and type tree, we can then make some theory  queries,  such
as "asking" whether or not quantities are (i) properties or (ii) interactions,  as  well  as
their base:

```julia
julia> property_pars = [ p for p in pars if p isa Property ]
2-element Vector{WProperty{Float64, EX}}:
 T₆₄: 773.15 K
 P₆₄: 1000.0 kPa

julia> interaction_pars = [ p for p in pars if p isa Interact ]
1-element Vector{q_amt{Float64, EX, MA}}:
 q₆₄: 800.00 kJ/kg

julia> precof(pars[3]), exacof(pars[3]), baseof(pars[3])
(Float64, EX, MA)
```

Therefore, `pars[1]` and `pars[2]`, respectively tagged as a temperature and a pressure, are
listed as properties, while `pars[3]`, tagged as a specific heat transfer, is listed  as  an
interaction. Moreover, its precision, exactness, and base are recovered in the last example,
with the `precof`, `exacof`, and `baseof` functions.


## Quantity untagging (and optional unit conversion):

In `EngThermBase.jl`, amounts are `functors`, meaning they can be called as a function.  The
default behavior is to untag itself, returning unaltered it's `val` member. If,  however,  a
unit is passed as an argument to the functor, a unit conversion will be attempted. All  unit
operations on `EngThermBase.jl` are powered by `Unitful.jl`.

```julia
julia> x, y = T_(512), P_(1024)
(T₆₄: 512.00 K, P₆₄: 1024.0 kPa)

julia> x(), y()
(512.0 K, 1024.0 kPa)

julia> x(u"°C")
238.85000000000002 °C
```

The example illustrates that constructors apply default units to unitless arguments, so that
the default temperature unit, `K`, was applied by `T_` in the `T_(512)` call.  An  analogous
behavior is illusrtated with the `P_(1024)` call.

Untagging happens when the `x` and `y` objects are called (as  functors),  with  `x()`,  and
`y()`, in which case we see the plain underlying  values  of  `512.0  K`  and  `1024.0  kPa`
returned as a 2-tuple. Nota that there's no mor pretty-printing because the values  are  not
`EngThermBase.jl` amounts.

In the last example, a unit conversion is performed when a unit is  passed  to  the  functor
call `x(u"°C")`, that returns 238.85 °C. Note again, the lack of pretty-printing.

Other untagging functions are: `amt`, `bare`, and `pod`; which, respectively return the  (i)
underlying amount (with units, just like the  functor),  (ii)  the  "bare"  numerical  value
without units, and (iii) a "plain-old data", which also strips from  bare  numerical  values
any possible uncertainty.

```julia
julia> x = T_(300 ± 0.1)
T₆₄: (300.00 ± 0.10 K)

julia> [ F(x) for F in (amt, bare, pod) ]
3-element Vector{Number}:
 300.0 ± 0.1 K
       300.0 ± 0.1
           300.0
```

In this case,  `typeof(x)`  returns  `T_amt{Float64,  MM}`.  The  `MM`  exactness  parameter
indicates a measurement, powered by `Measurements.jl`.

Note that by applying the `amt()`, `bare()`, and `pod()`  functions  on  `x`,  returned  the
illustrated values, with all operations untagging `x`, returning a (i) united measurement, a
(ii) unitless measurement, and a (iii) simple numeric value, or a plain-old data.


## Automatic re-tagging

Certain "known" operations with tagged operands yield quantities of  other,  however  known,
tags:

```julia
julia> u_(300) + P_(100) * v_(0.1)
h₆₄: 310.00 kJ/kg

julia> u_(400) - T_(300) * s_(1.0)
a₆₄: 100.00 kJ/kg

julia> (P_(100) * v_(0.1)) / (R_(0.2) * T_(500))
Z₆₄: 0.10000 –

julia> ve(1500u"km/hr") / cs(1200u"km/hr")
Ma₆₄: 1.2500 –

julia> cp(5) / cv(4)
γ₆₄: 1.2500 –
```

In this example, the operation `u + P * v`  resulted  in  an  enthalpy,  `h`.  Moreover,  by
definition, `u - T * s --> a`, and `(P * v) / (R * T) --> Z`. Moreover, a Mach  number  `Ma`
of 1.25 is obtained by dividing the velocity of 1500 km/h by the sound speed of  1200  km/h,
and the classic ratio `cp / cv --> γ`.


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
  note         = {release 0.3.6 of 23-09-05},
}
```


