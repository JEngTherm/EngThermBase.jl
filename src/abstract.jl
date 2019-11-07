#----------------------------------------------------------------------------------------------#
#                                 Plain Abstract Type Factory                                  #
#----------------------------------------------------------------------------------------------#

"""
`function tyArchy(t::Union{DataType,UnionAll})`\n
Returns a string suitable for documenting the hierarchy of an abstract type.
"""
function tyArchy(t::Union{DataType,UnionAll})
    h = Any[t]; while h[end] != Any; append!(h, [supertype(h[end])]); end
    H = Tuple(string(nameof(i)) for i in h)
    join(H, " <: ")
end

"""
`function mkNonPAbs(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)`\n
Declares exactly one new, non-parametric, abstract type `TY <: TP`. Argument `what` is inserted
in the new type documentation, and `xp` controls whether or not the new abstract type is
exported (default `true`).
"""
function mkNonPAbs(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)
    if !(eval(TP) isa DataType)
        error("Type parent must be a DataType. Got $(string(TP)).")
    end
    hiStr = tyArchy(eval(TP))
    dcStr = """
`abstract type $(TY) <: $(TP) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    @eval begin
        # Abstract type definition
        abstract type $TY <: $TP end
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end


#----------------------------------------------------------------------------------------------#
#                        EngTherm Plain Abstract Supertype Definitions                         #
#----------------------------------------------------------------------------------------------#

# EngTherm root abstract type
mkNonPAbs(:EngTherm        , :Any          , "thermodynamic entities"                         )

# BASE branch
mkNonPAbs(  :BASE          , :EngTherm     , "quantity bases"                                 )
mkNonPAbs(    :ThermBase   , :BASE         , "thermodynamic bases"                            )
mkNonPAbs(      :IntBase   , :ThermBase    , "intensive bases"                                )
mkNonPAbs(        :MA      , :IntBase      , "the MAss base"                                  )
mkNonPAbs(        :MO      , :IntBase      , "the MOlar base"                                 )
mkNonPAbs(      :ExtBase   , :ThermBase    , "non-intensive bases"                            )
mkNonPAbs(        :SY      , :ExtBase      , "the SYstem (extensive) base"                    )
mkNonPAbs(        :DT      , :ExtBase      , "the Time Derivative (rate) base"                )
mkNonPAbs(    :ExactBase   , :BASE         , "type-exactness bases"                           )
mkNonPAbs(      :EX        , :ExactBase    , "the EXact base"                                 )
mkNonPAbs(      :MM        , :ExactBase    , "the MeasureMent base"                           )

# AUX branch
mkNonPAbs(  :AUX           , :EngTherm     , "ancillary EngTherm types"                       )
mkNonPAbs(    :AuxFunc     , :AUX          , "ancillary functions"                            )


#----------------------------------------------------------------------------------------------#
#                Concrete type unions for allowed abstract supertype parameters                #
#----------------------------------------------------------------------------------------------#

"""
`const PRECISION = Union{Float16,Float32,Float64,BigFloat}`\n
Concrete PRECISION type union for parametric abstract types.
"""
const PRECISION = Union{Float16,Float32,Float64,BigFloat}

"""
`const EXACTNESS = Union{EX,MM}`\n
Concrete EXACTNESS type union for parametric abstract types.
"""
const EXACTNESS = Union{EX,MM}

"""
`const THERMBASE = Union{MA,MO,SY,DT}`\n
Concrete THERMBASE type union for parametric abstract types.
"""
const THERMBASE = Union{MA,MO,SY,DT}


#----------------------------------------------------------------------------------------------#
#            {PRECISION[,EXACTNESS[,THERMBASE]]} Parametric Abstract Type Factories            #
#----------------------------------------------------------------------------------------------#

"""
`function mk1ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, pp::Integer=1,
xp::Bool=true)`\n
Declares a new, 1-parameter abstract type. Parent type parameter count is a function of `pp`, so
that declarations are as follows:\n
- `TY{𝗽} <: TP{𝗽}` for `pp >= 1` (default);
- `TY{𝗽<:PRECISION} <: TP` for `pp <= 0`.\n
Argument `what` is inserted in the new type documentation, and `xp` controls whether or not the
new abstract type is exported (default `true`).
"""
function mk1ParAbs(TY::Symbol, TP::Symbol, what::AbstractString,
                   pp::Integer=1, xp::Bool=true)
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    ppStr = pp>=1 ? "{𝗽}" : ""
    tpStr = pp>=1 ? "{𝗽}" : "{𝗽<:PRECISION}"
    dcStr = """
