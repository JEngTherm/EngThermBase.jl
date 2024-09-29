#----------------------------------------------------------------------------------------------#
#                                    Amount Type Interface                                     #
#----------------------------------------------------------------------------------------------#

"""
`function deco end`\n
Interface to return a unique decorative `Symbol` from a method's argument type.
"""
function deco end

"""
`function ppu end`\n
Interface to pretty-print units.
"""
function ppu end

# An original 191113-212130 benchmark showed amt(x) is      faster than x.amt:
# An  updated 220927-010045 benchmark showed amt(x) is stil faster than x.amt:
#
# ```julia-repl
# julia> u1 = u_(1.0f0 ± 0.1f0, MO)
# ū₃₂: (1.0000 ± 0.10 kJ/kmol)
#
# julia> typeof(u1)
# u_amt{Float32, MM, MO}
#
# julia> @benchmark u1.amt
# ✂ ✂ ✂   median time:      29.054 ns   ✂ ✂ ✂
#
# julia> @benchmark amt(u1)
# ✂ ✂ ✂   median time:      16.784 ns   ✂ ✂ ✂
# ```
#
# An  updated 240926-192104 benchmark showed amt(x) is no longer faster than x.amt:
#
# ```julia-repl
# julia> u1 = u_(1.0f0 ± 0.1f0, MO)
# ū₃₂∴ (1.0000 ± 0.10000) kJ/kmol
# 
# julia> typeof(u1)
# u_amt{Float32, MM, MO}
# 
# julia> @benchmark u1.amt
#  ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
#  Time  (median):     13.243 ns              ┊ GC (median):    0.00%
# 
# julia> @benchmark amt(u1)
#  ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
#  Time  (median):     19.095 ns              ┊ GC (median):    0.00%
# ```
#

"""
`function amt end`\n
Interface to get an `AMOUNTS`' `:amt` field in a type-stable manner.
"""
function amt end

"""
`function bare end`\n
Interface to get an `AMOUNTS`' bare (without units) value in a type-stable manner.
"""
function bare end

"""
`function pod end`\n
Interface to get an `AMOUNTS`' POD (plain old data) value in a type-stable manner.
"""
function pod end

export deco, ppu, amt, bare, pod


#----------------------------------------------------------------------------------------------#
#                                     Generic Amount Type                                      #
#----------------------------------------------------------------------------------------------#

import Base: cp, convert
import Unicode: normalize
import Base: +, -, *, /

