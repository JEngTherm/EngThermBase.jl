![EngThermBase](https://github.com/JEngTherm/EngThermBase.jl/blob/master/docs/src/assets/logo-036.png?raw=true)

# EngThermBase.jl

Engineering Thermodynamics infrastructure in Julia.


# Description

The `EngThermBase.jl` package provides a common platform for:
- Engineering thermodynamics models and packages, and
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
default behavior is to untag itself, returning unaltered it's `amt` member. If,  however,  a
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

The above example illustrates that constructors apply default units to  unitless  arguments,
so that the default temperature unit, `K`, was applied by `T_` in  the  `T_(512)`  call.  An
analogous behavior is illusrtated with the `P_(1024)` call.

Untagging happens when the `x` and `y` objects are called (as  functors),  with  `x()`,  and
`y()`, in which case we see the plain underlying  values  of  `512.0  K`  and  `1024.0  kPa`
returned as a 2-tuple. Note that there's no more pretty-printing because the untagged values
are no longer `EngThermBase.jl` amounts.

In the last example, a unit conversion is performed when a unit is  passed  to  the  functor
call `x(u"°C")`, that returns 238.85 °C. Note again, the lack of pretty-printing.

Other untagging functions are: `amt`, `bare`, and `pod`; which, respectively return the  (i)
underlying amount (with units, just like the  functor),  (ii)  the  "bare"  numerical  value
without units, and (iii) a "plain-old data", which also strips from  bare  numerical  values
any possible accompanying error/uncertainty.

```julia
julia> x = T_(300 ± 0.1)
T₆₄∴ (300.00 ± 0.10 K)

julia> typeof(x)
T_amt{Float64, MM}

julia> [ F(x) for F in (amt, bare, pod) ]
3-element Vector{Number}:
 300.0 ± 0.1 K
       300.0 ± 0.1
           300.0
```

In this case,  `typeof(x)`  returns  `T_amt{Float64,  MM}`.  The  `MM`  exactness  parameter
indicates a measurement, powered by `Measurements.jl`.

It is worth noting that temperature `Measurement` exactness quantities pretty-print as `T₆₄∴
...` instead of `T₆₄: ...`, i.e., the employed separator changes from `:` to `∴`, as to more
explicitly convey that something "special" is  being  tagged  as  a  temperature,  i.e.,  an
underlying `Measurements` value. This change has been introduced on  `release-0.5`  for  all
`MM` exactness `AMOUNTS`.

Note that by applying the `amt()`, `bare()`, and `pod()`  functions  on  `x`,  returned  the
illustrated values, with all operations untagging `x`, returning a (i) unit-ed  measurement,
a (ii) unitless measurement, and a (iii) simple numeric value, or a plain-old data.


## Automatic re-tagging

Some common thermodynamic operations on tagged operands yield quantities of other tags.  For
instance, it is generally assumed that, whenever adding a pressure-volume product, `Pv`,  to
an internal energy  amount,  `u`—all  in  the  same  base—the  operation  should  return  an
_enthalpy_ amount, `h`, since

$h ≝ u + Pv$

and therefore, the  following  operations,  each  one  following  a  thermodynamic  quantity
_definition_, from other operands (amounts), return the corresponding quantity:

```julia
julia> u_(300) + P_(100) * v_(0.1)  # h ≝ u + P*v
h₆₄: 310.00 kJ/kg

julia> u_(400) - T_(300) * s_(1.0)  # a ≝ u - T*s
a₆₄: 100.00 kJ/kg

julia> (P_(100) * v_(0.1)) / (R_(0.2) * T_(500))  # Z ≝ (P*v) / (R*T)
Z₆₄: 0.10000 –

julia> ve(1500u"km/hr") / cs(1200u"km/hr")  # Ma ≝ 𝕧 / 𝕔
Ma₆₄: 1.2500 –

julia> cp(5) / cv(4)  # γ ≝ cp / cv
γ₆₄: 1.2500 –
```

In this example, the operation `u + P * v`  resulted  in  an  enthalpy,  `h`.  Moreover,  by
definition, `u - T * s --> a`, and `(P * v) / (R * T) --> Z`. Moreover, a Mach  number  `Ma`
of 1.25 is obtained by dividing the velocity of 1500 km/h by the sound speed of  1200  km/h,
and the classic ratio `cp / cv --> γ`.

If the automatic tagging is unwanted, one can always manually tag the result of  operations,
in the same way raw values are being tagged in the previous example.  As  long  as  physical
dimensions are consistent, manually re-tagging will work, as expected:

```julia
julia> specific_boundary_work = w_( u_(300) + P_(100) * v_(0.1) )
w₆₄: 310.00 kJ/kg
```

In the above example, which can occur in  the  Thermodynamic  context  of  a  boundary  work
**energy balance** calculation, the outermost call `w_()` is the  manual  re-tagging,  which
causes a specific work interation to be returned, instead of the default  specific  enthalpy
property.


## Automatic re-basing

`EngThermBase.jl` encodes the following

- Thermodynamic **bases**
    - `MA` (mass),
    - `MO` (molar),
    - `SY` (system, or extensive), and
    - `DT` (rate);

According to theory, the first two  are  intensive,  while  the  others,  extensive.  Here's
examples of what can be done computationally:

```julia
julia> specific_internal_energy = u_(300)
u₆₄: 300.00 kJ/kg

julia> system_mass = m_(3.0u"kg")
m₆₄: 3.0000 kg

julia> system_internal_energy = specific_internal_energy * system_mass
U₆₄: 900.00 kJ

julia> pars = [ system_mass, specific_internal_energy, system_internal_energy ]
3-element Vector{BProperty{Float64, EX}}:
 m₆₄: 3.0000 kg
 u₆₄: 300.00 kJ/kg
 U₆₄: 900.00 kJ

julia> intensive_pars = [ p for p in pars if baseof(p) <: IntBase ]
1-element Vector{u_amt{Float64, EX, MA}}:
 u₆₄: 300.00 kJ/kg

julia> extensive_pars = [ p for p in pars if baseof(p) <: ExtBase ]
2-element Vector{BProperty{Float64, EX, SY}}:
 m₆₄: 3.0000 kg
 U₆₄: 900.00 kJ
```

It is worth noting that an automatic change of base took place in the product  that  defined
the `system_internal_energy`, when a specific internal energy amount  was  multiplied  by  a
system mass amount, `EngThermBase.jl` returned a system (based) internal energy  amount,  in
`kJ`:

```julia
julia> typeof(system_internal_energy)
u_amt{Float64, EX, SY}

```


## Abstract Type Hierarchy

`EngThermBase.jl` conceptual abstract types have 5 (five) branches placed under the top-most
type `AbstractTherm`:

```julia
julia> using TypeTree

julia> subtypes(AbstractTherm)
5-element Vector{Any}:
 AMOUNTS
 AUX
 BASES
 COMBOS
 MODELS
```

The `AMOUNTS` are the tagged quantities and are already introduced above. The other branches
expand like the following:

```julia
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

julia> print(tt(COMBOS)...)
COMBOS
 ├─ PropPair{𝗽, 𝘅} where [...]
 │   ├─ ChFPair{𝗽, 𝘅} where [...]
 │   └─ EoSPair{𝗽, 𝘅} where [...]
 │       ├─ PvPair{𝕡, 𝕩} where [...]
 │       ├─ TPPair{𝕡, 𝕩} where [...]
 │       └─ TvPair{𝕡, 𝕩} where [...]
 ├─ PropQuad{𝗽, 𝘅} where [...]
 └─ PropTrio{𝗽, 𝘅} where [...]
     └─ TPxTrio{𝕡, 𝕩} where [...]

julia> print(tt(MODELS)...)
MODELS
 ├─ Heat{𝗽, 𝘅} where [...]
 │   ├─ BivarHeat{𝗽, 𝘅, 𝗯} where [...]
 │   ├─ ConstHeat{𝗽, 𝘅, 𝗯} where [...]
 │   ├─ GenerHeat{𝗽, 𝘅, 𝗯} where [...]
 │   └─ UnvarHeat{𝗽, 𝘅, 𝗯} where [...]
 ├─ Medium{𝗽, 𝘅} where [...]
 │   └─ Substance{𝗽, 𝘅} where [...]
 └─ System{𝗽, 𝘅} where [...]
     └─ Scope{𝗽, 𝘅} where [...]
         ├─ Mixtures{𝗽, 𝘅} where [...]
         │   ├─ Reactiv{𝗽, 𝘅} where [...]
         │   └─ Unreact{𝗽, 𝘅} where [...]
         └─ PureSubs{𝗽, 𝘅} where [...]

```

The **abstract  type  hyerarchy**  provides  **hooks**  for  thermodynamic  models  of  heat
capacity, pure substance (by equation of state,  or  EoS),  mixtures,  etc...  such  as  the
[IdealGasLib.jl](https://github.com/JEngTherm/IdealGasLib.jl).

For additional information and examples, please refer to the package's documentation.


## Auxiliary functions

Version `0.5.0` brought precision- and exactness- parametric `unvarSerF <: AuxFunc` generic
functions as to aid substance modeling, e.g., generic specific heat capacities. The function, in
it's "raw" state provided by `EngThermBase`, operates with unlabeled quantities, i.e., unitless
Julia numbers; however maintaining the typical `EngThermBase` precision- and exactness-
parameterization scheme, therefore: `unvarSerF{𝕡,𝕩} where {𝕡<:PREC,𝕩<:EXAC}`.

Interesting features of such functions is that (i) they are made to work with the rest of
`EngThermBase`, owing to the precision- and exactness- parameterization paradigm, but most
importantly, anticipating their use in univariate specific heat modeling, `unvarSerF` can be
generated by derivating (d/dx) or integrating (∫dx, or ∫dlnx) another `unvarSerF`.

This is accomplish due to the univariate generic design of `unvarSerF`, as well as julia
ecosystem libraries of `ForwardDiff`, for derivatives, and `QuadGK`, for integrations.

This is provided as to aid de development of substance modeling libraries, so that, if such a
function is instantiated through:

```julia
julia> cpN2 = unvarSerF(273.0, 1800.0, Function[x->28.9, x->-0.1571e-2*x, x->0.8081e-5*x^2, x->-2.873e-9*x^3], 0.59)
4∴term 𝑓₆₄(𝑥 ∈ [273.00; 1800.0])
```

i.e., a simple, 4-term Textbook Appendix function for `c̄p(T)` of Nitrogen gas, valid between
273K and 1800K with maximum %error of 0.59 — note all this information is embed in the
`unvarSerF` — then, derived `c̄v(T)`, `h̄(T)`, `ū(T)`, and `s̄(T)` functions can be conveniently
obtained by simply:

```julia
julia> cvN2 = cpN2 - bare(R_(MM))
5∴term 𝑓₆₄(𝑥 ∈ [273.00; 1800.0])

julia> h_N2 = ∫dx(cpN2, 300.0, 8723.0)
5∴term 𝑓₆₄(𝑥 ∈ [273.00; 1800.0])

julia> u_N2 = ∫dx(cvN2, 300.0, 8723.0)
6∴term 𝑓₆₄(𝑥 ∈ [273.00; 1800.0])

julia> s_N2 = ∫dlnx(cpN2, 300.0, 191.682)
5∴term 𝑓₆₄(𝑥 ∈ [273.00; 1800.0])
```

Preliminary tests, i.e., sample `julia-repl` manual comparisons at roughly 500K to 1000K -spaced
inputs showed the functions do predict intervals for `c̄p`, `c̄v`, `ū`, `h̄`, and `s̄` that contain
the values listed on another Textbook Appendix table for Nitrogen as an ideal gas.


## Author

Prof. C. Naaktgeboren, PhD. [Lattes](http://lattes.cnpq.br/8621139258082919).

Hermann von Helmholtz Energy Research Group
[DGP](http://dgp.cnpq.br/dgp/espelhogrupo/8462486184187645).

Federal University of Technology, Paraná
[(site)](http://portal.utfpr.edu.br/english), Guarapuava Campus.

`NaaktgeborenC <dot!> PhD {at!} gmail [dot!] com`


## License

This project is [licensed](https://github.com/JEngTherm/EngThermBase.jl/blob/master/LICENSE)
under the MIT license.


## Citations

How to cite this project:

```bibtex
@Misc{2024-NaaktgeborenC-EngThermBase,
  author       = {C. Naaktgeboren},
  title        = {{EngThermBase.jl} -- Engineering Thermodynamics infrastructure in Julia},
  howpublished = {Online},
  year         = {2024},
  journal      = {GitHub repository},
  publisher    = {GitHub},
  url          = {https://github.com/JEngTherm/EngThermBase.jl},
  note         = {release 0.5.1 of 24-10-25},
}
```


