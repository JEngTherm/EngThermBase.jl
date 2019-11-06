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
mk1ParAbs(  :AMOUNT        , :EngTherm     , "thermodynamic amount"                    , false)
mk1ParAbs(    :Property    , :AMOUNT       , "thermodynamic properties"                , true )
mk1ParAbs(      :Intrinsic , :Property     , "intrinsic intensive properties"          , true )
mk1ParAbs(    :Interaction , :AMOUNT       , "thermodynamic interations"               , true )
mk1ParAbs(    :Unranked    , :AMOUNT       , "unranked amounts"                        , true )

# STATE branch
mk1ParAbs(  :STATE         , :EngTherm     , "state types"                             , false)
mk1ParAbs(    :PropPair    , :STATE        , "propery pairs"                           , true )
mk1ParAbs(    :PropTrio    , :STATE        , "propery trios"                           , true )
mk1ParAbs(    :PropQuad    , :STATE        , "propery quads"                           , true )

# MODEL branch
mk1ParAbs(  :MODEL         , :EngTherm     , "thermodynamic model"                     , false)
mk1ParAbs(    :Heat        , :MODEL        , "specific heat models"                    , true )
mk1ParAbs(      :ConstHeat , :Heat         , "constant specific heat models"           , true )
mk1ParAbs(      :UnvarHeat , :Heat         , "univariate specific heat models"         , true )
mk1ParAbs(      :BivarHeat , :Heat         , "bivariate specific heat models"          , true )
mk1ParAbs(    :Medium      , :MODEL        , "substance/medium models"                 , true )
mk1ParAbs(      :Substance , :Medium       , "substance model by Equation of State"    , true )
mk1ParAbs(    :System      , :MODEL        , "system models"                           , true )
mk1ParAbs(      :Closed    , :System       , "closed systems"                          , true )
mk1ParAbs(      :Open      , :System       , "open systems"                            , true )

# AUX branch
mkNonPAbs(  :AUX           , :EngTherm     , "ancillary EngTherm types"                       )
mkNonPAbs(    :AuxFunc     , :AUX          , "ancillary functions"                            )