`abstract type $(TY)$(tpStr) <: $(TP)$(ppStr) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if      pp>=1   @eval (abstract type $TY{𝗽} <: $TP{𝗽} end)
    elseif  pp<=0   @eval (abstract type $TY{𝗽<:PRECISION} <: $TP end)
    end
    @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end

"""
`function mk2ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, pp::Integer=2,
xp::Bool=true)`\n
Declares a new, 2-parameter abstract type. Parent type parameter count is a function of `pp`, so
that declarations are as follows:\n
- `TY{𝗽,𝘅} <: TP{𝗽,𝘅}` for `pp >= 2` (default);
- `TY{𝗽,𝘅<:EXACTNESS} <: TP{𝗽}` for `pp = 1`;
- `TY{𝗽<:PRECISION,𝘅<:EXACTNESS} <: TP` for `pp <= 0`.\n
Argument `what` is inserted in the new type documentation, and `xp` controls whether or not the
new abstract type is exported (default `true`).
"""
function mk2ParAbs(TY::Symbol, TP::Symbol, what::AbstractString,
                   pp::Integer=2, xp::Bool=true)
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    ppStr = pp>=2 ? "{𝗽,𝘅}" : pp==1 ? "{𝗽}" : ""
    tpStr = pp>=2 ? "{𝗽,𝘅}" : pp==1 ? "{𝗽,𝘅<:EXACTNESS}" : "{𝗽<:PRECISION,𝘅<:EXACTNESS}"
    dcStr = """
`abstract type $(TY)$(tpStr) <: $(TP)$(ppStr) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if      pp>=2   @eval (abstract type $TY{𝗽,𝘅} <: $TP{𝗽,𝘅} end)
    elseif  pp==1   @eval (abstract type $TY{𝗽,𝘅<:EXACTNESS} <: $TP{𝗽} end)
    elseif  pp<=0   @eval (abstract type $TY{𝗽<:PRECISION,𝘅<:EXACTNESS} <: $TP end)
    end
    @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end

