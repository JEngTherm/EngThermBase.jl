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
    :showPrec   => true,    # Whether to Base.show the Precision of AMOUNTS
    :showSFmt   => "%.2f",  # String format for Base.show AMOUNTS
)

export DEF