"""
Generic Amount type factory.
"""
function mkGenAmt(TYPE::Symbol,         # Type name:            :__amt
                  SUPT::Symbol,         # Supertype:            :GenerAmt
                  FNAM::Symbol,         # Function Name:        :_a
                  ALIA::Symbol,         # Function Alias:       :𝗔
                  SYMB::AbstractString, # Printing symbol:      "_"
                  WHAT::AbstractString, # Description:          "generic amounts"
                  DELT::Bool=false,     # Whether a Δ quantity
                 )
    # Constants
    i, f = DELT ? (3, 4) : (1, 2)
    𝑠SY = normalize((DELT ? "Δ" : "") * string(SYMB))
    # Documentation
    hiStr = tyArchy(eval(SUPT))
    dcStr = """
`struct $TYPE{𝗽<:PREC,𝘅<:EXAC} <: $SUPT{𝗽,𝘅}`\n
Precision-, and Exactness- parametric $WHAT amounts based in arbitrary units.\n
`$TYPE{𝗽,𝘅}` parameters are:\n
- Precision `𝗽<:Union{Float16,Float32,Float64,BigFloat}`;\n
- Exactness `𝘅<:Union{EX,MM}`, i.e., either a single, precise value or an uncertainty-bearing
  measurement, respectively;\n
A `$TYPE` can be natively constructed from the following argument types:\n
- A plain, unitless float;\n
- A plain, unitless `Measurement`; hence, any `AbstractFloat`;\n
- A `Quantity{AbstractFloat}` with any units.\n
## Hierarchy\n
`$(TYPE) <: $(hiStr)`
    """
    fnStr = "Function to return $WHAT amounts of arbitrary units."
    # @eval block
    @eval begin
        # Concrete type definition
        struct $TYPE{𝗽,𝘅} <: $SUPT{𝗽,𝘅}
            amt::UATY{𝗽} where 𝗽<:PREC
            # Inner, non-converting, parameter-determining constructors
            $TYPE(x::$TYPE{𝗽,𝘅}) where {𝗽<:PREC,𝘅<:EXAC} = new{𝗽,𝘅}(amt(x))
            $TYPE(x::Union{𝗽,UETY{𝗽}}) where 𝗽<:PREC = new{𝗽,EX}(_qty(x))
            $TYPE(x::Union{PMTY{𝗽},UMTY{𝗽}}) where 𝗽<:PREC = new{𝗽,MM}(_qty(x))
            # Inner, non-converting, fully-specified constructors
            (::Type{$TYPE{𝗽,EX}})(x::𝗽) where 𝗽<:PREC = new{𝗽,EX}(_qty(x))
            (::Type{$TYPE{𝗽,EX}})(x::PMTY{𝗽}) where 𝗽<:PREC = new{𝗽,EX}(_qty(x.val))
            (::Type{$TYPE{𝗽,MM}})(x::𝗽) where 𝗽<:PREC = new{𝗽,MM}(_qty(measurement(x)))
            (::Type{$TYPE{𝗽,MM}})(x::PMTY{𝗽}) where 𝗽<:PREC = new{𝗽,MM}(_qty(x))
            # Inner, unit-converting, fully-specified constructors
            # ----------------------------------------------------
            (::Type{$TYPE{𝗽,EX}})(x::UETY{𝗽}) where 𝗽<:PREC = begin
                new{𝗽,EX}(_qty(x))
            end
            (::Type{$TYPE{𝗽,MM}})(x::UMTY{𝗽}) where 𝗽<:PREC = begin
                new{𝗽,MM}(_qty(x))
            end
        end
        # Type documentation
        @doc $dcStr $TYPE
        # Make type callable (functor), for data extraction and unit conversion
        (x::$TYPE)() = amt(x)
        (x::$TYPE)(𝑢::Unitful.FreeUnits) = uconvert(𝑢, amt(x)) # checks left to Unitful
        # External constructors for other DataTypes:
        $TYPE(x::REAL) = $TYPE(float(x))
        $TYPE(x::uniR{𝗽}) where 𝗽<:REAL = $TYPE(float(x.val) * unit(x))
        $TYPE(x::AMOUNTS) = $TYPE(amt(x)) # AMOUNTS fallback
        # Precision-changing external constructors
        (::Type{$TYPE{𝘀}})(x::$TYPE{𝗽,EX}) where {𝘀<:PREC,𝗽<:PREC} = begin
            $TYPE(𝘀(amt(x).val) * unit(amt(x)))
        end
        (::Type{$TYPE{𝘀}})(x::$TYPE{𝗽,MM}) where {𝘀<:PREC,𝗽<:PREC} = begin
            $TYPE(Measurement{𝘀}(amt(x).val) * unit(amt(x)))
        end
        (::Type{$TYPE{𝘀}})(x::Union{𝗽,UETY{𝗽},PMTY{𝗽},UMTY{𝗽},
                                    REAL,uniR{𝘁},AMOUNTS}) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = begin
			$TYPE{𝘀}($TYPE(x))		# Fallback call
        end
        # Precision+Exactness-changing external constructors
        (::Type{$TYPE{𝘀,EX}})(x::$TYPE{𝗽,EX}) where {𝘀<:PREC,𝗽<:PREC} = begin
            $TYPE(𝘀(amt(x).val) * unit(amt(x)))
        end
        (::Type{$TYPE{𝘀,EX}})(x::$TYPE{𝗽,MM}) where {𝘀<:PREC,𝗽<:PREC} = begin
            $TYPE(𝘀(amt(x).val.val) * unit(amt(x)))
        end
        (::Type{$TYPE{𝘀,EX}})(x::Union{𝗽,UETY{𝗽},PMTY{𝗽},UMTY{𝗽},
                                       REAL,uniR{𝘁},AMOUNTS}) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = begin
            $TYPE{𝘀,EX}($TYPE(x)) 	# Fallback call
        end
        (::Type{$TYPE{𝘀,MM}})(x::$TYPE{𝗽,EX},
                              e::𝘀=𝘀(max(eps(𝘀), eps(amt(x).val)))) where {𝘀<:PREC,
                                                                           𝗽<:PREC} = begin
            $TYPE(measurement(𝘀(amt(x).val), e) * unit(amt(x)))
        end
        (::Type{$TYPE{𝘀,MM}})(x::$TYPE{𝗽,MM}) where {𝘀<:PREC,𝗽<:PREC} = begin
            $TYPE(Measurement{𝘀}(amt(x).val) * unit(amt(x)))
        end
        (::Type{$TYPE{𝘀,MM}})(x::Union{𝗽,UETY{𝗽},PMTY{𝗽},UMTY{𝗽},
                                       REAL,uniR{𝘁},AMOUNTS}) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = begin
            $TYPE{𝘀,MM}($TYPE(x)) 	# Fallback call
        end
        # Type export
        export $TYPE
        # Type-stabler wrapped amount obtaining function
        amt(x::$TYPE{𝗽,EX}) where 𝗽<:PREC = x.amt::Quantity{𝗽}
        amt(x::$TYPE{𝗽,MM}) where 𝗽<:PREC = x.amt::Quantity{Measurement{𝗽}}
        # Type-stabler bare amount obtaining function
        bare(x::$TYPE{𝗽,EX}) where 𝗽<:PREC = x.amt.val::𝗽
        bare(x::$TYPE{𝗽,MM}) where 𝗽<:PREC = x.amt.val::Measurement{𝗽}
        # Type-stabler pod amount obtaining function
        pod(x::$TYPE{𝗽,EX}) where 𝗽<:PREC = x.amt.val::𝗽
        pod(x::$TYPE{𝗽,MM}) where 𝗽<:PREC = x.amt.val.val::𝗽
        # Type-specific functions
        deco(x::$TYPE{𝗽,𝘅} where {𝗽,𝘅}) = Symbol($𝑠SY)
        ppu(x::$TYPE{𝗽,𝘅} where {𝗽,𝘅}) = string(unit(amt(x)))
        # Function interface
        function $FNAM end
        @doc $fnStr $FNAM
        # Indirect construction from Numb
        $FNAM(x::Union{Numb,AMOUNTS}) = $TYPE(x)
        # Function aliasing and export
        $ALIA = $FNAM
        export $FNAM, $ALIA
        # Conversions
        convert(::Type{$TYPE{𝘀,𝘅}}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC} = $TYPE{𝘀,𝘅}(y)
        convert(::Type{$TYPE{𝘀,𝘆}}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = $TYPE{𝘀,𝘆}(y)
        convert(::Type{$TYPE{𝘀}}, y::$TYPE{𝗽}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE{𝘀}(y)
        # SUPERTYPE Conversions
        convert(::Type{$SUPT{𝘀,𝘅}}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC} =
            convert($TYPE{𝘀}  , y)  # fallback call
        convert(::Type{$SUPT{𝘀,𝘆}}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} =
            convert($TYPE{𝘀,𝘆}, y)  # fallback call
        convert(::Type{$SUPT{𝘀}}  , y::$TYPE{𝗽}  ) where {𝘀<:PREC,𝗽<:PREC} =
            convert($TYPE{𝘀}  , y)  # fallback call
        # AMOUNTS Conversions
        convert(::Type{AMOUNTS{𝘀,𝘅}}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC} =
            convert($TYPE{𝘀}  , y)  # fallback call
        convert(::Type{AMOUNTS{𝘀,𝘆}}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} =
            convert($TYPE{𝘀,𝘆}, y)  # fallback call
        convert(::Type{AMOUNTS{𝘀}}  , y::$TYPE{𝗽}  ) where {𝘀<:PREC,𝗽<:PREC} =
            convert($TYPE{𝘀}  , y)  # fallback call
        # Promotion rules
        promote_rule(::Type{$TYPE{𝘀,𝘆}},
                     ::Type{$TYPE{𝗽,𝘅}}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}
        end
        # same-type sum,sub with Unitful promotion
        +(x::$TYPE{𝘀,𝘆}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}(+(amt(x), amt(y)))
        end
        -(x::$TYPE{𝘀,𝘆}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}(-(amt(x), amt(y)))
        end
        # scalar mul,div with Unitful promotion
        *(y::plnF{𝘀}, x::$TYPE{𝗽}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(*(amt(x), y))
        *(x::$TYPE{𝗽}, y::plnF{𝘀}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(*(amt(x), y))
        /(x::$TYPE{𝗽}, y::plnF{𝘀}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(/(amt(x), y))
        # Type-preserving scalar mul,div
        *(y::REAL, x::$TYPE{𝗽}) where 𝗽<:PREC = $TYPE(*(amt(x), 𝗽(y)))
        *(x::$TYPE{𝗽}, y::REAL) where 𝗽<:PREC = $TYPE(*(amt(x), 𝗽(y)))
        /(x::$TYPE{𝗽}, y::REAL) where 𝗽<:PREC = $TYPE(/(amt(x), 𝗽(y)))
    end
end

#----------------------------------------------------------------------------------------------#
#                                 Generic Amount Declarations                                  #
#----------------------------------------------------------------------------------------------#

# The fallback generic amount
mkGenAmt(:__amt, :GenerAmt, :_a, :𝗔, "_", "generic", false)


#----------------------------------------------------------------------------------------------#
#                                  Whole Amount Type Factory                                   #
#----------------------------------------------------------------------------------------------#

"""
Whole Amount type factory.
"""
function mkWhlAmt(TYPE::Symbol,         # Type name:            :T_amt
                  SUPT::Symbol,         # Supertype:            :WProperty
                  FNAM::Symbol,         # Function Name:        :T_
                  ALIA::Symbol,         # Function Alias:       :𝗧
                  SYMB::AbstractString, # Printing symbol:      "T"
                  UNIT::Unitful.Units,  # SY quantity units:    u"K"
                  USTR::AbstractString, # PrettyPrinting units: "K"
                  WHAT::AbstractString, # Description:          "temperature"
                  DELT::Bool=false,     # Whether a Δ quantity
                 )
    # Constants
    uSY = UNIT
    𝑢SY = typeof(uSY)
    𝑑SY = dimension(uSY)
    i, f = DELT ? (3, 4) : (1, 2)
    𝑠SY = normalize((DELT ? "Δ" : "") * string(SYMB))
    # Documentation
    hiStr = tyArchy(eval(SUPT))
    dcStr = """
`struct $TYPE{𝗽<:PREC,𝘅<:EXAC} <: $SUPT{𝗽,𝘅}`\n
Precision-, and Exactness- parametric $WHAT amounts based in $USTR.\n
`$TYPE{𝗽,𝘅}` parameters are:\n
- Precision `𝗽<:Union{Float16,Float32,Float64,BigFloat}`;\n
- Exactness `𝘅<:Union{EX,MM}`, i.e., either a single, precise value or an uncertainty-bearing
  measurement, respectively;\n
A `$TYPE` can be natively constructed from the following argument types:\n
- A plain, unitless float;\n
- A plain, unitless `Measurement`; hence, any `AbstractFloat`;\n
- A `Quantity{AbstractFloat}` with compatible units.\n
Constructors determine all parameters from their arguments.\n
## Hierarchy\n
`$(TYPE) <: $(hiStr)`
    """
    fnStr = "Function to return $WHAT amounts in ($USTR)."
    # @eval block
    @eval begin
        # Concrete type definition
        struct $TYPE{𝗽,𝘅} <: $SUPT{𝗽,𝘅}
            amt::UATY{𝗽,$𝑑SY,$𝑢SY} where 𝗽<:PREC
            # Inner, non-converting, parameter-determining constructors
            # ---------------------------------------------------------
            # Copy constructor
            $TYPE(x::$TYPE{𝗽,𝘅}) where {𝗽<:PREC,𝘅<:EXAC} = new{𝗽,𝘅}(amt(x))
            # Plain constructors enforce default units & avoid unit conversion
            $TYPE(x::𝗽) where 𝗽<:PREC = new{𝗽,EX}(_qty(x * $uSY))
            $TYPE(x::PMTY{𝗽}) where 𝗽<:PREC = new{𝗽,MM}(_qty(x * $uSY))
            # Quantity constructors have to perform unit conversion despite matching dimensions
            $TYPE(x::UETY{𝗽,$𝑑SY}) where 𝗽<:PREC = new{𝗽,EX}(_qty(uconvert($uSY, x)))
            $TYPE(x::UMTY{𝗽,$𝑑SY}) where 𝗽<:PREC = new{𝗽,MM}(_qty(uconvert($uSY, x)))
            # Inner, non-converting, fully-specified constructors
            # ---------------------------------------------------
            (::Type{$TYPE{𝗽,EX}})(x::𝗽) where 𝗽<:PREC = new{𝗽,EX}(_qty(x * $uSY))
            (::Type{$TYPE{𝗽,EX}})(x::PMTY{𝗽}) where 𝗽<:PREC = new{𝗽,EX}(_qty(x.val * $uSY))
            (::Type{$TYPE{𝗽,MM}})(x::𝗽) where 𝗽<:PREC = new{𝗽,MM}(_qty(measurement(x) * $uSY))
            (::Type{$TYPE{𝗽,MM}})(x::PMTY{𝗽}) where 𝗽<:PREC = new{𝗽,MM}(_qty(x * $uSY))
            # Inner, unit-converting, fully-specified constructors
            # ----------------------------------------------------
            (::Type{$TYPE{𝗽,EX}})(x::UETY{𝗽,$𝑑SY}) where 𝗽<:PREC = begin
                new{𝗽,EX}(_qty(uconvert($uSY, x)))
            end
            (::Type{$TYPE{𝗽,MM}})(x::UMTY{𝗽,$𝑑SY}) where 𝗽<:PREC = begin
                new{𝗽,MM}(_qty(uconvert($uSY, x)))
            end
        end
        # Type documentation
        @doc $dcStr $TYPE
        # Make type callable (functor), for data extraction and unit conversion
        (x::$TYPE)() = amt(x)
        (x::$TYPE)(𝑢::Unitful.FreeUnits{𝘂,$𝑑SY} where 𝘂) = uconvert(𝑢, amt(x))
        # External constructors for other DataTypes:
        $TYPE(x::REAL) = $TYPE(float(x))
        $TYPE(x::uniR{𝗽,$𝑑SY}) where 𝗽<:REAL = $TYPE(float(x.val) * unit(x))
        $TYPE(x::AMOUNTS) = $TYPE(amt(x)) # AMOUNTS fallback
        # Precision-changing external constructors
        (::Type{$TYPE{𝘀}})(x::$TYPE{𝗽,EX}
                          ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(𝘀(amt(x).val))
        (::Type{$TYPE{𝘀}})(x::$TYPE{𝗽,MM}
                          ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(Measurement{𝘀}(amt(x).val))
        (::Type{$TYPE{𝘀}})(x::Union{𝗽,UETY{𝗽},PMTY{𝗽},UMTY{𝗽},REAL,uniR{𝘁},AMOUNTS}
                          ) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀}($TYPE(x)) # Fallback
        # Precision+Exactness-changing external constructors
        (::Type{$TYPE{𝘀,EX}})(x::$TYPE{𝗽,EX}
                             ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(𝘀(amt(x).val))
        (::Type{$TYPE{𝘀,EX}})(x::$TYPE{𝗽,MM}
                             ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(𝘀(amt(x).val.val))
        (::Type{$TYPE{𝘀,EX}})(x::Union{𝗽,UETY{𝗽},PMTY{𝗽},UMTY{𝗽},REAL,uniR{𝘁},AMOUNTS}
                             ) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀,EX}($TYPE(x)) # Fallback
        (::Type{$TYPE{𝘀,MM}})(x::$TYPE{𝗽,EX},
                              e::𝘀=𝘀(max(eps(𝘀),eps(amt(x).val)))
                             ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(measurement(𝘀(amt(x).val), e))
        (::Type{$TYPE{𝘀,MM}})(x::$TYPE{𝗽,MM}
                             ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(Measurement{𝘀}(amt(x).val))
        (::Type{$TYPE{𝘀,MM}})(x::Union{𝗽,UETY{𝗽},PMTY{𝗽},UMTY{𝗽},REAL,uniR{𝘁},AMOUNTS}
                             ) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀,MM}($TYPE(x)) # Fallback
        # Type export
        export $TYPE
        # Type-stable wrapped amount obtaining function
        amt(x::$TYPE{𝗽,EX}) where 𝗽<:PREC = x.amt::Quantity{𝗽,$𝑑SY,$𝑢SY}
        amt(x::$TYPE{𝗽,MM}) where 𝗽<:PREC = x.amt::Quantity{Measurement{𝗽},$𝑑SY,$𝑢SY}
        # Type-stable bare amount obtaining function
        bare(x::$TYPE{𝗽,EX}) where 𝗽<:PREC = x.amt.val::𝗽
        bare(x::$TYPE{𝗽,MM}) where 𝗽<:PREC = x.amt.val::Measurement{𝗽}
        # Type-stable pod amount obtaining function
        pod(x::$TYPE{𝗽,EX}) where 𝗽<:PREC = x.amt.val::𝗽
        pod(x::$TYPE{𝗽,MM}) where 𝗽<:PREC = x.amt.val.val::𝗽
        # Type-specific functions
        deco(x::$TYPE{𝗽,𝘅} where {𝗽,𝘅}) = Symbol($𝑠SY)
        ppu(x::$TYPE{𝗽,𝘅} where {𝗽,𝘅}) = $USTR
        # Function interface
        function $FNAM end
        @doc $fnStr $FNAM
        # Indirect construction from Numb
        $FNAM(x::Union{Numb,AMOUNTS}) = $TYPE(x)
        # Function aliasing and export
        $ALIA = $FNAM
        export $FNAM, $ALIA
        # Conversions
        convert(::Type{$TYPE{𝘀,𝘅}}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC} = $TYPE{𝘀,𝘅}(y)
        convert(::Type{$TYPE{𝘀,𝘆}}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = $TYPE{𝘀,𝘆}(y)
        convert(::Type{$TYPE{𝘀}}, y::$TYPE{𝗽}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE{𝘀}(y)
        # Promotion rules
        promote_rule(::Type{$TYPE{𝘀,𝘆}},
                     ::Type{$TYPE{𝗽,𝘅}}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}
        end
        # same-type sum,sub with Unitful promotion
        +(x::$TYPE{𝘀,𝘆}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}(+(amt(x), amt(y)))
        end
        -(x::$TYPE{𝘀,𝘆}, y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}(-(amt(x), amt(y)))
        end
        # scalar mul,div with Unitful promotion
        *(y::plnF{𝘀}, x::$TYPE{𝗽}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(*(amt(x), y))
        *(x::$TYPE{𝗽}, y::plnF{𝘀}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(*(amt(x), y))
        /(x::$TYPE{𝗽}, y::plnF{𝘀}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(/(amt(x), y))
        # Type-preserving scalar mul,div
        *(y::REAL, x::$TYPE{𝗽}) where 𝗽<:PREC = $TYPE(*(amt(x), 𝗽(y)))
        *(x::$TYPE{𝗽}, y::REAL) where 𝗽<:PREC = $TYPE(*(amt(x), 𝗽(y)))
        /(x::$TYPE{𝗽}, y::REAL) where 𝗽<:PREC = $TYPE(/(amt(x), 𝗽(y)))
    end
end


#----------------------------------------------------------------------------------------------#
#                           Thermodynamic Whole Amount Declarations                            #
#----------------------------------------------------------------------------------------------#

# Regular properties -- \bb#<TAB> velocity/speed function names
mkWhlAmt(:T_amt, :WProperty, :T_, :𝗧 , "T" , u"K"       , "K"       , "temperature", false)
mkWhlAmt(:P_amt, :WProperty, :P_, :𝗣 , "P" , u"kPa"     , "kPa"     , "pressure"   , false)
mkWhlAmt(:veamt, :WProperty, :ve, :𝕍 , "𝕍" , u"√(kJ/kg)", "√(kJ/kg)", "velocity"   , false)
mkWhlAmt(:spamt, :WProperty, :sp, :𝕧 , "𝕧" , u"m/s"     , "m/s"     , "speed"      , false)

# Regular unranked -- \sans#<TAB> function names
mkWhlAmt(:t_amt, :WUnranked, :t_, :𝘁 , "𝗍" , u"s"       , "s"       , "time"       , false)
mkWhlAmt(:gvamt, :WUnranked, :gv, :𝒈 , "𝒈" , u"m/s^2"   , "m/s²"    , "gravity"    , false)
mkWhlAmt(:z_amt, :WUnranked, :z_, :𝘇 , "𝗓" , u"km"      , "km"      , "altitude"   , false)

# Derived thermodynamic properties
mkWhlAmt(:Z_amt, :WProperty, :Z_, :𝗭 , "Z" , ULESS()    , "–"       , "generalized compressibility factor", false)
mkWhlAmt(:gaamt, :WProperty, :ga, :𝝲 , "γ" , ULESS()    , "–"       , "specific heat ratio"               , false)
mkWhlAmt(:beamt, :WProperty, :be, :𝝱 , "β" , inv(u"K")  , "/K"      , "coefficient of volume expansion"   , false)
mkWhlAmt(:kTamt, :WProperty, :kT, :𝝹𝗧, "κT", inv(u"kPa"), "/kPa"    , "isothermal compressibility"        , false)
mkWhlAmt(:ksamt, :WProperty, :ks, :𝝹𝘀, "κs", inv(u"kPa"), "/kPa"    , "isentropic compressibility"        , false)
mkWhlAmt(:k_amt, :WProperty, :k_, :𝗸 , "k" , ULESS()    , "–"       , "isentropic expansion exponent"     , false)
mkWhlAmt(:csamt, :WProperty, :cs, :𝗰𝘀, "𝕔" , u"√(kJ/kg)", "√(kJ/kg)", "adiabatic speed of sound"          , false)
mkWhlAmt(:Maamt, :WProperty, :Ma, :𝗠𝗮, "Ma", ULESS()    , "–"       , "Mach number"                       , false)
mkWhlAmt(:mJamt, :WProperty, :mJ, :𝝻𝗝, "μJ", u"K/kPa"   , "K/kPa"   , "Joule-Thomson coefficient"         , false)
mkWhlAmt(:mSamt, :WProperty, :mS, :𝝻𝗦, "μS", u"K/kPa"   , "K/kPa"   , "isentropic expansion coefficient"  , false)
mkWhlAmt(:x_amt, :WProperty, :x_, :𝘅 , "x" , ULESS()    , "–"       , "saturated vapor mass fraction"     , false)
mkWhlAmt(:Pramt, :WProperty, :Pr, :𝗣𝗿, "Pr", ULESS()    , "–"       , "relative pressure"                 , false)
mkWhlAmt(:vramt, :WProperty, :vr, :𝘃𝗿, "vr", ULESS()    , "–"       , "relative specific volume"          , false)

# Generic dimensionless ratio
mkWhlAmt(:ø_amt, :WUnranked, :ø_, :ø , "ø" , ULESS()    , "–"       , "generic dimensionless ratio"       , false)


#----------------------------------------------------------------------------------------------#
#                                  Based Amount Type Factory                                   #
#----------------------------------------------------------------------------------------------#

"""
Based Amount type factory.
"""
function mkBasAmt(TYPE::Symbol,         # Type Name:            :u_Amt
                  SUPT::Symbol,         # Supertype:            :BProperty
                  FNAM::Symbol,         # Function Name:        :u_
                  ALIA::Symbol,         # Function Alias:       :𝘂
                  SYMB::AbstractString, # Printing symbol:      "U"
                  UNIT::Unitful.Units,  # SY quantity units:    u"kJ"
                  USTR::AbstractString, # PrettyPrinting units: "K"
                  WHAT::AbstractString, # Description:          "internal energy"
                  DELT::Bool=false;     # Whether a Δ quantity
                  bsym::NTuple{4,Symbol}=(:none,:none,:none,:none)
                 )
    # Constants
    uSY = UNIT
    uDT = UNIT / u"s"
    uMA = UNIT / u"kg"
    uMO = UNIT / u"kmol"
    𝑢SY = typeof(uSY)
    𝑢DT = typeof(uDT)
    𝑢MA = typeof(uMA)
    𝑢MO = typeof(uMO)
    𝑑SY = dimension(uSY)
    𝑑DT = dimension(uDT)
    𝑑MA = dimension(uMA)
    𝑑MO = dimension(uMO)
    i, f = DELT ? (3, 4) : (1, 2)
    𝑠SY = bsym[1] == :none ?
        normalize((DELT ? "Δ" : "") * uppercase(string(SYMB))) :
        string(bsym[1])
    𝑠DT = bsym[2] == :none ?
        normalize(string(𝑠SY[1:i], "\u0307", 𝑠SY[f:end])) :
        string(bsym[2])
    𝑠MA = bsym[3] == :none ?
        normalize((DELT ? "Δ" : "") * lowercase(string(SYMB))) :
        string(bsym[3])
    𝑠MO = bsym[4] == :none ?
        normalize(string(𝑠MA[1:i], "\u0304", 𝑠MA[f:end])) :
        string(bsym[4])
    # Documentation
    hiStr = tyArchy(eval(SUPT))
    dcStr = """
`struct $TYPE{𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} <: $SUPT{𝗽,𝘅,𝗯}`\n
Precision-, Exactness-, and Base- parametric $WHAT amounts based in $USTR.\n
`$TYPE{𝗽,𝘅,𝗯}` parameters are:\n
- Precision `𝗽<:Union{Float16,Float32,Float64,BigFloat}`;\n
- Exactness `𝘅<:Union{EX,MM}`, i.e., either a single, precise value or an uncertainty-bearing
  measurement, respectively;\n
- Thermodynamic base `𝗯<:Union{SY,DT,MA,MO}` respectively for system, rate, mass, or molar
  quantities, respectively in units of $(uSY), $(uDT), $(uMA), or $(uMO).\n
A `$TYPE` can be natively constructed from the following argument types:\n
- A plain, unitless float;\n
- A plain, unitless `Measurement`; hence, any `AbstractFloat`;\n
- A `Quantity{AbstractFloat}` with compatible units.\n
Constructors determine parameters from their arguments. `Quantity` constructors do not need a
base argument. Plain, `AbstractFloat` ones require the base argument.\n
## Hierarchy\n
`$(TYPE) <: $(hiStr)`
    """
    fnStr = "Function to return $WHAT amounts in ($USTR)."
    # @eval block
    @eval begin
        # Concrete type definition
        struct $TYPE{𝗽,𝘅,𝗯} <: $SUPT{𝗽,𝘅,𝗯}
            amt::Union{UATY{𝗽,$𝑑SY,$𝑢SY},UATY{𝗽,$𝑑DT,$𝑢DT},
                       UATY{𝗽,$𝑑MA,$𝑢MA},UATY{𝗽,$𝑑MO,$𝑢MO}} where 𝗽<:PREC
            # Inner, non-converting, parameter-determining constructors
            # ---------------------------------------------------------
            # Copy constructor
            $TYPE(x::$TYPE{𝗽,𝘅,𝗯}) where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} = new{𝗽,𝘅,𝗯}(amt(x))
            # Plain constructors enforce default units & avoid unit conversion
            # Plain Exact (𝗽<:PREC) float constructors
            $TYPE(x::𝗽, ::Type{SY}) where 𝗽<:PREC = new{𝗽,EX,SY}(_qty(x * $uSY))
            $TYPE(x::𝗽, ::Type{DT}) where 𝗽<:PREC = new{𝗽,EX,DT}(_qty(x * $uDT))
            $TYPE(x::𝗽, ::Type{MA}) where 𝗽<:PREC = new{𝗽,EX,MA}(_qty(x * $uMA))
            $TYPE(x::𝗽, ::Type{MO}) where 𝗽<:PREC = new{𝗽,EX,MO}(_qty(x * $uMO))
            # Plain Measurement (PMTY) constructors
            $TYPE(x::PMTY{𝗽}, ::Type{SY}) where 𝗽<:PREC = new{𝗽,MM,SY}(_qty(x * $uSY))
            $TYPE(x::PMTY{𝗽}, ::Type{DT}) where 𝗽<:PREC = new{𝗽,MM,DT}(_qty(x * $uDT))
            $TYPE(x::PMTY{𝗽}, ::Type{MA}) where 𝗽<:PREC = new{𝗽,MM,MA}(_qty(x * $uMA))
            $TYPE(x::PMTY{𝗽}, ::Type{MO}) where 𝗽<:PREC = new{𝗽,MM,MO}(_qty(x * $uMO))
            # Quantity constructors have to perform unit conversion despite matching dimensions
            # United Exact (UETY) constructors
            $TYPE(x::UETY{𝗽,$𝑑SY}) where 𝗽<:PREC = new{𝗽,EX,SY}(_qty(uconvert($uSY, x)))
            $TYPE(x::UETY{𝗽,$𝑑DT}) where 𝗽<:PREC = new{𝗽,EX,DT}(_qty(uconvert($uDT, x)))
            $TYPE(x::UETY{𝗽,$𝑑MA}) where 𝗽<:PREC = new{𝗽,EX,MA}(_qty(uconvert($uMA, x)))
            $TYPE(x::UETY{𝗽,$𝑑MO}) where 𝗽<:PREC = new{𝗽,EX,MO}(_qty(uconvert($uMO, x)))
            # United Measurement (UMTY) constructors
            $TYPE(x::UMTY{𝗽,$𝑑SY}) where 𝗽<:PREC = new{𝗽,MM,SY}(_qty(uconvert($uSY, x)))
            $TYPE(x::UMTY{𝗽,$𝑑DT}) where 𝗽<:PREC = new{𝗽,MM,DT}(_qty(uconvert($uDT, x)))
            $TYPE(x::UMTY{𝗽,$𝑑MA}) where 𝗽<:PREC = new{𝗽,MM,MA}(_qty(uconvert($uMA, x)))
            $TYPE(x::UMTY{𝗽,$𝑑MO}) where 𝗽<:PREC = new{𝗽,MM,MO}(_qty(uconvert($uMO, x)))
            # Inner, non-converting, fully-specified constructors
            # ---------------------------------------------------
            # SY-based constructors
            (::Type{$TYPE{𝗽,EX,SY}})(x::𝗽) where 𝗽<:PREC = begin
                new{𝗽,EX,SY}(_qty(             x * $uSY))
            end
            (::Type{$TYPE{𝗽,EX,SY}})(x::PMTY{𝗽}) where 𝗽<:PREC = begin
                new{𝗽,EX,SY}(_qty(         x.val * $uSY))
            end
            (::Type{$TYPE{𝗽,MM,SY}})(x::𝗽) where 𝗽<:PREC = begin
                new{𝗽,MM,SY}(_qty(measurement(x) * $uSY))
            end
            (::Type{$TYPE{𝗽,MM,SY}})(x::PMTY{𝗽}) where 𝗽<:PREC = begin
                new{𝗽,MM,SY}(_qty(             x * $uSY))
            end
            # DT-based constructors
            (::Type{$TYPE{𝗽,EX,DT}})(x::𝗽) where 𝗽<:PREC = begin
                new{𝗽,EX,DT}(_qty(             x * $uDT))
            end
            (::Type{$TYPE{𝗽,EX,DT}})(x::PMTY{𝗽}) where 𝗽<:PREC = begin
                new{𝗽,EX,DT}(_qty(         x.val * $uDT))
            end
            (::Type{$TYPE{𝗽,MM,DT}})(x::𝗽) where 𝗽<:PREC = begin
                new{𝗽,MM,DT}(_qty(measurement(x) * $uDT))
            end
            (::Type{$TYPE{𝗽,MM,DT}})(x::PMTY{𝗽}) where 𝗽<:PREC = begin
                new{𝗽,MM,DT}(_qty(             x * $uDT))
            end
            # MA-based constructors
            (::Type{$TYPE{𝗽,EX,MA}})(x::𝗽) where 𝗽<:PREC = begin
                new{𝗽,EX,MA}(_qty(             x * $uMA))
            end
            (::Type{$TYPE{𝗽,EX,MA}})(x::PMTY{𝗽}) where 𝗽<:PREC = begin
                new{𝗽,EX,MA}(_qty(         x.val * $uMA))
            end
            (::Type{$TYPE{𝗽,MM,MA}})(x::𝗽) where 𝗽<:PREC = begin
                new{𝗽,MM,MA}(_qty(measurement(x) * $uMA))
            end
            (::Type{$TYPE{𝗽,MM,MA}})(x::PMTY{𝗽}) where 𝗽<:PREC = begin
                new{𝗽,MM,MA}(_qty(             x * $uMA))
            end
            # MO-based constructors
            (::Type{$TYPE{𝗽,EX,MO}})(x::𝗽) where 𝗽<:PREC = begin
                new{𝗽,EX,MO}(_qty(             x * $uMO))
            end
            (::Type{$TYPE{𝗽,EX,MO}})(x::PMTY{𝗽}) where 𝗽<:PREC = begin
                new{𝗽,EX,MO}(_qty(         x.val * $uMO))
            end
            (::Type{$TYPE{𝗽,MM,MO}})(x::𝗽) where 𝗽<:PREC = begin
                new{𝗽,MM,MO}(_qty(measurement(x) * $uMO))
            end
            (::Type{$TYPE{𝗽,MM,MO}})(x::PMTY{𝗽}) where 𝗽<:PREC = begin
                new{𝗽,MM,MO}(_qty(             x * $uMO))
            end
            # Inner, unit converting, fully-specified constructors
            # ----------------------------------------------------
            # SY-based constructors
            (::Type{$TYPE{𝗽,EX,SY}})(x::UETY{𝗽,$𝑑SY}) where 𝗽<:PREC = begin
                new{𝗽,EX,SY}(_qty(uconvert($uSY, x)))
            end
            (::Type{$TYPE{𝗽,MM,SY}})(x::UMTY{𝗽,$𝑑SY}) where 𝗽<:PREC = begin
                new{𝗽,MM,SY}(_qty(uconvert($uSY, x)))
            end
            # DT-based constructors
            (::Type{$TYPE{𝗽,EX,DT}})(x::UETY{𝗽,$𝑑DT}) where 𝗽<:PREC = begin
                new{𝗽,EX,DT}(_qty(uconvert($uDT, x)))
            end
            (::Type{$TYPE{𝗽,MM,DT}})(x::UMTY{𝗽,$𝑑DT}) where 𝗽<:PREC = begin
                new{𝗽,MM,DT}(_qty(uconvert($uDT, x)))
            end
            # MA-based constructors
            (::Type{$TYPE{𝗽,EX,MA}})(x::UETY{𝗽,$𝑑MA}) where 𝗽<:PREC = begin
                new{𝗽,EX,MA}(_qty(uconvert($uMA, x)))
            end
            (::Type{$TYPE{𝗽,MM,MA}})(x::UMTY{𝗽,$𝑑MA}) where 𝗽<:PREC = begin
                new{𝗽,MM,MA}(_qty(uconvert($uMA, x)))
            end
            # MO-based constructors
            (::Type{$TYPE{𝗽,EX,MO}})(x::UETY{𝗽,$𝑑MO}) where 𝗽<:PREC = begin
                new{𝗽,EX,MO}(_qty(uconvert($uMO, x)))
            end
            (::Type{$TYPE{𝗽,MM,MO}})(x::UMTY{𝗽,$𝑑MO}) where 𝗽<:PREC = begin
                new{𝗽,MM,MO}(_qty(uconvert($uMO, x)))
            end
        end
        # Type documentation
        @doc $dcStr $TYPE
        # Make type callable (functor), for data extraction and unit conversion
        (x::$TYPE)() = amt(x)
        (x::$TYPE{𝗽,𝘅,SY})(𝑢::Unitful.FreeUnits{𝘂,$𝑑SY} where 𝘂) where {𝗽,𝘅} = begin
            uconvert(𝑢, amt(x))
        end
        (x::$TYPE{𝗽,𝘅,DT})(𝑢::Unitful.FreeUnits{𝘂,$𝑑DT} where 𝘂) where {𝗽,𝘅} = begin
            uconvert(𝑢, amt(x))
        end
        (x::$TYPE{𝗽,𝘅,MA})(𝑢::Unitful.FreeUnits{𝘂,$𝑑MA} where 𝘂) where {𝗽,𝘅} = begin
            uconvert(𝑢, amt(x))
        end
        (x::$TYPE{𝗽,𝘅,MO})(𝑢::Unitful.FreeUnits{𝘂,$𝑑MO} where 𝘂) where {𝗽,𝘅} = begin
            uconvert(𝑢, amt(x))
        end
        # External constructors for other DataTypes:
        $TYPE(x::plnF) = $TYPE(x, DEF[:IB])
        $TYPE(x::REAL, b::Type{𝗯}=DEF[:IB]) where 𝗯<:BASE = $TYPE(float(x), b)
        $TYPE(x::Union{uniR{𝗽,$𝑑SY},uniR{𝗽,$𝑑DT},
                       uniR{𝗽,$𝑑MA},uniR{𝗽,$𝑑MO}}) where 𝗽<:REAL = begin
            $TYPE(float(x.val) * unit(x))
        end
        $TYPE(x::uniR{𝘁,$𝑑SY}, ::Type{SY}) where 𝘁<:REAL = $TYPE(x) # Fallback call
        $TYPE(x::uniR{𝘁,$𝑑DT}, ::Type{DT}) where 𝘁<:REAL = $TYPE(x) # Fallback call
        $TYPE(x::uniR{𝘁,$𝑑MA}, ::Type{MA}) where 𝘁<:REAL = $TYPE(x) # Fallback call
        $TYPE(x::uniR{𝘁,$𝑑MO}, ::Type{MO}) where 𝘁<:REAL = $TYPE(x) # Fallback call
        $TYPE(x::AMOUNTS) = $TYPE(amt(x)) # AMOUNTS fallback
        # Precision-changing external constructors
        (::Type{$TYPE{𝘀}})(x::$TYPE{𝗽,EX,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(𝘀(amt(x).val), 𝗯)
        end
        (::Type{$TYPE{𝘀}})(x::$TYPE{𝗽,MM,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(Measurement{𝘀}(amt(x).val), 𝗯)
        end
        (::Type{$TYPE{𝘀}})(x::Union{𝗽,UETY{𝗽},PMTY{𝗽},UMTY{𝗽},REAL,uniR{𝘁},AMOUNTS}
                          ) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = begin
            $TYPE{𝘀}($TYPE(x))  # Establishes base, then fallsback
        end
        (::Type{$TYPE{𝘀}})(x::Union{𝗽,UETY{𝗽,$𝑑SY},PMTY{𝗽},UMTY{𝗽,$𝑑SY},REAL,uniR{𝘁,$𝑑SY},AMOUNTS},
                           ::Type{SY}
                          ) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀}($TYPE(x, SY)) # Fallback call
        (::Type{$TYPE{𝘀}})(x::Union{𝗽,UETY{𝗽,$𝑑DT},PMTY{𝗽},UMTY{𝗽,$𝑑DT},REAL,uniR{𝘁,$𝑑DT},AMOUNTS},
                           ::Type{DT}
                          ) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀}($TYPE(x, DT)) # Fallback call
        (::Type{$TYPE{𝘀}})(x::Union{𝗽,UETY{𝗽,$𝑑MA},PMTY{𝗽},UMTY{𝗽,$𝑑MA},REAL,uniR{𝘁,$𝑑MA},AMOUNTS},
                           ::Type{MA}
                          ) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀}($TYPE(x, MA)) # Fallback call
        (::Type{$TYPE{𝘀}})(x::Union{𝗽,UETY{𝗽,$𝑑MO},PMTY{𝗽},UMTY{𝗽,$𝑑MO},REAL,uniR{𝘁,$𝑑MO},AMOUNTS},
                           ::Type{MO}
                          ) where {𝘀<:PREC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀}($TYPE(x, MO)) # Fallback call
        # Precision+Exactness-changing external constructors
        (::Type{$TYPE{𝘀,EX}})(x::$TYPE{𝗽,EX,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(𝘀(amt(x).val), 𝗯)
        end
        (::Type{$TYPE{𝘀,EX}})(x::$TYPE{𝗽,MM,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(𝘀(amt(x).val.val), 𝗯)
        end
        (::Type{$TYPE{𝘀,MM}})(x::$TYPE{𝗽,EX,𝗯}, e::𝘀=𝘀(max(eps(𝘀),eps(amt(x).val)))
                             ) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(measurement(𝘀(amt(x).val), e), 𝗯)
        end
        (::Type{$TYPE{𝘀,MM}})(x::$TYPE{𝗽,MM,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(Measurement{𝘀}(amt(x).val), 𝗯)
        end
        (::Type{$TYPE{𝘀,𝘅}})(x::Union{𝗽,UETY{𝗽},PMTY{𝗽},UMTY{𝗽},REAL,uniR{𝘁},AMOUNTS}
                            ) where {𝘀<:PREC,𝘅<:EXAC,𝗽<:PREC,𝘁<:REAL} = begin
            $TYPE{𝘀,𝘅}($TYPE(x))  # Establishes base, then fallsback
        end
        (::Type{$TYPE{𝘀,𝘅}})(x::Union{𝗽,UETY{𝗽,$𝑑SY},PMTY{𝗽},UMTY{𝗽,$𝑑SY},REAL,uniR{𝘁,$𝑑SY},AMOUNTS},
                             ::Type{SY}
                            ) where {𝘀<:PREC,𝘅<:EXAC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀,𝘅}($TYPE(x, SY)) # Fallback call
        (::Type{$TYPE{𝘀,𝘅}})(x::Union{𝗽,UETY{𝗽,$𝑑DT},PMTY{𝗽},UMTY{𝗽,$𝑑DT},REAL,uniR{𝘁,$𝑑DT},AMOUNTS},
                             ::Type{DT}
                            ) where {𝘀<:PREC,𝘅<:EXAC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀,𝘅}($TYPE(x, DT)) # Fallback call
        (::Type{$TYPE{𝘀,𝘅}})(x::Union{𝗽,UETY{𝗽,$𝑑MA},PMTY{𝗽},UMTY{𝗽,$𝑑MA},REAL,uniR{𝘁,$𝑑MA},AMOUNTS},
                             ::Type{MA}
                            ) where {𝘀<:PREC,𝘅<:EXAC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀,𝘅}($TYPE(x, MA)) # Fallback call
        (::Type{$TYPE{𝘀,𝘅}})(x::Union{𝗽,UETY{𝗽,$𝑑MO},PMTY{𝗽},UMTY{𝗽,$𝑑MO},REAL,uniR{𝘁,$𝑑MO},AMOUNTS},
                             ::Type{MO}
                            ) where {𝘀<:PREC,𝘅<:EXAC,𝗽<:PREC,𝘁<:REAL} = $TYPE{𝘀,𝘅}($TYPE(x, MO)) # Fallback call
        # Same-Base-explicit, precision+exactness-changing external constructors
        (::Type{$TYPE{𝘀,𝘅,𝗯}})(x::$TYPE{𝗽,𝘆,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC,𝘆<:EXAC,𝗯<:BASE} = begin
            $TYPE{𝘀,𝘅}(x)           # Fallback call to base-implicit constructors
        end
        (::Type{$TYPE{𝘀,𝘅,𝗯}})(x::Union{𝗽,UETY{𝗽},PMTY{𝗽},UMTY{𝗽},REAL,uniR{𝘁},AMOUNTS},
                               b::Type{𝗯}=𝗯
                              ) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC,𝘁<:REAL,𝗯<:BASE} = begin
            $TYPE{𝘀,𝘅}($TYPE(x, b))    # Fallback call
        end
        # Quantity external constructors with explicit base specification
        # United Exact (UETY) constructors
        $TYPE(x::UETY{𝗽,$𝑑SY}, ::Type{SY}) where 𝗽<:PREC = $TYPE(x) # internal constructor fallback
        $TYPE(x::UETY{𝗽,$𝑑DT}, ::Type{DT}) where 𝗽<:PREC = $TYPE(x) # internal constructor fallback
        $TYPE(x::UETY{𝗽,$𝑑MA}, ::Type{MA}) where 𝗽<:PREC = $TYPE(x) # internal constructor fallback
        $TYPE(x::UETY{𝗽,$𝑑MO}, ::Type{MO}) where 𝗽<:PREC = $TYPE(x) # internal constructor fallback
        # United Measurement (UMTY) constructors
        $TYPE(x::UMTY{𝗽,$𝑑SY}, ::Type{SY}) where 𝗽<:PREC = $TYPE(x) # internal constructor fallback
        $TYPE(x::UMTY{𝗽,$𝑑DT}, ::Type{DT}) where 𝗽<:PREC = $TYPE(x) # internal constructor fallback
        $TYPE(x::UMTY{𝗽,$𝑑MA}, ::Type{MA}) where 𝗽<:PREC = $TYPE(x) # internal constructor fallback
        $TYPE(x::UMTY{𝗽,$𝑑MO}, ::Type{MO}) where 𝗽<:PREC = $TYPE(x) # internal constructor fallback
        # Type export
        export $TYPE
        # Type-stable wrapped amount obtaining function
        amt(x::$TYPE{𝗽,EX,SY}) where 𝗽<:PREC = x.amt::Quantity{𝗽,$𝑑SY,$𝑢SY}
        amt(x::$TYPE{𝗽,EX,DT}) where 𝗽<:PREC = x.amt::Quantity{𝗽,$𝑑DT,$𝑢DT}
        amt(x::$TYPE{𝗽,EX,MA}) where 𝗽<:PREC = x.amt::Quantity{𝗽,$𝑑MA,$𝑢MA}
        amt(x::$TYPE{𝗽,EX,MO}) where 𝗽<:PREC = x.amt::Quantity{𝗽,$𝑑MO,$𝑢MO}
        amt(x::$TYPE{𝗽,MM,SY}) where 𝗽<:PREC = x.amt::Quantity{Measurement{𝗽},$𝑑SY,$𝑢SY}
        amt(x::$TYPE{𝗽,MM,DT}) where 𝗽<:PREC = x.amt::Quantity{Measurement{𝗽},$𝑑DT,$𝑢DT}
        amt(x::$TYPE{𝗽,MM,MA}) where 𝗽<:PREC = x.amt::Quantity{Measurement{𝗽},$𝑑MA,$𝑢MA}
        amt(x::$TYPE{𝗽,MM,MO}) where 𝗽<:PREC = x.amt::Quantity{Measurement{𝗽},$𝑑MO,$𝑢MO}
        # Type-stable bare amount obtaining function
        bare(x::$TYPE{𝗽,EX}) where 𝗽<:PREC = x.amt.val::𝗽
        bare(x::$TYPE{𝗽,MM}) where 𝗽<:PREC = x.amt.val::Measurement{𝗽}
        # Type-stable pod amount obtaining function
        pod(x::$TYPE{𝗽,EX}) where 𝗽<:PREC = x.amt.val::𝗽
        pod(x::$TYPE{𝗽,MM}) where 𝗽<:PREC = x.amt.val.val::𝗽
        # Type-specific functions
        deco(x::$TYPE{𝗽,𝘅,SY} where {𝗽,𝘅}) = Symbol($𝑠SY)
        deco(x::$TYPE{𝗽,𝘅,DT} where {𝗽,𝘅}) = Symbol($𝑠DT)
        deco(x::$TYPE{𝗽,𝘅,MA} where {𝗽,𝘅}) = Symbol($𝑠MA)
        deco(x::$TYPE{𝗽,𝘅,MO} where {𝗽,𝘅}) = Symbol($𝑠MO)
        ppu(x::$TYPE{𝗽,𝘅,SY} where {𝗽,𝘅}) = $USTR
        ppu(x::$TYPE{𝗽,𝘅,DT} where {𝗽,𝘅}) = $USTR * "/s"
        ppu(x::$TYPE{𝗽,𝘅,MA} where {𝗽,𝘅}) = $USTR * "/kg"
        ppu(x::$TYPE{𝗽,𝘅,MO} where {𝗽,𝘅}) = $USTR * "/kmol"
        # Function interface
        function $FNAM end
        @doc $fnStr $FNAM
        # Indirect construction from Numb
        $FNAM(x::Union{Numb,AMOUNTS}) = $TYPE(x)
        $FNAM(x::Numb, ::Type{𝗯}) where 𝗯<:BASE = $TYPE(x, 𝗯)
        # Function aliasing and export
        $ALIA = $FNAM
        export $FNAM, $ALIA
        # Conversions - Change of base is _not_ a conversion
        # Same {EXAC,BASE}, {PREC}- conversion
        convert(::Type{$TYPE{𝘀}}, y::$TYPE{𝗽,𝘅,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} = $TYPE{𝘀}(y)
        convert(::Type{$TYPE{𝘀,𝘅}}, y::$TYPE{𝗽,𝘅,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} = $TYPE{𝘀,𝘅}(y)
        convert(::Type{$TYPE{𝘀,𝘅,𝗯}}, y::$TYPE{𝗽,𝘅,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} = $TYPE{𝘀,𝘅}(y)
        # Same {BASE}, {PREC,EXAC}- conversion
        convert(::Type{$TYPE{𝘀,𝘆}}, y::$TYPE{𝗽,𝘅,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC,𝗯<:BASE} = $TYPE{𝘀,𝘆}(y)
        convert(::Type{$TYPE{𝘀,𝘆,𝗯}}, y::$TYPE{𝗽,𝘅,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC,𝗯<:BASE} = $TYPE{𝘀,𝘆}(y)
        # Promotion rules
        promote_rule(::Type{$TYPE{𝘀,𝘆,𝗯}},
                     ::Type{$TYPE{𝗽,𝘅,𝗯}}) where {𝘀<:PREC,𝗽<:PREC,
                                                  𝘆<:EXAC,𝘅<:EXAC,𝗯<:BASE} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅),𝗯}
        end
        # same-type sum,sub with Unitful promotion
        +(x::$TYPE{𝘀,𝘆,𝗯}, y::$TYPE{𝗽,𝘅,𝗯}) where {𝘀<:PREC,𝗽<:PREC,
                                                   𝘆<:EXAC,𝘅<:EXAC,
                                                   𝗯<:BASE} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅),𝗯}(+(amt(x), amt(y)))
        end
        -(x::$TYPE{𝘀,𝘆,𝗯}, y::$TYPE{𝗽,𝘅,𝗯}) where {𝘀<:PREC,𝗽<:PREC,
                                                   𝘆<:EXAC,𝘅<:EXAC,
                                                   𝗯<:BASE} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅),𝗯}(-(amt(x), amt(y)))
        end
        # scalar mul,div with Unitful promotion
        *(y::plnF{𝘀}, x::$TYPE{𝗽}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(*(amt(x), y))
        *(x::$TYPE{𝗽}, y::plnF{𝘀}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(*(amt(x), y))
        /(x::$TYPE{𝗽}, y::plnF{𝘀}) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(/(amt(x), y))
        # Type-preserving scalar mul,div
        *(y::REAL, x::$TYPE{𝗽}) where 𝗽<:PREC = $TYPE(*(amt(x), 𝗽(y)))
        *(x::$TYPE{𝗽}, y::REAL) where 𝗽<:PREC = $TYPE(*(amt(x), 𝗽(y)))
        /(x::$TYPE{𝗽}, y::REAL) where 𝗽<:PREC = $TYPE(/(amt(x), 𝗽(y)))
    end
end


#----------------------------------------------------------------------------------------------#
#                           Thermodynamic Amount Group Declarations                            #
#----------------------------------------------------------------------------------------------#

# Anomalous primitives and products
mkBasAmt(:m_amt, :BProperty, :m_, :𝗺 , "m" , u"kg"  , "kg"  , "mass"                , false, bsym=(:m  , :ṁ  , :mf, :M ))
mkBasAmt(:N_amt, :BProperty, :N_, :𝗡 , "N" , u"kmol", "kmol", "chemical amount"     , false, bsym=(:N  , :Ṅ  , :n , :y ))
mkBasAmt(:R_amt, :BProperty, :R_, :𝗥 , "mR", u"kJ/K", "kJ/K", "gas constant"        , false, bsym=(:mR , :ṁR , :R , :R̄ ))
mkBasAmt(:Pvamt, :BProperty, :Pv, :𝗣𝘃, "PV", u"kJ"  , "kJ"  , "flux work"           , false, bsym=(:PV , :PV̇ , :Pv, :Pv̄))
mkBasAmt(:RTamt, :BProperty, :RT, :𝗥𝗧, "RT", u"kJ"  , "kJ"  , "RT product"          , false, bsym=(:mRT, :ṁRT, :RT, :R̄T))
mkBasAmt(:Tsamt, :BProperty, :Ts, :𝗧𝘀, "Ts", u"kJ"  , "kJ"  , "Ts product"          , false, bsym=(:TS , :TṠ , :Ts, :Ts̄))

# Regular properties
mkBasAmt(:v_amt, :BProperty, :v_, :𝘃 , "V" , u"m^3" , "m³"  , "volume"              , false)
mkBasAmt(:u_amt, :BProperty, :u_, :𝘂 , "U" , u"kJ"  , "kJ"  , "internal energy"     , false)
mkBasAmt(:h_amt, :BProperty, :h_, :𝗵 , "H" , u"kJ"  , "kJ"  , "enthalpy"            , false)
mkBasAmt(:g_amt, :BProperty, :g_, :𝗴 , "G" , u"kJ"  , "kJ"  , "Gibbs energy"        , false)
mkBasAmt(:a_amt, :BProperty, :a_, :𝗮 , "A" , u"kJ"  , "kJ"  , "Helmholtz energy"    , false)
mkBasAmt(:e_amt, :BProperty, :e_, :𝗲 , "E" , u"kJ"  , "kJ"  , "total energy"        , false)
mkBasAmt(:ekamt, :BProperty, :ek, :𝗲𝗸, "Ek", u"kJ"  , "kJ"  , "kinetic energy"      , false)
mkBasAmt(:epamt, :BProperty, :ep, :𝗲𝗽, "Ep", u"kJ"  , "kJ"  , "potential energy"    , false)
mkBasAmt(:s_amt, :BProperty, :s_, :𝘀 , "S" , u"kJ/K", "kJ/K", "entropy"             , false)
mkBasAmt(:cpamt, :BProperty, :cp, :𝗰𝗽, "Cp", u"kJ/K", "kJ/K", "iso-P specific heat" , false)
mkBasAmt(:cvamt, :BProperty, :cv, :𝗰𝘃, "Cv", u"kJ/K", "kJ/K", "iso-v specific heat" , false)
mkBasAmt(:c_amt, :BProperty, :c_, :𝗰 , "C" , u"kJ/K", "kJ/K", "incompressible substance specific heat", false)
mkBasAmt(:j_amt, :BProperty, :j_, :𝗷 , "J" , u"kJ/K", "kJ/K", "Massieu function"    , false)
mkBasAmt(:y_amt, :BProperty, :y_, :𝘆 , "Y" , u"kJ/K", "kJ/K", "Planck function"     , false)
mkBasAmt(:xiamt, :BProperty, :xi, :𝝽 , "Ξ" , u"kJ"  , "kJ"  , "closed sys. exergy"  , false)
mkBasAmt(:dxamt, :BProperty, :dx, :𝝙𝝽, "Ξ" , u"kJ"  , "kJ"  , "cs. exergy variation", true )
mkBasAmt(:psamt, :BProperty, :ps, :𝞇 , "Ψ" , u"kJ"  , "kJ"  , "open system exergy"  , false)
mkBasAmt(:dpamt, :BProperty, :dp, :𝝙𝞇, "Ψ" , u"kJ"  , "kJ"  , "os. exergy variation", true )

# Regular interactions
mkBasAmt(:q_amt, :BInteract, :q_, :𝗾 , "Q" , u"kJ"  , "kJ"  , "heat"                , false)
mkBasAmt(:w_amt, :BInteract, :w_, :𝘄 , "W" , u"kJ"  , "kJ"  , "work"                , false)
mkBasAmt(:deamt, :BInteract, :de, :𝝙𝗲, "E" , u"kJ"  , "kJ"  , "energy variation"    , true )
mkBasAmt(:dsamt, :BInteract, :ds, :𝝙𝘀, "S" , u"kJ/K", "kJ/K", "entropy variation"   , true )
mkBasAmt(:i_amt, :BInteract, :i_, :𝗶 , "I" , u"kJ"  , "kJ"  , "irreversibility"     , false)


#----------------------------------------------------------------------------------------------#
#                                      AMOUNT Type Unions                                      #
#----------------------------------------------------------------------------------------------#

# Unions of amounts of like units and thermodynamic classification, for same-unit operations

# --- energy
"""
`ENERGYP{𝗽,𝘅,𝗯} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}`\n
Energy property type union.
"""
ENERGYP{𝗽,𝘅,𝗯} = Union{u_amt{𝗽,𝘅,𝗯},h_amt{𝗽,𝘅,𝗯},
                       g_amt{𝗽,𝘅,𝗯},a_amt{𝗽,𝘅,𝗯},
                       e_amt{𝗽,𝘅,𝗯},ekamt{𝗽,𝘅,𝗯},
                       epamt{𝗽,𝘅,𝗯},Pvamt{𝗽,𝘅,𝗯},
                       RTamt{𝗽,𝘅,𝗯},Tsamt{𝗽,𝘅,𝗯}} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}

"""
`ENERGYI{𝗽,𝘅,𝗯} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}`\n
Energy interaction type union.
"""
ENERGYI{𝗽,𝘅,𝗯} = Union{q_amt{𝗽,𝘅,𝗯},w_amt{𝗽,𝘅,𝗯},
                       deamt{𝗽,𝘅,𝗯}} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}

"""
`ENERGYA{𝗽,𝘅,𝗯} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}`\n
Energy amount type union.
"""
ENERGYA{𝗽,𝘅,𝗯} = Union{ENERGYP{𝗽,𝘅,𝗯},ENERGYI{𝗽,𝘅,𝗯}} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}


# --- entropy
"""
`NTROPYP{𝗽,𝘅,𝗯} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}`\n
Entropy property type union.
"""
NTROPYP{𝗽,𝘅,𝗯} = Union{R_amt{𝗽,𝘅,𝗯},y_amt{𝗽,𝘅,𝗯},s_amt{𝗽,𝘅,𝗯},
                       j_amt{𝗽,𝘅,𝗯},c_amt{𝗽,𝘅,𝗯},
                       cpamt{𝗽,𝘅,𝗯},cvamt{𝗽,𝘅,𝗯}} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}

"""
`NTROPYI{𝗽,𝘅,𝗯} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}`\n
Entropy interaction type union.
"""
NTROPYI{𝗽,𝘅,𝗯} = Union{dsamt{𝗽,𝘅,𝗯}} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}

"""
`NTROPYA{𝗽,𝘅,𝗯} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}`\n
Entropy amount type union.
"""
NTROPYA{𝗽,𝘅,𝗯} = Union{NTROPYP{𝗽,𝘅,𝗯},NTROPYI{𝗽,𝘅,𝗯}} where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE}


# --- velocity
"""
`VELOCYP{𝗽,𝘅} where {𝗽<:PREC,𝘅<:EXAC}`\n
Velocity property type union.
"""
VELOCYP{𝗽,𝘅} = Union{veamt{𝗽,𝘅},spamt{𝗽,𝘅},csamt{𝗽,𝘅}} where {𝗽<:PREC,𝘅<:EXAC}


# --- dimensionless
"""
`DIMLESS{𝗽,𝘅} where {𝗽<:PREC,𝘅<:EXAC}`\n
Dimensionless amount type union.
"""
DIMLESS{𝗽,𝘅} = Union{ø_amt{𝗽,𝘅}, Z_amt{𝗽,𝘅},    gaamt{𝗽,𝘅},
                     k_amt{𝗽,𝘅}, Maamt{𝗽,𝘅},    Pramt{𝗽,𝘅},
                     x_amt{𝗽,𝘅}, vramt{𝗽,𝘅}, m_amt{𝗽,𝘅,MA},
                     N_amt{𝗽,𝘅,MO}} where {𝗽<:PREC,𝘅<:EXAC}

# export
export ENERGYP, ENERGYI, ENERGYA
export NTROPYP, NTROPYI, NTROPYA
export VELOCYP
export DIMLESS


#----------------------------------------------------------------------------------------------#
#                                       Pretty Printing                                        #
#----------------------------------------------------------------------------------------------#

import Base: show

# Auxiliary methods
function subscript(x::Int)
    asSub(c::Char) = Char(Int(c) - Int('0') + Int('₀'))
    map(asSub, "$(x)")
end

using Printf

# Adapted from discourse.julialang.org/t/[...]
#    [...]/printf-significant-digits-in-floating-point-representation/29978/10,
# by @rafael.guerra
function _s_digits(x::AbstractFloat, sigdig::Unsigned)
    # Trivial cases
    (sigdig == 0x0) && (return "")
    (x == 0) && (return "0." * "0" ^ (sigdig - 1))
    # Normal processing
    x, sigdig = BigFloat(x), Int(sigdig)
    x = round(x, sigdigits=sigdig)
    n = length(@sprintf("%d", abs(x)))          # length of the integer part
    if (x ≤ -1 || x ≥ 1)
        decimals = max(sigdig - n, 0)           # 'sig - n' decimals needed 
    else
        Nzeros = ceil(Int, -log10(abs(x))) - 1  # No. zeros after dec point bef first number
        decimals = sigdig + Nzeros
    end
    return @sprintf("%.*f", decimals, x)
end

function valFmt(x::𝗽, sigD::Integer = DEF[:sigD]) where 𝗽<:PREC
    sigD = sigD < 0 ? abs(sigD) : sigD == 0 ? 1 : sigD
    return _s_digits(x, Unsigned(sigD))
end

# Precision decoration
pDeco(::Type{Float16})  = DEF[:prec] ? subscript(16) : ""
pDeco(::Type{Float32})  = DEF[:prec] ? subscript(32) : ""
pDeco(::Type{Float64})  = DEF[:prec] ? subscript(64) : ""
pDeco(::Type{BigFloat}) = DEF[:prec] ? subscript(precision(BigFloat)) : ""

# Custom printing
Base.show(io::IO, x::AMOUNTS{𝗽,EX}) where 𝗽<:PREC = begin
    if DEF[:pprint]
        print(io,
            "$(string(deco(x)))$(pDeco(𝗽)): ",
            valFmt(amt(x).val),
            ppu(x) == "" ? "" : " $(ppu(x))"
        )
    else
        print(io,
            "$(typeof(x))(",
            valFmt(amt(x).val),
            ppu(x) == "" ? ")" : " $(ppu(x)))"
        )
    end
end

Base.show(io::IO, x::AMOUNTS{𝗽,MM}) where 𝗽<:PREC = begin
    if DEF[:pprint]
        print(io,
            "$(string(deco(x)))$(pDeco(𝗽))∴ (",
            valFmt(amt(x).val.val),
            " ± ",
            valFmt(amt(x).val.err),
            ppu(x) == "" ? ")" : ") $(ppu(x))"
        )
    else
        print(io,
            "$(typeof(x))(",
            valFmt(amt(x).val.val),
            " ± ",
            valFmt(amt(x).val.err),
            ppu(x) == "" ? ")" : ") $(ppu(x))"
        )
    end
end


#  L5TYP  FINT    SY
#  ------------------
#  __amt    _a     _
#  T_amt    T_     T
#  P_amt    P_     P
#  veamt    ve     𝕍
#  spamt    sp     𝕧
#  t_amt    t_     t
#  gvamt    gv     𝒈
#  z_amt    z_     z
#  Z_amt    Z_     Z
#  gaamt    ga     γ
#  beamt    be     β
#  kTamt    kT    κT
#  ksamt    ks    κs
#  k_amt    k_     k
#  csamt    cs    cs
#  Maamt    Ma    Ma
#  mJamt    mJ    μJ
#  mSamt    mS    μS
#  x_amt    x_     x
#  Pramt    Pr    Pr
#  vramt    vr    vr
#  ø_amt    ø_     ø
#  m_amt    m_    **
#  N_amt    N_    **
#  R_amt    R_    **
#  Pvamt    Pv    Pv
#  RTamt    RT    **
#  Tsamt    Ts    Ts
#  v_amt    v_     v
#  u_amt    u_     u
#  h_amt    h_     h
#  g_amt    g_     g
#  a_amt    a_     a
#  e_amt    e_     e
#  ekamt    ek    ek
#  epamt    ep    ep
#  s_amt    s_     s
#  cpamt    cp    cp
#  cvamt    cv    cv
#  c_amt    c_     c
#  j_amt    j_     j
#  y_amt    y_     y
#  q_amt    q_     q
#  w_amt    w_     w
#  deamt    de    Δe
#  dsamt    ds    Δs

