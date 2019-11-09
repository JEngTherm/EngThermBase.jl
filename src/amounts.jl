#----------------------------------------------------------------------------------------------#
#                                           Imports                                            #
#----------------------------------------------------------------------------------------------#

import Unicode: normalize


#----------------------------------------------------------------------------------------------#
#                                    Amount Type Interface                                     #
#----------------------------------------------------------------------------------------------#

"""
`function deco end`\n
Interface to return a unique decorative `Symbol` from a method's argument type.
"""
function deco end

export deco


#----------------------------------------------------------------------------------------------#
#                                    Amount Type Factories                                     #
#----------------------------------------------------------------------------------------------#

"""
Based Amount type factory.
"""
function mkBasAmt(PREF::Symbol,         # Lowercase Prefix:     :u
                  SUPT::Symbol,         # Supertype:            :BProperty
                  SYMB::AbstractString, # Printing symbol:      "U"
                  UNIT::Unitful.Units,  # SY quantity units:    u"kJ"
                  WHAT::AbstractString, # Description:          "internal energy"
                  DELT::Bool=false;     # Whether a Δ quantity
                  bsym::NTuple{4,Symbol}=(:none,:none,:none,:none)
                 )
    # Constants
    TYPE = Symbol(string(PREF) * "Amt")
    𝑢SY = UNIT
    𝑢DT = UNIT / u"s"
    𝑢MA = UNIT / u"kg"
    𝑢MO = UNIT / u"kmol"
    𝑑SY = dimension(𝑢SY)
    𝑑DT = dimension(𝑢DT)
    𝑑MA = dimension(𝑢MA)
    𝑑MO = dimension(𝑢MO)
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
Precision-, Exactness-, and Base- parametric $WHAT amounts based in $UNIT.\n
`$TYPE{𝗽,𝘅,𝗯}` parameters are:\n
- Precision `𝗽<:Union{Float16,Float32,Float64,BigFloat}`;\n
- Exactness `𝘅<:Union{EX,MM}`, i.e., either a single, precise value or an uncertainty-bearing
  measurement, respectively;\n
- Thermodynamic base `𝗯<:Union{SY,DT,MA,MO}` respectively for system, rate, mass, or molar
  quantities, respectively in units of $(𝑢SY), $(𝑢DT), $(𝑢MA), or $(𝑢MO).\n