"""
`function mk3ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, pp::Integer=3,
xp::Bool=true)`\n
Declares a new, 3-parameter abstract type. Parent type parameter count is a function of `pp`, so
that declarations are as follows:\n
- `TY{𝗽,𝘅,𝗯} <: TP{𝗽,𝘅,𝗯}` for `pp >= 3` (default);
- `TY{𝗽,𝘅,𝗯<:THERMBASE} <: TP{𝗽,𝘅}` for `pp == 2`;
- `TY{𝗽,𝘅<:EXACTNESS,𝗯<:THERMBASE} <: TP{𝗽}` for `pp = 1`;
- `TY{𝗽<:PRECISION,𝘅<:EXACTNESS,𝗯<:THERMBASE} <: TP` for `pp <= 0`.\n
Argument `what` is inserted in the new type documentation, and `xp` controls whether or not the
new abstract type is exported (default `true`).
"""
function mk3ParAbs(TY::Symbol, TP::Symbol, what::AbstractString,
                   pp::Integer=3, xp::Bool=true)
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    ppStr = pp>=3 ? "{𝗽,𝘅,𝗯}" : pp==2 ? "{𝗽,𝘅}" : pp==1 ? "{𝗽}" : ""
    tpStr = pp>=3 ? "{𝗽,𝘅,𝗯}" :
            pp==2 ? "{𝗽,𝘅,𝗯<:THERMBASE}" :
            pp==1 ? "{𝗽,𝘅<:EXACTNESS,𝗯<:THERMBASE}" :
                    "{𝗽<:PRECISION,𝘅<:EXACTNESS,𝗯<:THERMBASE}"
    dcStr = """
`abstract type $(TY)$(tpStr) <: $(TP)$(ppStr) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if pp>=3
        @eval (abstract type $TY{𝗽,𝘅,𝗯} <: $TP{𝗽,𝘅,𝗯} end)
    elseif pp==2
        @eval (abstract type $TY{𝗽,𝘅,𝗯<:THERMBASE} <: $TP{𝗽,𝘅} end)
    elseif pp==1
        @eval (abstract type $TY{𝗽,𝘅<:EXACTNESS,𝗯<:THERMBASE} <: $TP{𝗽} end)
    elseif pp<=0
        @eval (abstract type $TY{𝗽<:PRECISION,𝘅<:EXACTNESS,𝗯<:THERMBASE} <: $TP end)
    end
    @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end


#----------------------------------------------------------------------------------------------#
#                      EngTherm Parametric Abstract Supertype Definitions                      #
#----------------------------------------------------------------------------------------------#

# AMOUNT branch — Pars are (i) precision, and (ii) exactness
mk2ParAbs(  :AMOUNT        , :EngTherm     , "thermodynamic amount"                        , 0)
mk2ParAbs(    :WholeAmt    , :AMOUNT       , "whole, unbased amounts"                      , 2)
mk2ParAbs(      :WProperty , :WholeAmt     , "whole, unbased properties"                   , 2)
mk2ParAbs(      :WInteract , :WholeAmt     , "whole, unbased interactions"                 , 2)
mk2ParAbs(      :WUnranked , :WholeAmt     , "whole, unbased unranked amounts"             , 2)
mk3ParAbs(    :BasedAmt    , :AMOUNT       , "based amount groups"                         , 2)
mk3ParAbs(      :BProperty , :BasedAmt     , "based property groups"                       , 3)
mk3ParAbs(      :BInteract , :BasedAmt     , "based interaction groups"                    , 3)
mk3ParAbs(      :BUnranked , :BasedAmt     , "based unranked amount groups"                , 3)

Property{𝗽,𝘅} = Union{WProperty{𝗽,𝘅},BProperty{𝗽,𝘅,𝗯} where 𝗯} where {𝗽,𝘅}
Interact{𝗽,𝘅} = Union{WInteract{𝗽,𝘅},BInteract{𝗽,𝘅,𝗯} where 𝗯} where {𝗽,𝘅}
Unranked{𝗽,𝘅} = Union{WUnranked{𝗽,𝘅},BUnranked{𝗽,𝘅,𝗯} where 𝗯} where {𝗽,𝘅}

export Property, Interact, Unranked

# STATE branch — Pars are (i) precision, and (ii) exactness
mk2ParAbs(  :STATE         , :EngTherm     , "state types"                                 , 0)
mk2ParAbs(    :PropPair    , :STATE        , "propery pairs"                               , 2)
mk2ParAbs(    :PropTrio    , :STATE        , "propery trios"                               , 2)
mk2ParAbs(    :PropQuad    , :STATE        , "propery quads"                               , 2)

# MODEL branch — Pars are (i) precision, and (ii) exactness
mk2ParAbs(  :MODEL         , :EngTherm     , "thermodynamic model"                         , 0)
mk2ParAbs(    :Heat        , :MODEL        , "specific heat models"                        , 2)
mk2ParAbs(      :ConstHeat , :Heat         , "constant specific heat models"               , 2)
mk2ParAbs(      :UnvarHeat , :Heat         , "univariate specific heat models"             , 2)
mk2ParAbs(      :BivarHeat , :Heat         , "bivariate specific heat models"              , 2)
mk2ParAbs(    :Medium      , :MODEL        , "substance/medium models"                     , 2)
mk2ParAbs(      :Substance , :Medium       , "substance model by Equation of State"        , 2)
mk2ParAbs(    :System      , :MODEL        , "system models"                               , 2)
mk2ParAbs(      :Closed    , :System       , "closed systems"                              , 2)
mk2ParAbs(      :Open      , :System       , "open systems"                                , 2)


