#----------------------------------------------------------------------------------------------#
#                                       Package Defaults                                       #
#----------------------------------------------------------------------------------------------#

"""
`const DEF = Dict{Symbol,Any}(...)`\n
`EngThermBase` defaults\n
"""
const DEF = Dict{Symbol,Any}(
    # --- Bases
    :IB         => MA,      # Default Intensive Base
    :EB         => SY,      # Default Extensive Base
    :XB         => EX,      # Default Exactness Base
    # --- Print formatting
    :pprint     => true,    # Whether to pretty-print AMOUNTS
    :showPrec   => true,    # Whether to Base.show the Precision of AMOUNTS
    :showSigD   => 5,       # Significant digits for Base.show of AMOUNTS
)

export DEF


