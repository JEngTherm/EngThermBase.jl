#----------------------------------------------------------------------------------------------#
#                                       Package Defaults                                       #
#----------------------------------------------------------------------------------------------#

"""
`const DEF = Dict{Symbol,Any}(...)`\n
`EngThermBase` defaults\n
"""
const DEF = Dict{Symbol,Any}(
    :IB         => MA,      # Default Intensive Base
    :EB         => SY,      # Default Extensive Base
    :XB         => EX,      # Default Exactness Base
    :showPrec   => true,    # Whether to Base.show the Precision
    :showExac   => false,   # Whether to Base.show the Exactness
    :showBase   => false,   # Whether to Base.show the ThermBase
)

export DEF


