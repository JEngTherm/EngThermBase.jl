#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                      Abstract Thermodynamics Abstract Type Definitions                                                       #
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#

# AbstractThermodynamics root abstract type
mkOneAbsTy(:AbstractThermodynamics              , :Any                          , "thermodynamic entities"                                              )

# AbstractBase branch
mkOneAbsTy(  :AbstractBase                      , :AbstractThermodynamics       , "quantity bases"                                                      )
mkOneAbsTy(    :ThermodynamicBase               , :AbstractBase                 , "thermodynamic bases"                                                 )
mkOneAbsTy(      :intensiveBase                 , :ThermodynamicBase            , "intensive bases"                                                     )
mkOneAbsTy(        :MA                          , :intensiveBase                , "the MAss base"                                                       )
mkOneAbsTy(        :MO                          , :intensiveBase                , "the MOlar base"                                                      )
mkOneAbsTy(      :extensiveBase                 , :ThermodynamicBase            , "non-intensive bases"                                                 )
mkOneAbsTy(        :SY                          , :extensiveBase                , "the SYstem (extensive) base"                                         )
mkOneAbsTy(        :DT                          , :extensiveBase                , "the Time Derivative (rate) base"                                     )
mkOneAbsTy(    :exactnessBase                   , :AbstractBase                 , "type-exactness bases"                                                )
mkOneAbsTy(      :EX                            , :exactnessBase                , "the EXact base"                                                      )
mkOneAbsTy(      :MM                            , :exactnessBase                , "the MeasureMent base"                                                )

# AbstractAmount branch
mkParAbsTy(  :AbstractAmount                    , :AbstractThermodynamics       , "thermodynamic amount"                                        , false )
mkParAbsTy(    :Property                        , :AbstractAmount               , "thermodynamic properties"                                    , true  )
mkParAbsTy(      :Intrinsic                     , :Property                     , "intrinsic intensive properties"                              , true  )
mkParAbsTy(    :Interaction                     , :AbstractAmount               , "thermodynamic interations"                                   , true  )
mkParAbsTy(    :UnrankedAmount                  , :AbstractAmount               , "unranked amounts"                                            , true  )

# AbstractState branch
mkParAbsTy(  :AbstractState                     , :AbstractThermodynamics       , "state types"                                                 , false )
mkParAbsTy(    :ConceptualState                 , :AbstractState                , "conceptual states, or propery pairs/groups"                  , true  )

# AbstractModel branch
mkParAbsTy(  :AbstractModel                     , :AbstractThermodynamics       , "thermodynamic model"                                         , false )
mkParAbsTy(    :SpHeatModel                     , :AbstractModel                , "specific heat models"                                        , true  )
mkParAbsTy(      :ConstSpHeatModel              , :SpHeatModel                  , "zero-variate (constant) specific heat models"                , true  )
mkParAbsTy(      :UnvarSpHeatModel              , :SpHeatModel                  , "ideal gas univariate (T) specific heat models"               , true  )
mkParAbsTy(      :BivarSpHeatModel              , :SpHeatModel                  , "general bivariate, e.g., (T, v), specific heat models"       , true  )
mkParAbsTy(    :MediumModel                     , :AbstractModel                , "substance/medium models"                                     , true  )
mkParAbsTy(      :SubstanceModel                , :MediumModel                  , "substance model by Equation of State (EoS)"                  , true  )
mkParAbsTy(    :SystemModel                     , :AbstractModel                , "system models"                                               , true  )
mkParAbsTy(      :ClosedSystem                  , :SystemModel                  , "closed systems"                                              , true  )
mkParAbsTy(      :OpenSystem                    , :SystemModel                  , "open systems"                                                , true  )

# AbstractAncillary branch
mkOneAbsTy(  :AbstractAncillary                 , :AbstractThermodynamics       , "ancillary types"                                                     )
mkOneAbsTy(    :AncillaryFunction               , :AbstractAncillary            , "ancillary functions"                                                 )


#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                     Abstract Type Unions                                                                     #
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#

# AbstractAmount Type Unions
nonProperty         = Union{Interaction,UnrankedAmount}

export nonProperty