A `$TYPE` can be natively constructed from the following argument types:\n
- A plain, unitless float;\n
- A plain, unitless `Measurement`; hence, any `AbstractFloat`;\n
- A `Quantity{AbstractFloat}` with compatible units.\n
Constructors determine parameters from their arguments. `Quantity` constructors do not need a
base argument. Plain, `AbstractFloat` ones require the base argument.\n
## Hierarchy\n
`$(TYPE) <: $(hiStr)`
    """
    # @eval block
    @eval begin
        # Concrete type definition
        struct $TYPE{𝗽,𝘅,𝗯} <: $SUPT{𝗽,𝘅,𝗯}
            amt::Union{UATY{𝗽,$𝑑SY},UATY{𝗽,$𝑑DT},UATY{𝗽,$𝑑MA},UATY{𝗽,$𝑑MO}} where 𝗽<:PREC
            # Copy constructor
            $TYPE(x::$TYPE{𝗽,𝘅,𝗯}) where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} = new{𝗽,𝘅,𝗯}(x.amt)
            # Plain constructors enforce default units & avoid unit conversion
            # Plain Exact (𝗽<:PREC) float constructors
            $TYPE(x::𝗽, ::Type{SY}) where 𝗽<:PREC = new{𝗽,EX,SY}(x * $𝑢SY)
            $TYPE(x::𝗽, ::Type{DT}) where 𝗽<:PREC = new{𝗽,EX,DT}(x * $𝑢DT)
            $TYPE(x::𝗽, ::Type{MA}) where 𝗽<:PREC = new{𝗽,EX,MA}(x * $𝑢MA)
            $TYPE(x::𝗽, ::Type{MO}) where 𝗽<:PREC = new{𝗽,EX,MO}(x * $𝑢MO)
            # Plain Measurement (PMTY) constructors
            $TYPE(x::PMTY{𝗽}, ::Type{SY}) where 𝗽<:PREC = new{𝗽,MM,SY}(x * $𝑢SY)
            $TYPE(x::PMTY{𝗽}, ::Type{DT}) where 𝗽<:PREC = new{𝗽,MM,DT}(x * $𝑢DT)
            $TYPE(x::PMTY{𝗽}, ::Type{MA}) where 𝗽<:PREC = new{𝗽,MM,MA}(x * $𝑢MA)
            $TYPE(x::PMTY{𝗽}, ::Type{MO}) where 𝗽<:PREC = new{𝗽,MM,MO}(x * $𝑢MO)
            # Quantity constructors have to perform unit conversion despite matching dimensions
            # United Exact (UETY) constructors
            $TYPE(x::UETY{𝗽,$𝑑SY}) where 𝗽<:PREC = new{𝗽,EX,SY}(uconvert($𝑢SY, x))
            $TYPE(x::UETY{𝗽,$𝑑DT}) where 𝗽<:PREC = new{𝗽,EX,DT}(uconvert($𝑢DT, x))
            $TYPE(x::UETY{𝗽,$𝑑MA}) where 𝗽<:PREC = new{𝗽,EX,MA}(uconvert($𝑢MA, x))
            $TYPE(x::UETY{𝗽,$𝑑MO}) where 𝗽<:PREC = new{𝗽,EX,MO}(uconvert($𝑢MO, x))
            # United Measurement (UMTY) constructors
            $TYPE(x::UMTY{𝗽,$𝑑SY}) where 𝗽<:PREC = new{𝗽,MM,SY}(uconvert($𝑢SY, x))
            $TYPE(x::UMTY{𝗽,$𝑑DT}) where 𝗽<:PREC = new{𝗽,MM,DT}(uconvert($𝑢DT, x))
            $TYPE(x::UMTY{𝗽,$𝑑MA}) where 𝗽<:PREC = new{𝗽,MM,MA}(uconvert($𝑢MA, x))
            $TYPE(x::UMTY{𝗽,$𝑑MO}) where 𝗽<:PREC = new{𝗽,MM,MO}(uconvert($𝑢MO, x))
        end
        # Type documentation
        @doc $dcStr $TYPE
        # Precision-changing external constructors
        (::Type{$TYPE{𝘀}})(x::$TYPE{𝗽,EX,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(𝘀(x.amt.val), 𝗯)
        end
        (::Type{$TYPE{𝘀}})(x::$TYPE{𝗽,MM,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(Measurement{𝘀}(x.amt.val), 𝗯)
        end
        # Precision+Exactness-changing external constructors
        (::Type{$TYPE{𝘀,EX}})(x::$TYPE{𝗽,EX,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(𝘀(x.amt.val), 𝗯)
        end
        (::Type{$TYPE{𝘀,EX}})(x::$TYPE{𝗽,MM,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(𝘀(x.amt.val.val), 𝗯)
        end
        (::Type{$TYPE{𝘀,MM}})(x::$TYPE{𝗽,EX,𝗯},
                            e::𝘀=𝘀(max(eps(𝘀),eps(x.amt.val)))
                            ) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(measurement(𝘀(x.amt.val), e), 𝗯)
        end
        (::Type{$TYPE{𝘀,MM}})(x::$TYPE{𝗽,MM,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝗯<:BASE} = begin
            $TYPE(MEAS{𝘀}(x.amt.val), 𝗯)
        end
        # Type export
        export $TYPE
        # Type-specific functions
        deco(x::$TYPE{𝗽,𝘅,SY} where {𝗽,𝘅}) = Symbol($𝑠SY)
        deco(x::$TYPE{𝗽,𝘅,DT} where {𝗽,𝘅}) = Symbol($𝑠DT)
        deco(x::$TYPE{𝗽,𝘅,MA} where {𝗽,𝘅}) = Symbol($𝑠MA)
        deco(x::$TYPE{𝗽,𝘅,MO} where {𝗽,𝘅}) = Symbol($𝑠MO)
        # Indirect construction from plain
        $PREF(x::plnF, b::Type{𝗯}=DEF[:IB]) where 𝗯<:BASE = $TYPE(x, b)
        $PREF(x::plnR, b::Type{𝗯}=DEF[:IB]) where 𝗯<:BASE = $TYPE(float(x), b)
        # Indirect construction from quantity
        $PREF(x::Union{UATY{𝗽,$𝑑SY},UATY{𝗽,$𝑑DT},
                       UATY{𝗽,$𝑑MA},UATY{𝗽,$𝑑MO}}) where 𝗽<:PREC = begin
            $TYPE(x)
        end
        $PREF(x::Union{uniR{𝗽,$𝑑SY},uniR{𝗽,$𝑑DT},
                       uniR{𝗽,$𝑑MA},uniR{𝗽,$𝑑MO}}) where 𝗽<:REAL = begin
            $TYPE(float(x.val) * unit(x))
        end
        export $PREF
##         # Conversions
##         convert(::Type{$TYPE{𝘁}}, y::$TYPE{𝘁}) where 𝘁 = y
##         convert(::Type{$TYPE{𝘅}}, y::$TYPE{𝘆}) where {𝘅,𝘆} = $TYPE{𝘅}(y)
##         # Promotion rules: same-type: for +, -; other-type: for SCALAR *, /
##         promote_rule(::Type{$TYPE{𝘀}}, ::Type{$TYPE{𝘁}}) where {𝘀,𝘁} = $TYPE{promote_type(𝘀, 𝘁)}
    end
end

#----------------------------------------------------------------------------------------------#
#                           Thermodynamic Amount Group Declarations                            #
#----------------------------------------------------------------------------------------------#

# Mass / Mass fraction anomalous
mkBasAmt(:m , :BProperty, "m"   , u"kg"     , "mass"                , false ,
         bsym=(:m, :ṁ, :mf, :M))

# Chemical amount / Molar fraction anomalous
mkBasAmt(:N , :BProperty, "N"   , u"kmol"   , "chemical amount"     , false ,
         bsym=(:N, :Ṅ, :n, :y))

# Gas constant / System constant anomalous
mkBasAmt(:R , :BProperty, "R"   , u"kJ/K"   , "gas constant"        , false ,
         bsym=(:mR, :ṁR, :R, :R̄))

# Regular properties
mkBasAmt(:u , :BProperty, "U"   , u"kJ"     , "internal energy"     , false )
mkBasAmt(:h , :BProperty, "H"   , u"kJ"     , "enthalpy"            , false )
mkBasAmt(:g , :BProperty, "G"   , u"kJ"     , "Gibbs energy"        , false )
mkBasAmt(:a , :BProperty, "A"   , u"kJ"     , "Helmholtz energy"    , false )
mkBasAmt(:e , :BProperty, "E"   , u"kJ"     , "total energy"        , false )
mkBasAmt(:ek, :BProperty, "Ek"  , u"kJ"     , "kinetic energy"      , false )
mkBasAmt(:ep, :BProperty, "Ep"  , u"kJ"     , "potential energy"    , false )
mkBasAmt(:s , :BProperty, "S"   , u"kJ/K"   , "entropy"             , false )
mkBasAmt(:cp, :BProperty, "Cp"  , u"kJ/K"   , "iso-P specific heat" , false )
mkBasAmt(:cv, :BProperty, "Cv"  , u"kJ/K"   , "iso-v specific heat" , false )

# Regular interactions
mkBasAmt(:q , :BInteract, "Q"   , u"kJ"     , "heat"                , false )
mkBasAmt(:w , :BInteract, "W"   , u"kJ"     , "work"                , false )
mkBasAmt(:Δe, :BInteract, "E"   , u"kJ"     , "energy variation"    , true  )
mkBasAmt(:Δs, :BInteract, "S"   , u"kJ/K"   , "entropy variation"   , true  )


## #----------------------------------------------------------------------------------------------#
## #                                Concrete Amount Type Factories                                #
## #----------------------------------------------------------------------------------------------#
## 
## import Base: promote_rule, convert
## import Base: +, -, *, /
## 
## "Generic amount type making factory"
## function mkGenAmtTy(TYPE::Symbol, SUPT::Symbol, NAME::AbstractString,
##                     SYMB::AbstractString, STRM::Symbol)
##     name = uppercasefirst(string(NAME))
##     hiStr = tyArchy(eval(SUPT))
##     dcStr = """
## `struct $TYPE{𝘁<:AbstractFloat} <: $SUPT{𝘁}`\n
## $name with mandatory but flexible units as an `AbstractFloat` subtype.\n
## ## Hierarchy\n
## `$(TYPE) <: $(hiStr)`
##     """
##     strMacroNam = Symbol(string(STRM, "_str"))
##     strMacroExp = Symbol(string("@", STRM, "_str"))
##     @eval begin
##         # Concrete type definition
##         struct $TYPE{𝘁<:AbstractFloat} <: $SUPT{𝘁}
##             val::Quantity{𝘁,𝗱,𝘂} where {𝘁,𝗱,𝘂}
##             # Inner constructors
##             $TYPE(x::$TYPE{𝘅}) where 𝘅 = new{𝘅}(x.val)
##             $TYPE(x::Quantity{𝘅,𝘆,𝘇}) where {𝘅,𝘆,𝘇} =
##                 new{𝘅<:Complex ? float(𝘅.parameters[1]) : float(𝘅)}(float(real(x)))
##         end
##         # Outer constructors
##         $TYPE(x::Number) = float(real(x))
##         # The previous line is an instance of a "very rare case" mentioned here:
##         # https://docs.julialang.org/en/v1/manual/conversion-and-promotion/#Constructors-that-don't-return-instances-of-their-own-type-1
##         $TYPE(x::AbstractAmount) = $TYPE(x.val)
##         # Explicit parameter constructors
##         (::Type{$TYPE{𝘅}})(y::$TYPE{𝘆}) where {𝘅,𝘆} = $TYPE(𝘅(y.val.val))
##         (::Type{$TYPE{𝘅}})(y::Quantity) where 𝘅 = $TYPE(Quantity(𝘅(y.val) * unit(y)))
##         (::Type{$TYPE{𝘅}})(y::AbstractAmount{𝘆}) where {𝘅,𝘆} = $TYPE{𝘅}(y.val)  # falls back
##         # Type documentation
##         @doc $dcStr $TYPE
##         # Type export
##         export $TYPE
##         # Type-specific functions
##         deco(x::$TYPE) = Symbol($SYMB)
##         # String macro
##         macro $strMacroNam(x)
##             # Maybe use regexp, or have a separate parse function?
##             if x[1] in "hsdb"
##                 if      x[1] == 'h'; $TYPE(Float16(Meta.parse(x[2:end])))   # 𝗵alf-precision
##                 elseif  x[1] == 's'; $TYPE(Float32(Meta.parse(x[2:end])))   # 𝘀ingle-precision
##                 elseif  x[1] == 'd'; $TYPE(Float64(Meta.parse(x[2:end])))   # 𝗱ouble-precision
##                 else    x[1] == 'b'; $TYPE(BigFloat(x[2:end]))              # 𝗯ig precision
##                 end
##             else $TYPE(Meta.parse(x)); end
##         end
##         export $strMacroExp
##         # Conversions
##         convert(::Type{$TYPE{𝘁}}, y::$TYPE{𝘁}) where 𝘁 = y
##         convert(::Type{$TYPE{𝘅}}, y::$TYPE{𝘆}) where {𝘅,𝘆} = $TYPE{𝘅}(y)
##         # Promotion rules: same-type: for +, -; other-type: for SCALAR *, /
##         promote_rule(::Type{$TYPE{𝘀}}, ::Type{$TYPE{𝘁}}) where {𝘀,𝘁} = $TYPE{promote_type(𝘀, 𝘁)}
##         # SAME-TYPE, UNIT-PRESERVING operations: GEN a ± b -> GEN c with PRECISION promotion
##         +(x::$TYPE{𝘁}, y::$TYPE{𝘁}) where 𝘁 = ($TYPE{𝘁})(x.val + y.val)     # units checked by Unitful
##         +(x::$TYPE{𝘅}, y::$TYPE{𝘆}) where {𝘅,𝘆} = +(promote(x, y)...)   # "safe" or "unsurprising" to `convert()`
##         -(x::$TYPE{𝘁}, y::$TYPE{𝘁}) where 𝘁 = ($TYPE{𝘁})(x.val - y.val)
##         -(x::$TYPE{𝘅}, y::$TYPE{𝘆}) where {𝘅,𝘆} = -(promote(x, y)...)   # "safe" or "unsurprising" to `convert()`
##         # SCALAR, UNIT-PRESERVING (mul, div) with PRECISION promotion
##         # Dimensionless scalars (apples) cannot be "promoted" to $TYPE (oranges)
##         *(x::$TYPE{𝘁}, y::𝘁) where 𝘁 = ($TYPE{𝘁})(x.val * y)
##         *(x::$TYPE{𝘅}, y::𝘆) where {𝘅,𝘆<:Number} = $TYPE(x.val * real(y))
##         /(x::$TYPE{𝘁}, y::𝘁) where 𝘁 = ($TYPE{𝘁})(x.val / y)
##         /(x::$TYPE{𝘅}, y::𝘆) where {𝘅,𝘆<:Number} = $TYPE(x.val / real(y))
##         *(y::Number, x::$TYPE) = x * y  # falls back
##     end
## end
## 
## "Fixed unit amount type making factory"
## function mkUniAmtTy(TYPE::Symbol, SUPT::Symbol, UNIT::Unitful.Units,
##                     NAME::AbstractString, SYMB::AbstractString,
##                     STRM::Symbol)
##     name = uppercasefirst(string(NAME))
##     hiStr = tyArchy(eval(SUPT))
##     dcStr = """
## `struct $TYPE{𝘁<:AbstractFloat} <: $SUPT{𝘁}`\n
## $name in $UNIT.\n
## A `$TYPE` is constructed in many ways, the  most  general  one  being that from a `Number`
## argument. Constructor conventions ensure that:\n
## - Units are always of $UNIT (proper unit conversions are done, if needed);
## - Accepts unitless arguments (that are taken as in $UNIT).\n
## ## Hierarchy\n
## `$(TYPE) <: $(hiStr)`
##     """
##     strMacroNam = Symbol(string(STRM, "_str"))
##     strMacroExp = Symbol(string("@", STRM, "_str"))
##     @eval begin
##         # Concrete type definition
##         struct $TYPE{𝘁<:AbstractFloat} <: $SUPT{𝘁}
##             val::Quantity{𝘁,𝗱,𝘂} where {𝘁,𝗱,𝘂}
##             # Inner constructors
##             $TYPE(x::$TYPE{𝘅}) where 𝘅 = new{𝘅}(x.val)
##             $TYPE(x::AbstractFloat) = new{typeof(x)}(x * $UNIT)
##             $TYPE(x::Quantity{𝘅,𝘆,𝘇}) where {𝘅,𝘆,𝘇} =
##                 new{𝘅<:Complex ? float(𝘅.parameters[1]) : float(𝘅)}(uconvert($UNIT, float(real(x))))
##         end
##         # Outer constructors
##         $TYPE(x::Number) = $TYPE(float(real(x)))
##         $TYPE(x::AbstractAmount) = $TYPE(x.val)
##         # Explicit parameter constructors
##         (::Type{$TYPE{𝘅}})(y::$TYPE{𝘆}) where {𝘅,𝘆} = $TYPE(𝘅(y.val.val))
##         (::Type{$TYPE{𝘅}})(y::Quantity) where 𝘅 = $TYPE(Quantity(𝘅(y.val) * unit(y)))
##         (::Type{$TYPE{𝘅}})(y::Number) where 𝘅 = $TYPE(𝘅(y))
##         (::Type{$TYPE{𝘅}})(y::AbstractAmount{𝘆}) where {𝘅,𝘆} = $TYPE{𝘅}(y.val)  # falls back
##         # Type documentation
##         @doc $dcStr $TYPE
##         # Type export
##         export $TYPE
##         # Type-specific functions
##         deco(x::$TYPE) = Symbol($SYMB)
##         # String macro
##         macro $strMacroNam(x)
##             # Maybe use regexp, or have a separate parse function?
##             if x[1] in "hsdb"
##                 if      x[1] == 'h'; $TYPE(Float16(Meta.parse(x[2:end])))   # 𝗵alf-precision
##                 elseif  x[1] == 's'; $TYPE(Float32(Meta.parse(x[2:end])))   # 𝘀ingle-precision
##                 elseif  x[1] == 'd'; $TYPE(Float64(Meta.parse(x[2:end])))   # 𝗱ouble-precision
##                 else    x[1] == 'b'; $TYPE(BigFloat(x[2:end]))              # 𝗯ig precision
##                 end
##             else $TYPE(Meta.parse(x)); end
##         end
##         export $strMacroExp
##         # Conversions
##         convert(::Type{$TYPE{𝘁}}, y::$TYPE{𝘁}) where 𝘁 = y
##         convert(::Type{$TYPE{𝘅}}, y::$TYPE{𝘆}) where {𝘅,𝘆} = $TYPE{𝘅}(y)
##         # Promotion rules: same-type: for +, -; other-type: for SCALAR *, /
##         promote_rule(::Type{$TYPE{𝘀}}, ::Type{$TYPE{𝘁}}) where {𝘀,𝘁} = $TYPE{promote_type(𝘀, 𝘁)}
##         # SAME-TYPE, UNIT-PRESERVING sums: TYP a + b -> TYP c, with PRECISION promotion
##         # Balance hypothesis: TYP a - b -> OTHER c, therefore `-` operations are left out
##         +(x::$TYPE{𝘁}, y::$TYPE{𝘁}) where 𝘁 = begin
##             sign(x) < 0 ? (sign(y) < 0 ? -((-x) + (-y)) : y - (-x)) :
##                           (sign(y) < 0 ?      x - (-y)  : ($TYPE{𝘁})(x.val + y.val))
##         end
##         +(x::$TYPE{𝘅}, y::$TYPE{𝘆}) where {𝘅,𝘆} = +(promote(x, y)...)   # "safe" or "unsurprising" to `convert()`
##         # SCALAR, UNIT-PRESERVING (mul, div) with PRECISION promotion
##         # Dimensionless scalars (apples) cannot be "promoted" to $TYPE (oranges)
##         *(x::$TYPE{𝘁}, y::𝘁) where 𝘁 = ($TYPE{𝘁})(x.val * y)
##         *(x::$TYPE{𝘅}, y::𝘆) where {𝘅,𝘆<:Number} = $TYPE(x.val * real(y))
##         /(x::$TYPE{𝘁}, y::𝘁) where 𝘁 = ($TYPE{𝘁})(x.val / y)
##         /(x::$TYPE{𝘅}, y::𝘆) where {𝘅,𝘆<:Number} = $TYPE(x.val / real(y))
##         *(y::Number, x::$TYPE) = x * y  # falls back
##     end
## end
## 
## import Unicode: normalize
## 
## "Fixed unit amount type family making factory, based on the extensive type."
## function mkExtAmtTyFam(SUFF::Symbol,            # Type name suffix         : :_U
##                        UNIT::Unitful.Units,     # Default physical unit    : u"kJ"
##                        NAME::AbstractString,    # Documentation name       : "internal energy"
##                        PROP::Bool = true)       # Whether a property
##     typr = ("system", "perMass", "perMole", "perVolu", "rateOf")
##     suff = string(SUFF)
##     type = Tuple(p*suff for p in typr)
##     TYPE = Tuple(Symbol(i) for i in type)
##     bare = strip(suff, ['_'])
##     mass = normalize(lowercase(bare))
##     molr = normalize(string(mass[1], "\u0304", mass[2:end])) # Combining bar:    U+304
##     volu = normalize(string(mass[1], "\u030C", mass[2:end])) # Combining caron:  U+30C
##     rate = normalize(string(bare[1], "\u0307", bare[2:end])) # Combining dot:    U+307
##     FUNC = Symbol(mass)
##     # Make extensive type
##     mkUniAmtTy(TYPE[1],
##                PROP ? :systemProperty : :systemInteraction,
##                UNIT, NAME, bare, Symbol(bare))
##     # Make intensive types
##     mkUniAmtTy(TYPE[2],
##                PROP ? :perMassProperty : :perMassInteraction,
##                UNIT / u"kg",
##                "specific (per mass) " * NAME,
##                mass, Symbol(mass * "MA"))
##     mkUniAmtTy(TYPE[3],
##                PROP ? :perMoleProperty : :perMoleInteraction,
##                UNIT / u"kmol",
##                "specific (per kmol) " * NAME,
##                molr, Symbol(mass * "MO"))
##     mkUniAmtTy(TYPE[4],
##                PROP ? :perVoluProperty : :perVoluInteraction,
##                UNIT / u"m^3",
##                "specific (per volume) " * NAME,
##                volu, Symbol(mass * "VO"))
##     # Make rate type
##     mkUniAmtTy(TYPE[5],
##                PROP ? :perTimeProperty : :perTimeInteraction,
##                UNIT / u"s",
##                "rate of " * NAME,
##                rate, Symbol(bare * "dot"))
##     # Package user interface functions
##     @eval begin
##         $FUNC(x::Union{Number,AbstractAmount}, ::Type{SY}) = $(TYPE[1])(x)
##         $FUNC(x::Union{Number,AbstractAmount}, ::Type{MA}) = $(TYPE[2])(x)
##         $FUNC(x::Union{Number,AbstractAmount}, ::Type{MO}) = $(TYPE[3])(x)
##         $FUNC(x::Union{Number,AbstractAmount}, ::Type{VO}) = $(TYPE[4])(x)
##         $FUNC(x::Union{Number,AbstractAmount}, ::Type{XD}) = $(TYPE[5])(x)
##         $FUNC(x::Union{Number,AbstractAmount}) = $FUNC(x, DEF[:DB])
##     end
##     # Declare conversion methods
##     @eval begin
##         extType(::Union{Type{$(TYPE[1]){𝘁}},
##                         Type{$(TYPE[2]){𝘁}},
##                         Type{$(TYPE[3]){𝘁}},
##                         Type{$(TYPE[4]){𝘁}}}) where 𝘁 = $(TYPE[1]){𝘁}
##         intType(::Union{Type{$(TYPE[1]){𝘁}},
##                         Type{$(TYPE[2]){𝘁}}}, ::Type{MA}) where 𝘁 = $(TYPE[2]){𝘁}
##         intType(::Union{Type{$(TYPE[1]){𝘁}},
##                         Type{$(TYPE[3]){𝘁}}}, ::Type{MO}) where 𝘁 = $(TYPE[3]){𝘁}
##         intType(::Union{Type{$(TYPE[1]){𝘁}},
##                         Type{$(TYPE[4]){𝘁}}}, ::Type{VO}) where 𝘁 = $(TYPE[4]){𝘁}
##         dotType(::Type{$(TYPE[1]){𝘁}}) where 𝘁 = $(TYPE[5]){𝘁}
##         durType(::Type{$(TYPE[5]){𝘁}}) where 𝘁 = $(TYPE[1]){𝘁}
##     end
## end
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                                  Concrete Type Definitions                                   #
## #----------------------------------------------------------------------------------------------#
## 
## # Fallback generic amount
## mkGenAmtTy(:genericAmount, :UnrankedAmount, "generic quantity", "?", :gen)
## 
## # Unranked amounts
## mkUniAmtTy(:Time    , :UnrankedAmount, u"s"    , "time"                   , "𝗍", :t) # 𝗍: U+1d5cd
## mkUniAmtTy(:Gravity , :UnrankedAmount, u"m/s^2", "acceleration of gravity", "𝗀", :g) # 𝗀: U+1d5c0
## mkUniAmtTy(:Altitude, :UnrankedAmount, u"km"   , "altitude"               , "𝗓", :z) # 𝗓: U+1d5d3
## 
## # Intrinsic amounts
## mkUniAmtTy(:system_P, :intrinsicProperty, u"kPa"     , "pressure"   , "P", :P)
## mkUniAmtTy(:system_T, :intrinsicProperty, u"K"       , "temperature", "T", :T)
## mkUniAmtTy(:sysVeloc, :intrinsicProperty, u"√(kJ/kg)", "velocity"   , "𝖵", :velo)   # 𝖵: U+1d5b5
## mkUniAmtTy(:sysSpeed, :intrinsicProperty, u"m/s"     , "speed"      , "𝗏", :spee)   # 𝗏: U+1d5cf
## # Special velocity/speed constructors
## sysSpeed(x::sysVeloc) = sysSpeed(x.val)
## sysVeloc(x::sysSpeed) = sysVeloc(x.val)
## 
## # Basal properties
## mkUniAmtTy(:system_m, :basalProperty, u"kg"  , "mass"           , "m", :m)
## mkUniAmtTy(:system_N, :basalProperty, u"kmol", "chemical amount", "N", :N)
## mkUniAmtTy(:system_V, :basalProperty, u"m^3" , "volume"         , "V", :V)
## 
## # Basal ratios
## mkUniAmtTy(:perMass_N, :basalRatio, u"kmol/kg" , "specific (per mass) chemical amount", "n" , :nMA)
## mkUniAmtTy(:perMass_V, :basalRatio, u"m^3/kg"  , "specific (per mass) volume"         , "v" , :vMA)
## mkUniAmtTy(:perMole_m, :basalRatio, u"kg/kmol" , "specific (per kmol) mass"           , "M" , :mMO)
## mkUniAmtTy(:perMole_V, :basalRatio, u"m^3/kmol", "specific (per kmol) volume"         , "v̄" , :vMO)
## mkUniAmtTy(:perVolu_m, :basalRatio, u"kg/m^3"  , "mass density"                       , "ρ" , :mVO)  # ρ: U+3c1
## mkUniAmtTy(:perVolu_N, :basalRatio, u"kmol/m^3", "molar density"                      , "ρ̄" , :nVO)  # ρ̄: U+3c1 U+304
## 
## BO(::Union{perMass_N,perMass_V}) = MA
## BO(::Union{perMole_m,perMole_V}) = MO
## BO(::Union{perVolu_m,perVolu_N}) = VO
## 
## # Basal rates
## mkUniAmtTy(:rateOf_m, :basalRate, u"kg/s"  , "rate of mass"           , "ṁ" , :mdot) # ṁ: U+1e41
## mkUniAmtTy(:rateOf_N, :basalRate, u"kmol/s", "rate of chemical amount", "Ṅ" , :Ndot) # Ṅ: U+1e44
## mkUniAmtTy(:rateOf_V, :basalRate, u"m^3/s" , "rate of volume"         , "V̇" , :Vdot) # V̇: V U+307
## 
## # Property FAMILIES based on an extensive property (with lowercase package user interface function definitions)
## mkExtAmtTyFam(:_U, u"kJ"  , "internal energy" , true) # U, u, ū, ǔ, u̇
## mkExtAmtTyFam(:_H, u"kJ"  , "enthalpy"        , true) # etc...
## mkExtAmtTyFam(:_S, u"kJ/K", "entropy"         , true)
## mkExtAmtTyFam(:_G, u"kJ"  , "Gibbs energy"    , true)
## mkExtAmtTyFam(:_A, u"kJ"  , "Helmholtz energy", true)
## mkExtAmtTyFam(:CP, u"kJ/K", "CP heat capacity", true)
## mkExtAmtTyFam(:CV, u"kJ/K", "CV heat capacity", true)
## mkExtAmtTyFam(:_R, u"kJ/K", "PV/T constant"   , true)
## mkExtAmtTyFam(:_E, u"kJ"  , "total energy"    , true)
## mkExtAmtTyFam(:EK, u"kJ"  , "kinetic energy"  , true)
## mkExtAmtTyFam(:EP, u"kJ"  , "potential energy", true)
## 
## # Interaction FAMILIES based on an extensive interaction (with lowercase package user interface function definitions)
## mkExtAmtTyFam(:_Q, u"kJ"  , "heat transfer to system"   , false) # Q, q, q̄, q̌, q̇
## mkExtAmtTyFam(:_W, u"kJ"  , "work transfer to system"   , false) # etc...
## mkExtAmtTyFam(:_J, u"kJ"  , "energy transfer to system" , false)
## mkExtAmtTyFam(:SQ, u"kJ/K", "entropy transfer to system", false)
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                                    Package User Interface                                    #
## #----------------------------------------------------------------------------------------------#
## 
## # EoS-independent properties
## M(x::Union{Number,AbstractAmount}) = perMole_m(x)
## hf°(x::Union{Number,AbstractAmount}, BA::ThermodynamicBase=DEF[:DB]) = j(x, BA)
## uf°(x::Union{Number,AbstractAmount}, BA::ThermodynamicBase=DEF[:DB]) = j(x, BA)
## # Specific heat temperature integrals
## Δu(x::Union{Number,AbstractAmount}, BA::ThermodynamicBase=DEF[:DB]) = j(x, BA)
## Δh(x::Union{Number,AbstractAmount}, BA::ThermodynamicBase=DEF[:DB]) = j(x, BA)
## Δs°(x::Union{Number,AbstractAmount}, BA::ThermodynamicBase=DEF[:DB]) = sq(x, BA)
## # Substance properties
## P(x::Union{Number,AbstractAmount}) = system_P(x)
## T(x::Union{Number,AbstractAmount}) = system_T(x)
## v(x::Union{Number,AbstractAmount}, ::Type{SY}) = system_V(x)
## v(x::Union{Number,AbstractAmount}, ::Type{MA}) = perMass_V(x)
## v(x::Union{Number,AbstractAmount}, ::Type{MO}) = perMole_V(x)
## v(x::Union{Number,AbstractAmount}, ::Type{XD}) = rateOf_V(x)
## v(x::Union{Number,AbstractAmount}, BA::matterBase=DEF[:DB]) = v(x, BA)
## rho(x::Union{Number,AbstractAmount}, BA::matterBase=DEF[:DB]) = one(x) / v(x, BA)
## Pv(x::Union{Number,AbstractAmount}, BA::matterBase=DEF[:DB]) = j(x, BA)
## # System properties
## m(x::Union{Number,AbstractAmount}, ::Type{SY}) = system_m(x)
## m(x::Union{Number,AbstractAmount}, ::Type{MO}) = perMole_m(x)
## m(x::Union{Number,AbstractAmount}, ::Type{VO}) = perVolu_m(x)
## m(x::Union{Number,AbstractAmount}, ::Type{XD}) = rateOf_m(x)
## m(x::Union{Number,AbstractAmount}) = m(x, SY)
## N(x::Union{Number,AbstractAmount}, ::Type{SY}) = system_N(x)
## N(x::Union{Number,AbstractAmount}, ::Type{MA}) = perMass_N(x)
## N(x::Union{Number,AbstractAmount}, ::Type{VO}) = perVolu_N(x)
## N(x::Union{Number,AbstractAmount}, ::Type{XD}) = rateOf_N(x)
## N(x::Union{Number,AbstractAmount}) = N(x, SY)
## V(x::Union{Number,AbstractAmount}, ::Type{SY}) = system_V(x)
## V(x::Union{Number,AbstractAmount}) = V(x, SY)
## V(x::Union{Number,AbstractAmount}, ::Type{XD}) = rateOf_V(x)
## PV(x::Union{Number,AbstractAmount}, ::Type{SY}) = j(x, SY)
## PV(x::Union{Number,AbstractAmount}) = j(x, SY)
## PV(x::Union{Number,AbstractAmount}, ::Type{XD}) = j(x, XD)
## U(x::Union{Number,AbstractAmount}, ::Type{SY}) = u(x, SY)
## U(x::Union{Number,AbstractAmount}) = u(x, SY)
## U(x::Union{Number,AbstractAmount}, ::Type{XD}) = u(x, XD)
## H(x::Union{Number,AbstractAmount}, ::Type{SY}) = h(x, SY)
## H(x::Union{Number,AbstractAmount}) = h(x, SY)
## H(x::Union{Number,AbstractAmount}, ::Type{XD}) = h(x, XD)
## S(x::Union{Number,AbstractAmount}, ::Type{SY}) = s(x, SY)
## S(x::Union{Number,AbstractAmount}) = s(x, SY)
## S(x::Union{Number,AbstractAmount}, ::Type{XD}) = s(x, XD)
## G(x::Union{Number,AbstractAmount}, ::Type{SY}) = g(x, SY)
## G(x::Union{Number,AbstractAmount}) = g(x, SY)
## G(x::Union{Number,AbstractAmount}, ::Type{XD}) = g(x, XD)
## A(x::Union{Number,AbstractAmount}, ::Type{SY}) = a(x, SY)
## A(x::Union{Number,AbstractAmount}) = a(x, SY)
## A(x::Union{Number,AbstractAmount}, ::Type{XD}) = a(x, XD)
## # Macroscopic properties
## EK(x::Union{Number,AbstractAmount}, ::Type{SY}) = ek(x, SY)
## EK(x::Union{Number,AbstractAmount}) = ek(x, SY)
## EK(x::Union{Number,AbstractAmount}, ::Type{XD}) = ek(x, XD)
## EP(x::Union{Number,AbstractAmount}, ::Type{SY}) = ep(x, SY)
## EP(x::Union{Number,AbstractAmount}) = ep(x, SY)
## EP(x::Union{Number,AbstractAmount}, ::Type{XD}) = ep(x, XD)
## # Total properties
## theta(x::Union{Number,AbstractAmount}, BA::ThermodynamicBase=DEF[:DB]) = j(x, BA)
## E(x::Union{Number,AbstractAmount}, ::Type{SY}) = e(x, SY)
## E(x::Union{Number,AbstractAmount}) = e(x, SY)
## E(x::Union{Number,AbstractAmount}, ::Type{XD}) = e(x, XD)
## Theta(x::Union{Number,AbstractAmount}, ::Type{SY}) = j(x, SY)
## Theta(x::Union{Number,AbstractAmount}) = j(x, SY)
## Theta(x::Union{Number,AbstractAmount}, ::Type{XD}) = j(x, XD)
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                               SAME-FAMILY Products and Ratios                                #
## #----------------------------------------------------------------------------------------------#
## 
## # import Base: *, / # already imported
## 
## *(x::perMassQuantity, y::system_m) = extType(typeof(x))(x.val * y.val)
## *(x::perMoleQuantity, y::system_N) = extType(typeof(x))(x.val * y.val)
## *(x::perVoluQuantity, y::system_V) = extType(typeof(x))(x.val * y.val)
## *(x::perTimeQuantity, y::Time    ) = durType(typeof(x))(x.val * y.val)
## 
## *(x::system_m, y::perMassQuantity) = y * x
## *(x::system_N, y::perMoleQuantity) = y * x
## *(x::system_V, y::perVoluQuantity) = y * x
## *(x::Time    , y::perTimeQuantity) = y * x
## 
## /(x::systemQuantity, y::system_m) = intType(typeof(x), MA)(x.val / y.val)
## /(x::systemQuantity, y::system_N) = intType(typeof(x), MO)(x.val / y.val)
## /(x::systemQuantity, y::system_V) = intType(typeof(x), VO)(x.val / y.val)
## /(x::systemQuantity, y::Time    ) = dotType(typeof(x))(x.val / y.val)
## 
## *(x::perMassQuantity, y::perMole_m) = intType(extType(typeof(x)), MO)(x.val * y.val)
## *(x::perMassQuantity, y::perVolu_m) = intType(extType(typeof(x)), VO)(x.val * y.val)
## *(x::perMassQuantity, y::rateOf_m)  = dotType(extType(typeof(x)))(x.val * y.val)
## *(x::perMoleQuantity, y::perMass_N) = intType(extType(typeof(x)), MA)(x.val * y.val)
## *(x::perMoleQuantity, y::perVolu_N) = intType(extType(typeof(x)), VO)(x.val * y.val)
## *(x::perMoleQuantity, y::rateOf_N)  = dotType(extType(typeof(x)))(x.val * y.val)
## *(x::perVoluQuantity, y::perMass_V) = intType(extType(typeof(x)), MA)(x.val * y.val)
## *(x::perVoluQuantity, y::perMole_V) = intType(extType(typeof(x)), MO)(x.val * y.val)
## *(x::perVoluQuantity, y::rateOf_V)  = dotType(extType(typeof(x)))(x.val * y.val)
## 
## *(x::perMole_m, y::perMassQuantity) = y * x
## *(x::perVolu_m, y::perMassQuantity) = y * x
## *(x::rateOf_m, y::perMassQuantity)  = y * x
## *(x::perMass_N, y::perMoleQuantity) = y * x
## *(x::perVolu_N, y::perMoleQuantity) = y * x
## *(x::rateOf_N, y::perMoleQuantity)  = y * x
## *(x::perMass_V, y::perVoluQuantity) = y * x
## *(x::perMole_V, y::perVoluQuantity) = y * x
## *(x::rateOf_V, y::perVoluQuantity)  = y * x
## 
## /(x::perMassQuantity, y::perMass_N) = intType(extType(typeof(x)), MO)(x.val / y.val)
## /(x::perMassQuantity, y::perMass_V) = intType(extType(typeof(x)), VO)(x.val / y.val)
## /(x::perMoleQuantity, y::perMole_m) = intType(extType(typeof(x)), MA)(x.val / y.val)
## /(x::perMoleQuantity, y::perMole_V) = intType(extType(typeof(x)), VO)(x.val / y.val)
## /(x::perVoluQuantity, y::perVolu_m) = intType(extType(typeof(x)), MA)(x.val / y.val)
## /(x::perVoluQuantity, y::perVolu_N) = intType(extType(typeof(x)), MO)(x.val / y.val)
## /(x::perTimeQuantity, y::rateOf_m)  = intType(durType(typeof(x)), MA)(x.val / y.val)
## /(x::perTimeQuantity, y::rateOf_N)  = intType(durType(typeof(x)), MO)(x.val / y.val)
## /(x::perTimeQuantity, y::rateOf_V)  = intType(durType(typeof(x)), VO)(x.val / y.val)
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                                    Unit-based conversions                                    #
## #----------------------------------------------------------------------------------------------#
## 
## """
## `function AMT(x::Number)`\n
## Tries to generate a valid `AbstractAmount` from `x`, based on its units. Quantities  derived  of
## energy, such as `kJ`, `kJ/kg`, `kJ/kmol`, `kJ/m^3`,  and  `kW` fallback  to  a  pertinent
## `system_J` (energy transfer to system) derived—the energy balance hypothesis. Quantities derived
## of  entropy,  such  as  `kJ/K,` `kJ/kg/K`, `kJ/kmol/K`, `kJ/m^3/K`, and `kW/K` fallback to a
## pertinent `systemSQ` (entropy transfer to system) derived—the entropy balance hypothesis. The
## ultimate fallback is `genericAmount`. The eltype-undecorated `Quantity` constructors are evoked,
## so that the resulting type precision is taken from the `x` argument. This function is
## extensively used in operations that result in a unit change.
## """
## function AMT(x::Number)
##     D = dimension(x)
##     if      D == dimension(1);              float(real(x))
##     elseif  D == dimension(u"s");           Time(x)
##     elseif  D == dimension(u"m");           Altitude(x)
##     elseif  D == dimension(u"m/s^2");       Gravity(x)
##     elseif  D == dimension(u"kPa");         system_P(x)
##     elseif  D == dimension(u"K");           system_T(x)
##     elseif  D == dimension(u"m/s");         sysVeloc(x)
##     elseif  D == dimension(u"kg");          system_m(x)
##     elseif  D == dimension(u"kmol");        system_N(x)
##     elseif  D == dimension(u"m^3");         system_V(x)
##     elseif  D == dimension(u"kJ");          system_J(x)     # energy balance fallback
##     elseif  D == dimension(u"kJ/K");        systemSQ(x)     # ntropy balance fallback
##     elseif  D == dimension(u"kmol/kg");     perMass_N(x)
##     elseif  D == dimension(u"m^3/kg");      perMass_V(x)
##     elseif  D == dimension(u"kJ/kg");       perMass_J(x)    # energy balance fallback
##     elseif  D == dimension(u"kJ/kg/K");     perMassSQ(x)    # ntropy balance fallback
##     elseif  D == dimension(u"kg/kmol");     perMole_m(x)
##     elseif  D == dimension(u"m^3/kmol");    perMole_V(x)
##     elseif  D == dimension(u"kJ/kmol");     perMole_J(x)    # energy balance fallback
##     elseif  D == dimension(u"kJ/kmol/K");   perMoleSQ(x)    # ntropy balance fallback
##     elseif  D == dimension(u"kg/m^3");      perVolu_m(x)
##     elseif  D == dimension(u"kmol/m^3");    perVolu_N(x)
## ##  elseif  D == dimension(u"kJ/m^3");      system_P(x)     # same as u"kPa"
##     elseif  D == dimension(u"kJ/m^3/K");    perVoluSQ(x)    # ntropy balance fallback
##     elseif  D == dimension(u"kg/s");        rateOf_m(x)
##     elseif  D == dimension(u"kmol/s");      rateOf_N(x)
##     elseif  D == dimension(u"m^3/s");       rateOf_V(x)
##     elseif  D == dimension(u"kW");          rateOf_J(x)     # energy balance fallback
##     elseif  D == dimension(u"kW/K");        rateOfSQ(x)     # ntropy balance fallback
##     else                                    genericAmount(x)
##     end
## end
## 
## export AMT
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                                  Julia Base Specializations                                  #
## #----------------------------------------------------------------------------------------------#
## 
## import Base: inv
## 
## *(x::AbstractAmount, y::Quantity) = AMT(x.val * y)              # units, promotions: Unitful
## *(y::Quantity, x::AbstractAmount) = x * y                       # falls back
## /(x::AbstractAmount, y::Quantity) = AMT(x.val / y)              # units, promotions: Unitful
## /(y::Number,   x::AbstractAmount) = AMT(y / x.val)              # as Quantity <: Number
## 
## *(x::AbstractAmount, y::AbstractAmount) = AMT(x.val * y.val)    # units, promotions: Unitful
## /(x::AbstractAmount, y::AbstractAmount) = AMT(x.val / y.val)    # units, promotions: Unitful
## 
## inv(x::AbstractAmount) = 1.0 / x    # falls back
## 
## 
## #----------------------------------------------------------------------------------------------#
## # import Base: +, - # already imported
## 
## +(x::AbstractAmount) = x
## -(x::AbstractAmount) = typeof(x)(-x.val)
## 
## +(x::AbstractAmount, y::Number) = AMT(x.val + y)                # units, promotions: Unitful
## +(y::Number, x::AbstractAmount) = x + y     # falls back
## +(x::AbstractAmount, y::AbstractAmount) = AMT(x.val + y.val)    # factories: TYP(x) != TYP(y)
## 
## -(x::AbstractAmount, y::Number) = AMT(x.val - y)                # units, promotions: Unitful
## -(y::Number, x::AbstractAmount) = (-x) + y  # falls back
## 
## # Same-unit thermodynamic operations with automatic PRECISION promotion:
## # Property + Interaction --> Property (that's why Prop-Prop isn't a Property, in general)
## +(x::Property, y::Interaction) = typeof(x).name.wrapper(x.val + y.val)
## +(y::Interaction, x::Property) = x + y      # falls back
## # CP - R --> CV and variants
## -(x::systemCP, y::system_R) = systemCV(x.val - y.val)
## -(x::perMassCP, y::perMass_R) = perMassCV(x.val - y.val)
## -(x::perMoleCP, y::perMole_R) = perMoleCV(x.val - y.val)
## -(x::perVoluCP, y::perVolu_R) = perVoluCV(x.val - y.val)
## +(x::systemCP, y::system_R) = sign(y) < 0 ? x - (-y) : AMT(x.val + y.val)
## +(x::perMassCP, y::perMass_R) = sign(y) < 0 ? x - (-y) : AMT(x.val + y.val)
## +(x::perMoleCP, y::perMole_R) = sign(y) < 0 ? x - (-y) : AMT(x.val + y.val)
## +(x::perVoluCP, y::perVolu_R) = sign(y) < 0 ? x - (-y) : AMT(x.val + y.val)
## +(y::system_R, x::systemCP) = x + y     # falls back
## +(y::perMass_R, x::perMassCP) = x + y   # falls back
## +(y::perMole_R, x::perMoleCP) = x + y   # falls back
## +(y::perVolu_R, x::perVoluCP) = x + y   # falls back
## # CV + R --> CP and variants
## +(x::systemCV, y::system_R) = sign(y) < 0 ? x - (-y) : systemCP(x.val + y.val)
## +(x::perMassCV, y::perMass_R) = sign(y) < 0 ? x - (-y) : perMassCP(x.val + y.val)
## +(x::perMoleCV, y::perMole_R) = sign(y) < 0 ? x - (-y) : perMoleCP(x.val + y.val)
## +(x::perVoluCV, y::perVolu_R) = sign(y) < 0 ? x - (-y) : perVoluCP(x.val + y.val)
## +(y::system_R, x::systemCV) = x + y     # falls back
## +(y::perMass_R, x::perMassCV) = x + y   # falls back
## +(y::perMole_R, x::perMoleCV) = x + y   # falls back
## +(y::perVolu_R, x::perVoluCV) = x + y   # falls back
## 
## # Even if `x` and `y` below are of the exact same type, the generic fallback below is more
## # suitable for the operation, since in a property balance, the difference between two same
## # properties is either an interaction or the difference between two other properties. Moreover,
## # the `AMT` call can revert the result back to operand-type amount, if the resulting units
## # allow.
## -(x::AbstractAmount, y::AbstractAmount) = AMT(x.val - y.val)    # units, promotions: Unitful
## 
## 
## #----------------------------------------------------------------------------------------------#
## import Base: ^, sqrt, cbrt
## 
## ^(x::AbstractAmount, y::Real) = AMT(x.val ^ y)
## sqrt(x::AbstractAmount) = AMT(sqrt(x.val))
## cbrt(x::AbstractAmount) = AMT(cbrt(x.val))
## 
## 
## #----------------------------------------------------------------------------------------------#
## import Base: ==, >, <, isequal, isless, isapprox
## 
## ==(x::AbstractAmount{𝘅}, y::AbstractAmount{𝘆}) where {𝘅,𝘆} = begin
##     # (1<<3)*eps(...) means we don't care about the 3 least significant bits
##     isapprox(x.val, y.val, rtol=(1<<3)*eps(promote_type(𝘅, 𝘆)))
## end
## ==(x::AbstractAmount{𝘅}, y::Quantity{𝘆}) where {𝘅,𝘆<:Real} = begin
##     # (1<<3)*eps(...) means we don't care about the 3 least significant bits
##     isapprox(x.val, y.val, rtol=(1<<3)*eps(promote_type(𝘅, 𝘆)))
## end
## ==(y::Quantity{𝘆}, x::AbstractAmount{𝘅}) where {𝘅,𝘆<:Real} = ==(x, y)   # falls back
## 
## >(x::AbstractAmount, y::AbstractAmount) = x.val > y.val
## >(x::AbstractAmount, y::Quantity) = x.val > y
## >(y::Quantity, x::AbstractAmount) = y > x.val
## 
## <(x::AbstractAmount, y::AbstractAmount) = x.val < y.val
## <(x::AbstractAmount, y::Quantity) = x.val < y
## <(y::Quantity, x::AbstractAmount) = y < x.val
## 
## isequal(x::AbstractAmount, y::AbstractAmount) = isequal(x.val, y.val)
## isequal(x::AbstractAmount, y::Quantity) = isequal(x.val, y)
## isequal(y::Quantity, x::AbstractAmount) = isequal(y, x.val)
## 
## isless(x::AbstractAmount, y::AbstractAmount) = isless(x.val, y.val)
## isless(x::AbstractAmount, y::Quantity) = isless(x.val, y)
## isless(y::Quantity, x::AbstractAmount) = isless(y, x.val)
## 
## function isapprox(x::AbstractAmount{𝘅}, y::AbstractAmount{𝘆}; atol::Real=0,
##                   rtol::Real=rtoldefault(x,y,atol), nans::Bool=false) where {𝘅,𝘆}
##     isapprox(x.val, y.val, atol=atol, rtol=rtol, nans=nans)
## end
## 
## 
## #----------------------------------------------------------------------------------------------#
## import Base: real, abs, abs2, min, max
## 
## real(x::AbstractAmount) = x
## abs(x::𝘁) where 𝘁<:AbstractAmount = 𝘁(abs(x.val))
## abs2(x::AbstractAmount) = x^2
## 
## min(x::𝘁...) where 𝘁<:AbstractAmount = 𝘁(min((i.val for i in x)...))
## max(x::𝘁...) where 𝘁<:AbstractAmount = 𝘁(max((i.val for i in x)...))
## 
## 
## #----------------------------------------------------------------------------------------------#
## import Base: widen, eps, eltype
## 
## numtype(t::Type{𝘁}) where 𝘁<:AbstractAmount = t.parameters[1]
## numtype(x::AbstractAmount) = numtype(typeof(x))
## 
## numtype(t::Type{𝘁}) where 𝘁<:Number = begin
##     a = t; p = a.parameters; l = length(p)
##     while l > 0
##         i = 1; while i <= l && !(p[i]<:Number); i += 1; end
##         if i > l; return a
##         else a = p[i]; p = a.parameters; l = length(p); end
##     end; return a
## end
## numtype(x::Number) = numtype(typeof(x))
## 
## export numtype
## 
## widen(t::Type{𝘁}) where 𝘁<:AbstractAmount = @eval $(nameof(t)){widen(numtype($t))}
## widen(x::AbstractAmount) = widen(typeof(x))(x)
## 
## eps(x::AbstractAmount{𝘁}) where 𝘁 = typeof(x)(eps(𝘁))
## 
## eltype(::Type{𝘁}) where 𝘁<:AbstractAmount = @eval $(partype(𝘁))
## 
## 
## #----------------------------------------------------------------------------------------------e
## import Base: prevfloat, nextfloat, one, zero, typemin, typemax
## 
## prevfloat(x::AbstractAmount) = typeof(x)(prevfloat(x.val))
## nextfloat(x::AbstractAmount) = typeof(x)(nextfloat(x.val))
## 
## one(x::Type{𝘁}) where 𝘁<:AbstractAmount{𝘀} where 𝘀 = 𝘁(one(𝘀))
## one(x::AbstractAmount) = one(typeof(x))
## zero(x::Type{𝘁}) where 𝘁<:AbstractAmount{𝘀} where 𝘀 = 𝘁(zero(𝘀))
## zero(x::AbstractAmount) = zero(typeof(x))
## 
## typemin(x::Type{𝘁}) where 𝘁<:AbstractAmount{𝘀} where 𝘀 = 𝘁(typemin(𝘀))
## typemin(x::AbstractAmount) = typemin(typeof(x))
## typemax(x::Type{𝘁}) where 𝘁<:AbstractAmount{𝘀} where 𝘀 = 𝘁(typemax(𝘀))
## typemax(x::AbstractAmount) = typemax(typeof(x))
## 
## 
## #----------------------------------------------------------------------------------------------#
## import Base: floor, ceil, trunc, round, sign, signbit, copysign, flipsign
## 
## floor(x::AbstractAmount) = typeof(x)(floor(x.val))
## ceil(x::AbstractAmount) = typeof(x)(ceil(x.val))
## trunc(x::AbstractAmount) = typeof(x)(trunc(x.val))
## round(x::AbstractAmount) = typeof(x)(round(x.val))
## round(x::AbstractAmount, r::RoundingMode; digits, sigdigits, base) =
##     typeof(x)(round(x.val, r, digits=digits, sigdigits=sigdigits, base=base))
## 
## sign(x::AbstractAmount) = sign(x.val)
## signbit(x::AbstractAmount) = signbit(x.val)
## copysign(x::𝘁, Y::𝘁) where 𝘁<:Union{Number,AbstractAmount} = sign(y) < 0 ? -abs(x) : abs(x)
## flipsign(x::𝘁, Y::𝘁) where 𝘁<:Union{Number,AbstractAmount} = sign(y) < 0 ? -x : x
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                                    Specific constructors                                     #
## #----------------------------------------------------------------------------------------------#
## 
## Celerity = Union{sysVeloc,sysSpeed}
## 
## export Celerity
## 
## perMassEK(c::Celerity) = perMassEK(c*c/2)               # specific kinetic energy from speeds
## sysVeloc(k::perMassEK) = sysVeloc(√(2k))                # inverse
## sysSpeed(k::perMassEK) = sysSpeed(√(2k))                # inverse
## perMassEP(g::Gravity, z::Altitude) = perMassEP(g*z)     # specific potential energy from g,z
## perMassEP(z::Altitude, g::Gravity) = perMassEP(g*z)     # specific potential energy from g,z
## Altitude(g::Gravity, p::perMassEP) = Altitude(p/g)      # inverse
## Altitude(p::perMassEP, g::Gravity) = Altitude(p/g)      # inverse
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                                       Pretty Printing                                        #
## #----------------------------------------------------------------------------------------------#
## 
## # Custom printing
## Base.show(io::IO, a::AbstractAmount) = print(io, "$(string(deco(a))): $(a.val)")
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                                          Promotion                                           #
## #----------------------------------------------------------------------------------------------#
## 
## ## import Base: promote, promote_rule
## ## 
## ## promote_rule(x::Type{AbstractAmount{𝘀} where 𝘀},
## ##              y::Type{AbstractAmount{𝘁} where 𝘁}) = AbstractAmount{promote_type(𝘀, 𝘁)}
## ## 
## ## function promote(x::Vararg{AbstractAmount})
## ##     TYP = Tuple(typeof(i) for i in x)
## ##     VAL = promote(Tuple(i.val.val for i in x)...)
## ##     Tuple(T(V) for (T, V) in zip(TYP, VAL))
## ## end
## 
## 
## #----------------------------------------------------------------------------------------------#
## #                                       Property Unions                                        #
## #----------------------------------------------------------------------------------------------#
## 
## # Type union definitions for method interface
## 
## # Canonical intensive properties (excluding perVolu... ones)
## intensive_V{𝘁} = Union{perMass_V{𝘁}, perMole_V{𝘁}} where 𝘁<:AbstractFloat
## intensive_U{𝘁} = Union{perMass_U{𝘁}, perMole_U{𝘁}} where 𝘁<:AbstractFloat
## intensive_H{𝘁} = Union{perMass_H{𝘁}, perMole_H{𝘁}} where 𝘁<:AbstractFloat
## intensive_S{𝘁} = Union{perMass_S{𝘁}, perMole_S{𝘁}} where 𝘁<:AbstractFloat
## intensive_G{𝘁} = Union{perMass_G{𝘁}, perMole_G{𝘁}} where 𝘁<:AbstractFloat
## intensive_A{𝘁} = Union{perMass_A{𝘁}, perMole_A{𝘁}} where 𝘁<:AbstractFloat
## intensiveCP{𝘁} = Union{perMassCP{𝘁}, perMoleCP{𝘁}} where 𝘁<:AbstractFloat
## intensiveCV{𝘁} = Union{perMassCV{𝘁}, perMoleCV{𝘁}} where 𝘁<:AbstractFloat
## intensive_R{𝘁} = Union{perMass_R{𝘁}, perMole_R{𝘁}} where 𝘁<:AbstractFloat
## intensive_E{𝘁} = Union{perMass_E{𝘁}, perMole_E{𝘁}} where 𝘁<:AbstractFloat
## intensiveEK{𝘁} = Union{perMassEK{𝘁}, perMoleEK{𝘁}} where 𝘁<:AbstractFloat
## intensiveEP{𝘁} = Union{perMassEP{𝘁}, perMoleEP{𝘁}} where 𝘁<:AbstractFloat
## 
## export intensive_V, intensive_U, intensive_H, intensive_S, intensive_G, intensive_A
## export intensiveCP, intensiveCV, intensive_R, intensive_E, intensiveEK, intensiveEP
## 
## # Canonical properties: extensive and intensive
## canonical_V{𝘁} = Union{system_V{𝘁}, intensive_V{𝘁}} where 𝘁<:AbstractFloat
## canonical_U{𝘁} = Union{system_U{𝘁}, intensive_U{𝘁}} where 𝘁<:AbstractFloat
## canonical_H{𝘁} = Union{system_H{𝘁}, intensive_H{𝘁}} where 𝘁<:AbstractFloat
## canonical_S{𝘁} = Union{system_S{𝘁}, intensive_S{𝘁}} where 𝘁<:AbstractFloat
## canonical_G{𝘁} = Union{system_G{𝘁}, intensive_G{𝘁}} where 𝘁<:AbstractFloat
## canonical_A{𝘁} = Union{system_A{𝘁}, intensive_A{𝘁}} where 𝘁<:AbstractFloat
## canonicalCP{𝘁} = Union{systemCP{𝘁}, intensiveCP{𝘁}} where 𝘁<:AbstractFloat
## canonicalCV{𝘁} = Union{systemCV{𝘁}, intensiveCV{𝘁}} where 𝘁<:AbstractFloat
## canonical_R{𝘁} = Union{             intensive_R{𝘁}} where 𝘁<:AbstractFloat
## canonical_E{𝘁} = Union{system_E{𝘁}, intensive_E{𝘁}} where 𝘁<:AbstractFloat
## canonicalEK{𝘁} = Union{systemEK{𝘁}, intensiveEK{𝘁}} where 𝘁<:AbstractFloat
## canonicalEP{𝘁} = Union{systemEP{𝘁}, intensiveEP{𝘁}} where 𝘁<:AbstractFloat
## 
## export canonical_V, canonical_U, canonical_H, canonical_S, canonical_G, canonical_A
## export canonicalCP, canonicalCV, canonical_R, canonical_E, canonicalEK, canonicalEP
## 
## 
