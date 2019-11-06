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

# AMOUNT branch
mk2ParAbs(  :AMOUNT        , :EngTherm     , "thermodynamic amount"                        , 0)
mk2ParAbs(    :Property    , :AMOUNT       , "thermodynamic properties"                    , 1)
mk2ParAbs(      :Unbased   , :Property     , "unbased intrinsic intensive properties"      , 2)
mk3ParAbs(      :Based     , :Property     , "based property groups"                       , 2)
mk3ParAbs(    :Interaction , :AMOUNT       , "thermodynamic interations"                   , 1)
mk1ParAbs(    :Unranked    , :AMOUNT       , "unranked amounts"                            , 1)

# STATE branch
mk1ParAbs(  :STATE         , :EngTherm     , "state types"                                 , 0)
mk1ParAbs(    :PropPair    , :STATE        , "propery pairs"                               , 1)
mk1ParAbs(    :PropTrio    , :STATE        , "propery trios"                               , 1)
mk1ParAbs(    :PropQuad    , :STATE        , "propery quads"                               , 1)

# MODEL branch
mk1ParAbs(  :MODEL         , :EngTherm     , "thermodynamic model"                         , 0)
mk1ParAbs(    :Heat        , :MODEL        , "specific heat models"                        , 1)
mk1ParAbs(      :ConstHeat , :Heat         , "constant specific heat models"               , 1)
mk1ParAbs(      :UnvarHeat , :Heat         , "univariate specific heat models"             , 1)
mk1ParAbs(      :BivarHeat , :Heat         , "bivariate specific heat models"              , 1)
mk1ParAbs(    :Medium      , :MODEL        , "substance/medium models"                     , 1)
mk1ParAbs(      :Substance , :Medium       , "substance model by Equation of State"        , 1)
mk1ParAbs(    :System      , :MODEL        , "system models"                               , 1)
mk1ParAbs(      :Closed    , :System       , "closed systems"                              , 1)
mk1ParAbs(      :Open      , :System       , "open systems"                                , 1)

# AUX branch
mkNonPAbs(  :AUX           , :EngTherm     , "ancillary EngTherm types"                       )
mkNonPAbs(    :AuxFunc     , :AUX          , "ancillary functions"                            )


