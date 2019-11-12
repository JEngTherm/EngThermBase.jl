#----------------------------------------------------------------------------------------------#
#                                           Imports                                            #
#----------------------------------------------------------------------------------------------#

import Unicode: normalize
import Base: cp, convert


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
#                                  Whole Amount Type Factory                                   #
#----------------------------------------------------------------------------------------------#

"""
Whole Amount type factory.
"""
function mkWhlAmt(TYPE::Symbol,         # Type name:            :sysT
                  SUPT::Symbol,         # Supertype:            :WProperty
                  FNAM::Symbol,         # Function Name:        :T
                  SYMB::AbstractString, # Printing symbol:      "T"
                  UNIT::Unitful.Units,  # SY quantity units:    u"K"
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
Precision-, and Exactness- parametric $WHAT amounts based in $UNIT.\n
`$TYPE{𝗽,𝘅}` parameters are:\n
- Precision `𝗽<:Union{Float16,Float32,Float64,BigFloat}`;\n
- Exactness `𝘅<:Union{EX,MM}`, i.e., either a single, precise value or an uncertainty-bearing
  measurement, respectively;\n
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
        struct $TYPE{𝗽,𝘅} <: $SUPT{𝗽,𝘅}
            amt::UATY{𝗽,$𝑑SY,$𝑢SY} where 𝗽<:PREC
            # Copy constructor
            $TYPE(x::$TYPE{𝗽,𝘅}) where {𝗽<:PREC,𝘅<:EXAC} = new{𝗽,𝘅}(x.amt)
            # Plain constructors enforce default units & avoid unit conversion
            $TYPE(x::𝗽, ::Type{SY}) where 𝗽<:PREC = new{𝗽,EX}(_qty(x * $uSY))
            $TYPE(x::PMTY{𝗽}, ::Type{SY}) where 𝗽<:PREC = new{𝗽,MM}(_qty(x * $uSY))
            # Quantity constructors have to perform unit conversion despite matching dimensions
            $TYPE(x::UETY{𝗽,$𝑑SY}) where 𝗽<:PREC = new{𝗽,EX}(_qty(uconvert($uSY, x)))
            $TYPE(x::UMTY{𝗽,$𝑑SY}) where 𝗽<:PREC = new{𝗽,MM}(_qty(uconvert($uSY, x)))
        end
        # Type documentation
        @doc $dcStr $TYPE
        # Precision-changing external constructors
        (::Type{$TYPE{𝘀}})(x::$TYPE{𝗽,EX}
                          ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(𝘀(x.amt.val))
        (::Type{$TYPE{𝘀}})(x::$TYPE{𝗽,MM}
                          ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(Measurement{𝘀}(x.amt.val))
        # Precision+Exactness-changing external constructors
        (::Type{$TYPE{𝘀,EX}})(x::$TYPE{𝗽,EX}
                             ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(𝘀(x.amt.val))
        (::Type{$TYPE{𝘀,EX}})(x::$TYPE{𝗽,MM}
                             ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(𝘀(x.amt.val.val))
        (::Type{$TYPE{𝘀,MM}})(x::$TYPE{𝗽,EX},
                              e::𝘀=𝘀(max(eps(𝘀),eps(x.amt.val)))
                             ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(measurement(𝘀(x.amt.val), e))
        (::Type{$TYPE{𝘀,MM}})(x::$TYPE{𝗽,MM}
                             ) where {𝘀<:PREC,𝗽<:PREC} = $TYPE(Measurement{𝘀}(x.amt.val))
        # Type export
        export $TYPE
        # Type-specific functions
        deco(x::$TYPE{𝗽,𝘅} where {𝗽,𝘅}) = Symbol($𝑠SY)
        # Indirect construction from plain
        $FNAM(x::plnF) = $TYPE(x)
        $FNAM(x::plnR) = $TYPE(float(x))
        # Indirect construction from quantity
        $FNAM(x::UATY{𝗽,$𝑑SY}) where 𝗽<:PREC = $TYPE(x)
        $FNAM(x::uniR{𝗽,$𝑑SY}) where 𝗽<:REAL = $TYPE(float(x.val) * unit(x))
        export $FNAM
        # Conversions
        convert(::Type{$TYPE{𝘀,𝘅}},
                y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC} = begin
            $TYPE{promote_type(𝘀,𝗽),𝘅}(y)
        end
        convert(::Type{$TYPE{𝘀,𝘆}},
                y::$TYPE{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}(y)
        end
        # Promotion rules
        promote_rule(::Type{$TYPE{𝘀,𝘆}},
                     ::Type{$TYPE{𝗽,𝘅}}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}
        end
    end
end


#----------------------------------------------------------------------------------------------#
#                           Thermodynamic Whole Amount Declarations                            #
#----------------------------------------------------------------------------------------------#

# Regular properties -- \bb#<TAB> velocity/speed function names
mkWhlAmt(:sysT  , :WProperty, :T    , "T"   , u"K"          , "temperature"         , false )
mkWhlAmt(:sysP  , :WProperty, :P    , "P"   , u"kPa"        , "pressure"            , false )
mkWhlAmt(:velo  , :WProperty, :velo , "𝕍"   , u"√(kJ/kg)"   , "velocity"            , false )
mkWhlAmt(:spee  , :WProperty, :spee , "𝕧"   , u"m/s"        , "speed"               , false )

# Regular unranked -- \sans#<TAB> function names
mkWhlAmt(:time  , :WUnranked, :time , "𝗍"   , u"s"          , "time"                , false )
mkWhlAmt(:grav  , :WUnranked, :grav , "𝗀"   , u"m/s^2"      , "gravity"             , false )
mkWhlAmt(:alti  , :WUnranked, :alti , "𝗓"   , u"m"          , "altitude"            , false )


#----------------------------------------------------------------------------------------------#
#                                  Based Amount Type Factory                                   #
#----------------------------------------------------------------------------------------------#

"""
Based Amount type factory.
"""
function mkBasAmt(TYPE::Symbol,         # Type Name:            :uAmt
                  SUPT::Symbol,         # Supertype:            :BProperty
                  FNAM::Symbol,         # Function Name:        :u
                  SYMB::AbstractString, # Printing symbol:      "U"
                  UNIT::Unitful.Units,  # SY quantity units:    u"kJ"
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
Precision-, Exactness-, and Base- parametric $WHAT amounts based in $UNIT.\n
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
    # @eval block
    @eval begin
        # Concrete type definition
        struct $TYPE{𝗽,𝘅,𝗯} <: $SUPT{𝗽,𝘅,𝗯}
            amt::Union{UATY{𝗽,$𝑑SY,$𝑢SY},UATY{𝗽,$𝑑DT,$𝑢DT},
                       UATY{𝗽,$𝑑MA,$𝑢MA},UATY{𝗽,$𝑑MO,$𝑢MO}} where 𝗽<:PREC
            # Copy constructor
            $TYPE(x::$TYPE{𝗽,𝘅,𝗯}) where {𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} = new{𝗽,𝘅,𝗯}(x.amt)
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
            $TYPE(Measurement{𝘀}(x.amt.val), 𝗯)
        end
        # Type export
        export $TYPE
        # Type-specific functions
        deco(x::$TYPE{𝗽,𝘅,SY} where {𝗽,𝘅}) = Symbol($𝑠SY)
        deco(x::$TYPE{𝗽,𝘅,DT} where {𝗽,𝘅}) = Symbol($𝑠DT)
        deco(x::$TYPE{𝗽,𝘅,MA} where {𝗽,𝘅}) = Symbol($𝑠MA)
        deco(x::$TYPE{𝗽,𝘅,MO} where {𝗽,𝘅}) = Symbol($𝑠MO)
        # Indirect construction from plain
        $FNAM(x::plnF, b::Type{𝗯}=DEF[:IB]) where 𝗯<:BASE = $TYPE(x, b)
        $FNAM(x::plnR, b::Type{𝗯}=DEF[:IB]) where 𝗯<:BASE = $TYPE(float(x), b)
        # Indirect construction from quantity
        $FNAM(x::Union{UATY{𝗽,$𝑑SY},UATY{𝗽,$𝑑DT},
                       UATY{𝗽,$𝑑MA},UATY{𝗽,$𝑑MO}}) where 𝗽<:PREC = begin
            $TYPE(x)
        end
        $FNAM(x::Union{uniR{𝗽,$𝑑SY},uniR{𝗽,$𝑑DT},
                       uniR{𝗽,$𝑑MA},uniR{𝗽,$𝑑MO}}) where 𝗽<:REAL = begin
            $TYPE(float(x.val) * unit(x))
        end
        export $FNAM
        # Conversions - Change of base is _not_ a conversion
        # Same {EXAC,BASE}, {PREC}- conversion
        convert(::Type{$TYPE{𝘀,𝘅,𝗯}},
                y::$TYPE{𝗽,𝘅,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} = begin
            $TYPE{promote_type(𝘀,𝗽),𝘅}(y)
        end
        # Same {BASE}, {PREC,EXAC}- conversion
        convert(::Type{$TYPE{𝘀,𝘆,𝗯}},
                y::$TYPE{𝗽,𝘅,𝗯}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC,𝗯<:BASE} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}(y)
        end
        # Promotion rules
        promote_rule(::Type{$TYPE{𝘀,𝘆,𝗯}},
                     ::Type{$TYPE{𝗽,𝘅,𝗯}}) where {𝘀<:PREC,𝗽<:PREC,
                                                  𝘆<:EXAC,𝘅<:EXAC,𝗯<:BASE} = begin
            $TYPE{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅),𝗯}
        end
    end
end


#----------------------------------------------------------------------------------------------#
#                           Thermodynamic Amount Group Declarations                            #
#----------------------------------------------------------------------------------------------#

# Mass / Mass fraction anomalous
mkBasAmt(:mAmt  , :BProperty, :m    , "m"   , u"kg"         , "mass"                , false ,
         bsym=(:m, :ṁ, :mf, :M))

# Chemical amount / Molar fraction anomalous
mkBasAmt(:nAmt  , :BProperty, :N    , "N"   , u"kmol"       , "chemical amount"     , false ,
         bsym=(:N, :Ṅ, :n, :y))

# Gas constant / System constant anomalous
mkBasAmt(:RAmt  , :BProperty, :R    , "mR"  , u"kJ/K"       , "gas constant"        , false ,
         bsym=(:mR, :ṁR, :R, :R̄))

# Plank function anomalous
mkBasAmt(:rAmt  , :BProperty, :r    , "mr"  , u"kJ/K"       , "Planck function"     , false ,
         bsym=(:mr, :ṁr, :r, :r̄))

# Regular properties
mkBasAmt(:uAmt  , :BProperty, :u    , "U"   , u"kJ"         , "internal energy"     , false )
mkBasAmt(:hAmt  , :BProperty, :h    , "H"   , u"kJ"         , "enthalpy"            , false )
mkBasAmt(:gAmt  , :BProperty, :g    , "G"   , u"kJ"         , "Gibbs energy"        , false )
mkBasAmt(:aAmt  , :BProperty, :a    , "A"   , u"kJ"         , "Helmholtz energy"    , false )
mkBasAmt(:eAmt  , :BProperty, :e    , "E"   , u"kJ"         , "total energy"        , false )
mkBasAmt(:ekAmt , :BProperty, :ek   , "Ek"  , u"kJ"         , "kinetic energy"      , false )
mkBasAmt(:epAmt , :BProperty, :ep   , "Ep"  , u"kJ"         , "potential energy"    , false )
mkBasAmt(:sAmt  , :BProperty, :s    , "S"   , u"kJ/K"       , "entropy"             , false )
mkBasAmt(:cpAmt , :BProperty, :cp   , "Cp"  , u"kJ/K"       , "iso-P specific heat" , false )
mkBasAmt(:cvAmt , :BProperty, :cv   , "Cv"  , u"kJ/K"       , "iso-v specific heat" , false )
mkBasAmt(:jAmt  , :BProperty, :j    , "J"   , u"kJ/K"       , "Massieu function"    , false )

# Regular interactions
mkBasAmt(:qAmt  , :BInteract, :q    , "Q"   , u"kJ"         , "heat"                , false )
mkBasAmt(:wAmt  , :BInteract, :w    , "W"   , u"kJ"         , "work"                , false )
mkBasAmt(:ΔeAmt , :BInteract, :Δe   , "E"   , u"kJ"         , "energy variation"    , true  )
mkBasAmt(:ΔsAmt , :BInteract, :Δs   , "S"   , u"kJ/K"       , "entropy variation"   , true  )


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
