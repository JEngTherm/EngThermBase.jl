#----------------------------------------------------------------------------------------------#
#                              Abstract EngTherm Type Definitions                              #
#----------------------------------------------------------------------------------------------#

# EngTherm root abstract type
mkOneAbsTy(:EngTherm        , :Any          , "thermodynamic entities"                         )

# BASE branch
mkOneAbsTy(  :BASE          , :EngTherm     , "quantity bases"                                 )
mkOneAbsTy(    :ThermBase   , :BASE         , "thermodynamic bases"                            )
mkOneAbsTy(      :IntBase   , :ThermBase    , "intensive bases"                                )
mkOneAbsTy(        :MA      , :IntBase      , "the MAss base"                                  )
mkOneAbsTy(        :MO      , :IntBase      , "the MOlar base"                                 )
mkOneAbsTy(      :ExtBase   , :ThermBase    , "non-intensive bases"                            )
mkOneAbsTy(        :SY      , :ExtBase      , "the SYstem (extensive) base"                    )
mkOneAbsTy(        :DT      , :ExtBase      , "the Time Derivative (rate) base"                )
mkOneAbsTy(    :ExactBase   , :BASE         , "type-exactness bases"                           )
mkOneAbsTy(      :EX        , :ExactBase    , "the EXact base"                                 )
mkOneAbsTy(      :MM        , :ExactBase    , "the MeasureMent base"                           )

# AMOUNT branch
mkParAbsTy(  :AMOUNT        , :EngTherm     , "thermodynamic amount"                    , false)
mkParAbsTy(    :Property    , :AMOUNT       , "thermodynamic properties"                , true )
mkParAbsTy(      :Intrinsic , :Property     , "intrinsic intensive properties"          , true )
mkParAbsTy(    :Interaction , :AMOUNT       , "thermodynamic interations"               , true )
mkParAbsTy(    :Unranked    , :AMOUNT       , "unranked amounts"                        , true )

# STATE branch
mkParAbsTy(  :STATE         , :EngTherm     , "state types"                             , false)
mkParAbsTy(    :PropPair    , :STATE        , "propery pairs"                           , true )
mkParAbsTy(    :PropTrio    , :STATE        , "propery trios"                           , true )
mkParAbsTy(    :PropQuad    , :STATE        , "propery quads"                           , true )

# MODEL branch
mkParAbsTy(  :MODEL         , :EngTherm     , "thermodynamic model"                     , false)
mkParAbsTy(    :Heat        , :MODEL        , "specific heat models"                    , true )
mkParAbsTy(      :ConstHeat , :Heat         , "constant specific heat models"           , true )
mkParAbsTy(      :UnvarHeat , :Heat         , "univariate specific heat models"         , true )
mkParAbsTy(      :BivarHeat , :Heat         , "bivariate specific heat models"          , true )
mkParAbsTy(    :Medium      , :MODEL        , "substance/medium models"                 , true )
mkParAbsTy(      :Substance , :Medium       , "substance model by Equation of State"    , true )
mkParAbsTy(    :System      , :MODEL        , "system models"                           , true )
mkParAbsTy(      :Closed    , :System       , "closed systems"                          , true )
mkParAbsTy(      :Open      , :System       , "open systems"                            , true )

# AUX branch
mkOneAbsTy(  :AUX           , :EngTherm     , "ancillary EngTherm types"                       )
mkOneAbsTy(    :AuxFunc     , :AUX          , "ancillary functions"                            )


#----------------------------------------------------------------------------------------------#
#                                     Abstract Type Unions                                     #
#----------------------------------------------------------------------------------------------#

# AbstractAmount Type Unions
nonProperty         = Union{Interaction,UnrankedAmount}

export nonProperty


