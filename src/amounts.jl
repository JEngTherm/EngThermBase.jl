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

export deco, ppu


#----------------------------------------------------------------------------------------------#
#                                     Generic Amount Type                                      #
#----------------------------------------------------------------------------------------------#

import Base: cp, convert

"""
`struct _Amt{𝗽<:PREC,𝘅<:EXAC} <: AMOUNTS{𝗽,𝘅}`\n
Precision-, and Exactness- parametric generic amounts in arbitrary units.\n
`_Amt{𝗽,𝘅}` parameters are:\n
- Precision `𝗽<:Union{Float16,Float32,Float64,BigFloat}`;\n
- Exactness `𝘅<:Union{EX,MM}`, i.e., either a single, precise value or an uncertainty-bearing
  measurement, respectively;\n
A `_Amt` can be natively constructed from the following argument types:\n
- A plain, unitless float;\n
- A plain, unitless `Measurement`; hence, any `AbstractFloat`;\n
- A `Quantity{AbstractFloat}` with any units.\n
## Hierarchy\n
`_Amt <: $(tyArchy(AMOUNTS))`
"""
struct _Amt{𝗽,𝘅} <: GenericAmt{𝗽,𝘅}
    amt::UATY{𝗽} where 𝗽<:PREC
    # Copy constructor
    _Amt(x::_Amt{𝗽,𝘅}) where {𝗽<:PREC,𝘅<:EXAC} = new{𝗽,𝘅}(x.amt)
    _Amt(x::Union{𝗽,UETY{𝗽}}) where 𝗽<:PREC = new{𝗽,EX}(_qty(x))
    _Amt(x::Union{PMTY{𝗽},UMTY{𝗽}}) where 𝗽<:PREC = new{𝗽,MM}(_qty(x))
end

# Precision-changing external constructors
(::Type{_Amt{𝘀}})(x::_Amt{𝗽,EX}
                 ) where {𝘀<:PREC,𝗽<:PREC} = _Amt(𝘀(x.amt.val))
(::Type{_Amt{𝘀}})(x::_Amt{𝗽,MM}
                 ) where {𝘀<:PREC,𝗽<:PREC} = _Amt(Measurement{𝘀}(x.amt.val))

# Precision+Exactness-changing external constructors
(::Type{_Amt{𝘀,EX}})(x::_Amt{𝗽,EX}
                    ) where {𝘀<:PREC,𝗽<:PREC} = _Amt(𝘀(x.amt.val))
(::Type{_Amt{𝘀,EX}})(x::_Amt{𝗽,MM}
                    ) where {𝘀<:PREC,𝗽<:PREC} = _Amt(𝘀(x.amt.val.val))
(::Type{_Amt{𝘀,MM}})(x::_Amt{𝗽,EX},
                     e::𝘀=𝘀(max(eps(𝘀),eps(x.amt.val)))
                    ) where {𝘀<:PREC,𝗽<:PREC} = _Amt(measurement(𝘀(x.amt.val), e))
(::Type{_Amt{𝘀,MM}})(x::_Amt{𝗽,MM}
                    ) where {𝘀<:PREC,𝗽<:PREC} = _Amt(Measurement{𝘀}(x.amt.val))

# Type export
export _Amt

# Type-specific functions
deco(x::_Amt{𝗽,𝘅} where {𝗽,𝘅}) = Symbol("?")
ppu(x::_Amt) = "$(unit(x.amt))"

