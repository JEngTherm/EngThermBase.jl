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
mkNonPAbs(:AbstractTherm   , :Any          , "thermodynamic entities"                         )

# BASE branch
mkNonPAbs(  :BASES         , :AbstractTherm, "quantity bases"                                 )
mkNonPAbs(    :ThermBase   , :BASES        , "thermodynamic bases"                            )
mkNonPAbs(      :IntBase   , :ThermBase    , "intensive bases"                                )
mkNonPAbs(        :MA      , :IntBase      , "the MAss base"                                  )
mkNonPAbs(        :MO      , :IntBase      , "the MOlar base"                                 )
mkNonPAbs(      :ExtBase   , :ThermBase    , "non-intensive bases"                            )
mkNonPAbs(        :SY      , :ExtBase      , "the SYstem (extensive) base"                    )
mkNonPAbs(        :DT      , :ExtBase      , "the Time Derivative (rate) base"                )
mkNonPAbs(    :ExactBase   , :BASES        , "type-exactness bases"                           )
mkNonPAbs(      :EX        , :ExactBase    , "the EXact base"                                 )
mkNonPAbs(      :MM        , :ExactBase    , "the MeasureMent base"                           )

# # AUX branch
# mkNonPAbs(  :AUX           , :AbstractTherm, "ancillary EngTherm types"                       )
# mkNonPAbs(    :AuxFunc     , :AUX          , "ancillary functions"                            )


#----------------------------------------------------------------------------------------------#
#                Concrete type unions for allowed abstract supertype parameters                #
#----------------------------------------------------------------------------------------------#

"""
`const PREC = Union{Float16,Float32,Float64,BigFloat}`\n
Concrete PREC type union for parametric abstract types.
"""
const PREC = Union{Float16,Float32,Float64,BigFloat}

"""
`const EXAC = Union{EX,MM}`\n
Concrete EXAC type union for parametric abstract types.
"""
const EXAC = Union{EX,MM}

"""
`const BASE = Union{MA,MO,SY,DT}`\n
Concrete BASE type union for parametric abstract types.
"""
const BASE = Union{MA,MO,SY,DT}

export PREC, EXAC, BASE


#----------------------------------------------------------------------------------------------#
#                   {PREC[,EXAC[,BASE]]} Parametric Abstract Type Factories                    #
#----------------------------------------------------------------------------------------------#

"""
`function mk1ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, pp::Integer=1,
xp::Bool=true)`\n
Declares a new, 1-parameter abstract type. Parent type parameter count is a function of `pp`, so
that declarations are as follows:\n
- `TY{𝗽} <: TP{𝗽}` for `pp >= 1` (default);
- `TY{𝗽<:PREC} <: TP` for `pp <= 0`.\n
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
    dcStr = """
