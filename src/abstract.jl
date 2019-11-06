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
mk2ParAbs(    :Property    , :AMOUNT       , "thermodynamic properties"                    , 2)
mk2ParAbs(      :Unbased   , :Property     , "unbased intrinsic intensive properties"      , 2)
mk3ParAbs(      :Based     , :Property     , "based property groups"                       , 2)
mk3ParAbs(    :Interaction , :AMOUNT       , "thermodynamic interations"                   , 2)
mk2ParAbs(    :Unranked    , :AMOUNT       , "unranked amounts"                            , 2)

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


