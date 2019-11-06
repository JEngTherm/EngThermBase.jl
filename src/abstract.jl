#----------------------------------------------------------------------------------------------#
#                              Abstract EngTherm Type Definitions                              #
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

Property = Union{WProperty,BProperty}
Interact = Union{WInteract,BInteract}
Unranked = Union{WUnranked,BUnranked}

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

# AUX branch
mkNonPAbs(  :AUX           , :EngTherm     , "ancillary EngTherm types"                       )
mkNonPAbs(    :AuxFunc     , :AUX          , "ancillary functions"                            )