`abstract type $(TY){𝗽<:PREC} <: $(TP)$(ppStr) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if      pp>=1   @eval (abstract type $TY{𝗽} <: $TP{𝗽} end)
    elseif  pp<=0   @eval (abstract type $TY{𝗽<:PREC} <: $TP end)
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
- `TY{𝗽,𝘅<:EXAC} <: TP{𝗽}` for `pp = 1`;
- `TY{𝗽<:PREC,𝘅<:EXAC} <: TP` for `pp <= 0`.\n
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
    dcStr = """
`abstract type $(TY){𝗽<:PREC,𝘅<:EXAC} <: $(TP)$(ppStr) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if      pp>=2   @eval (abstract type $TY{𝗽,𝘅} <: $TP{𝗽,𝘅} end)
    elseif  pp==1   @eval (abstract type $TY{𝗽,𝘅<:EXAC} <: $TP{𝗽} end)
    elseif  pp<=0   @eval (abstract type $TY{𝗽<:PREC,𝘅<:EXAC} <: $TP end)
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
- `TY{𝗽,𝘅,𝗯<:BASE} <: TP{𝗽,𝘅}` for `pp == 2`;
- `TY{𝗽,𝘅<:EXAC,𝗯<:BASE} <: TP{𝗽}` for `pp = 1`;
- `TY{𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} <: TP` for `pp <= 0`.\n
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
    dcStr = """
`abstract type $(TY){𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} <: $(TP)$(ppStr) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if pp>=3
        @eval (abstract type $TY{𝗽,𝘅,𝗯} <: $TP{𝗽,𝘅,𝗯} end)
    elseif pp==2
        @eval (abstract type $TY{𝗽,𝘅,𝗯<:BASE} <: $TP{𝗽,𝘅} end)
    elseif pp==1
        @eval (abstract type $TY{𝗽,𝘅<:EXAC,𝗯<:BASE} <: $TP{𝗽} end)
    elseif pp<=0
        @eval (abstract type $TY{𝗽<:PREC,𝘅<:EXAC,𝗯<:BASE} <: $TP end)
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
mk2ParAbs(  :AMOUNTS       , :AbstractTherm, "thermodynamic amounts"                       , 0)
mk2ParAbs(    :WholeAmt    , :AMOUNTS      , "whole, unbased amounts of fixed units"       , 2)
mk2ParAbs(      :WProperty , :WholeAmt     , "whole, unbased properties"                   , 2)
mk2ParAbs(      :WInteract , :WholeAmt     , "whole, unbased interactions"                 , 2)
mk2ParAbs(      :WUnranked , :WholeAmt     , "whole, unbased unranked amounts"             , 2)
mk3ParAbs(    :BasedAmt    , :AMOUNTS      , "based amount groups of fixed units"          , 2)
mk3ParAbs(      :BProperty , :BasedAmt     , "based property groups"                       , 3)
mk3ParAbs(      :BInteract , :BasedAmt     , "based interaction groups"                    , 3)
mk3ParAbs(      :BUnranked , :BasedAmt     , "based unranked amount groups"                , 3)
mk2ParAbs(    :GenerAmt    , :AMOUNTS      , "generic, arbitrary unit amounts"             , 2)

Property{𝗽,𝘅} = Union{WProperty{𝗽,𝘅},BProperty{𝗽,𝘅,𝗯} where 𝗯} where {𝗽,𝘅}
Interact{𝗽,𝘅} = Union{WInteract{𝗽,𝘅},BInteract{𝗽,𝘅,𝗯} where 𝗯} where {𝗽,𝘅}
Unranked{𝗽,𝘅} = Union{WUnranked{𝗽,𝘅},BUnranked{𝗽,𝘅,𝗯} where 𝗯} where {𝗽,𝘅}

export Property, Interact, Unranked

# COMBOS branch — Pars are (i) precision, and (ii) exactness
mk2ParAbs(  :COMBOS        , :AbstractTherm, "thermodynamic property combinations"         , 0)
mk2ParAbs(    :PropPair    , :COMBOS       , "propery pairs"                               , 2)
mk2ParAbs(      :EoSPair   , :PropPair     , "Equation of State property pairs"            , 2)
mk2ParAbs(      :ChFPair   , :PropPair     , "Characteristic Function property pairs"      , 2)
mk2ParAbs(    :PropTrio    , :COMBOS       , "propery trios"                               , 2)
mk2ParAbs(    :PropQuad    , :COMBOS       , "propery quads"                               , 2)

# MODEL branch — Pars are (i) precision, (ii) exactness, and (iii) base
mk2ParAbs(  :MODELS          , :AbstractTherm, "thermodynamic models"                      , 0)
mk3ParAbs(    :Heat          , :MODELS       , "specific heat models"                      , 2)
mk3ParAbs(      :ConstHeat   , :Heat         , "constant specific heat models"             , 3)
mk3ParAbs(      :UnvarHeat   , :Heat         , "univariate specific heat models"           , 3)
mk3ParAbs(      :BivarHeat   , :Heat         , "bivariate specific heat models"            , 3)
mk3ParAbs(      :GenerHeat   , :Heat         , "generic specific heat models"              , 3)
mk2ParAbs(    :Medium        , :MODELS       , "substance/medium models"                   , 2)
mk2ParAbs(      :Substance   , :Medium       , "substance model by Equation of State"      , 2)
mk2ParAbs(    :System        , :MODELS       , "system models"                             , 2)
mk2ParAbs(      :Scope       , :System       , "defined amounts of substance"              , 2)
mk2ParAbs(        :PureSubs  , :Scope        , "a defined amount of a pure substance"      , 2)
mk2ParAbs(        :Mixtures  , :Scope        , "a substance mixture"                       , 2)
mk2ParAbs(          :Unreact , :Mixtures     , "an unreactive mixture"                     , 2)
mk2ParAbs(          :Reactiv , :Mixtures     , "a reactive mixture"                        , 2)


