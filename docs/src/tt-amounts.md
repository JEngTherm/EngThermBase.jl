```@meta
DocTestFilters = r"[0-9\.]+ seconds \(.*\)"
```

# Amounts Tutori-Test

This "tutori-test"—i.e., a tutorial/test—goes through `AMOUNTS` instantiation, or quantity
(plain `Number`) tagging with `EngThermBase`:

## Generic Amounts

`EngThermBase` generic amounts are generic and bears no assumptions on units, and thus, can
represent any real quantity of any units, including dimensionless ones.

Their type is:

```jldoctest tt_amounts
julia> using EngThermBase

julia> __amt === __amt{𝗽,𝘅} where {𝗽,𝘅}
true

```

more precisely:

```jldoctest tt_amounts
julia> __amt === __amt{𝗽,𝘅} where {𝗽,𝘅}
true

```

Parameter `𝗽<:Union{Float16, Float32, Float64, BigFloat}` is the precision and `𝘅<:Union{EX,MM}`
is the exactness. Illegal instances include:

```jldoctest tt_amounts
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
- The corresponding exported function alias `𝗔` (`'𝗔': Unicode U+1D5D4` typed as "\bsansA"<tab>):

Input values can be any `Real` plain old data or unit'ed types.

Plain old data (POD) examples:

```jldoctest tt_amounts
julia> @time [ __amt(1), __amt(1//1), __amt(0x1) ]	# Type constructors
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

julia> @time [ _a(1), _a(1//1), _a(0x1) ]				# Exported function
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

julia> @time [ 𝗔(1), 𝗔(1//1), 𝗔(0x1) ]				# Exoprted function alias
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