# Conversions
convert(::Type{_Amt{𝘀,𝘅}},
        y::_Amt{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘅<:EXAC} = begin
    _Amt{promote_type(𝘀,𝗽),𝘅}(y)
end
convert(::Type{_Amt{𝘀,𝘆}},
        y::_Amt{𝗽,𝘅}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
    _Amt{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}(y)
end

# Promotion rules
promote_rule(::Type{_Amt{𝘀,𝘆}},
             ::Type{_Amt{𝗽,𝘅}}) where {𝘀<:PREC,𝗽<:PREC,𝘆<:EXAC,𝘅<:EXAC} = begin
    _Amt{promote_type(𝘀,𝗽),promote_type(𝘆,𝘅)}
end


#----------------------------------------------------------------------------------------------#
#                                  Whole Amount Type Factory                                   #
#----------------------------------------------------------------------------------------------#

import Unicode: normalize

"""
Whole Amount type factory.
"""
function mkWhlAmt(TYPE::Symbol,         # Type name:            :sysT
                  SUPT::Symbol,         # Supertype:            :WProperty
                  FNAM::Symbol,         # Function Name:        :T
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
    # @eval block
    @eval begin
        # Concrete type definition
        struct $TYPE{𝗽,𝘅} <: $SUPT{𝗽,𝘅}
            amt::UATY{𝗽,$𝑑SY,$𝑢SY} where 𝗽<:PREC
            # Copy constructor
            $TYPE(x::$TYPE{𝗽,𝘅}) where {𝗽<:PREC,𝘅<:EXAC} = new{𝗽,𝘅}(x.amt)
            # Plain constructors enforce default units & avoid unit conversion
            $TYPE(x::𝗽) where 𝗽<:PREC = new{𝗽,EX}(_qty(x * $uSY))
            $TYPE(x::PMTY{𝗽}) where 𝗽<:PREC = new{𝗽,MM}(_qty(x * $uSY))
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
        ppu(x::$TYPE{𝗽,𝘅} where {𝗽,𝘅}) = $USTR
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
mkWhlAmt(:sysT  , :WProperty, :T    , "T"   , u"K"          , "K"       , "temperature"         , false )
mkWhlAmt(:sysP  , :WProperty, :P    , "P"   , u"kPa"        , "kPa"     , "pressure"            , false )
mkWhlAmt(:VELO  , :WProperty, :velo , "𝕍"   , u"√(kJ/kg)"   , "√kJ/kg"  , "velocity"            , false )
mkWhlAmt(:SPEE  , :WProperty, :spee , "𝕧"   , u"m/s"        , "m/s"     , "speed"               , false )

# Regular unranked -- \sans#<TAB> function names
mkWhlAmt(:time  , :WUnranked, :time , "𝗍"   , u"s"          , "s"       , "time"                , false )
mkWhlAmt(:grav  , :WUnranked, :grav , "𝗀"   , u"m/s^2"      , "m/s²"    , "gravity"             , false )
mkWhlAmt(:alti  , :WUnranked, :alti , "𝗓"   , u"m"          , "m"       , "altitude"            , false )


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
        ppu(x::$TYPE{𝗽,𝘅,SY} where {𝗽,𝘅}) = $USTR
        ppu(x::$TYPE{𝗽,𝘅,DT} where {𝗽,𝘅}) = $USTR * "/s"
        ppu(x::$TYPE{𝗽,𝘅,MA} where {𝗽,𝘅}) = $USTR * "/kg"
        ppu(x::$TYPE{𝗽,𝘅,MO} where {𝗽,𝘅}) = $USTR * "/kmol"
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
mkBasAmt(:mAmt  , :BProperty, :m    , "m"   , u"kg"         , "kg"      , "mass"                , false , bsym=(:m , :ṁ , :mf, :M))
# Chemical amount / Molar fraction anomalous
mkBasAmt(:nAmt  , :BProperty, :N    , "N"   , u"kmol"       , "kmol"    , "chemical amount"     , false , bsym=(:N , :Ṅ , :n , :y))
# Gas constant / System constant anomalous
mkBasAmt(:RAmt  , :BProperty, :R    , "mR"  , u"kJ/K"       , "kJ/K"    , "gas constant"        , false , bsym=(:mR, :ṁR, :R , :R̄))
# Plank function anomalous
mkBasAmt(:rAmt  , :BProperty, :r    , "mr"  , u"kJ/K"       , "kJ/K"    , "Planck function"     , false , bsym=(:mr, :ṁr, :r , :r̄))

# Regular properties
mkBasAmt(:uAmt  , :BProperty, :u    , "U"   , u"kJ"         , "kJ"      , "internal energy"     , false )
mkBasAmt(:hAmt  , :BProperty, :h    , "H"   , u"kJ"         , "kJ"      , "enthalpy"            , false )
mkBasAmt(:gAmt  , :BProperty, :g    , "G"   , u"kJ"         , "kJ"      , "Gibbs energy"        , false )
mkBasAmt(:aAmt  , :BProperty, :a    , "A"   , u"kJ"         , "kJ"      , "Helmholtz energy"    , false )
mkBasAmt(:eAmt  , :BProperty, :e    , "E"   , u"kJ"         , "kJ"      , "total energy"        , false )
mkBasAmt(:ekAmt , :BProperty, :ek   , "Ek"  , u"kJ"         , "kJ"      , "kinetic energy"      , false )
mkBasAmt(:epAmt , :BProperty, :ep   , "Ep"  , u"kJ"         , "kJ"      , "potential energy"    , false )
mkBasAmt(:sAmt  , :BProperty, :s    , "S"   , u"kJ/K"       , "kJ/K"    , "entropy"             , false )
mkBasAmt(:cpAmt , :BProperty, :cp   , "Cp"  , u"kJ/K"       , "kJ/K"    , "iso-P specific heat" , false )
mkBasAmt(:cvAmt , :BProperty, :cv   , "Cv"  , u"kJ/K"       , "kJ/K"    , "iso-v specific heat" , false )
mkBasAmt(:jAmt  , :BProperty, :j    , "J"   , u"kJ/K"       , "kJ/K"    , "Massieu function"    , false )

# Regular interactions
mkBasAmt(:qAmt  , :BInteract, :q    , "Q"   , u"kJ"         , "kJ"      , "heat"                , false )
mkBasAmt(:wAmt  , :BInteract, :w    , "W"   , u"kJ"         , "kJ"      , "work"                , false )
mkBasAmt(:ΔeAmt , :BInteract, :Δe   , "E"   , u"kJ"         , "kJ"      , "energy variation"    , true  )
mkBasAmt(:ΔsAmt , :BInteract, :Δs   , "S"   , u"kJ/K"       , "kJ/K"    , "entropy variation"   , true  )


#----------------------------------------------------------------------------------------------#
#                                       Pretty Printing                                        #
#----------------------------------------------------------------------------------------------#

import Base: show
import Formatting: sprintf1


# Auxiliar method
function subscript(x::Int)
    asSub(c::Char) = Char(Int(c) - Int('0') + Int('₀'))
    map(asSub, "$(x)")
end

# Precision decoration
pDeco(::Type{Float16})  = DEF[:showPrec] ? subscript(16) : ""
pDeco(::Type{Float32})  = DEF[:showPrec] ? subscript(32) : ""
pDeco(::Type{Float64})  = DEF[:showPrec] ? subscript(64) : ""
pDeco(::Type{BigFloat}) = DEF[:showPrec] ? subscript(precision(BigFloat)) : ""

# Custom printing
Base.show(io::IO, x::AMOUNTS{𝗽,EX}) where 𝗽<:PREC = begin
    print(io,
          "$(string(deco(x)))$(pDeco(𝗽)): ",
          sprintf1("%.$(DEF[:showSigD])g", x.amt.val),
          " ", ppu(x))
    # Formatting string is hardcoded apparently because @sprintf is a macro!
end

Base.show(io::IO, x::AMOUNTS{𝗽,MM}) where 𝗽<:PREC = begin
    print(io,
          "$(string(deco(x)))$(pDeco(𝗽)): (",
          sprintf1("%.$(DEF[:showSigD])g", x.amt.val.val),
          " ± ",
          sprintf1("%.2g", x.amt.val.err),
          ") ", ppu(x))
    # Formatting string is hardcoded apparently because @sprintf is a macro!
end


