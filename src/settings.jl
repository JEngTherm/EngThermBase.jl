#----------------------------------------------------------------------------------------------#
#                                       Package Defaults                                       #
#----------------------------------------------------------------------------------------------#

"""
`const DEF = Dict{Symbol,Type{𝘁} where 𝘁<:EngTherm}(...)`\n
`EngThermBase` defaults: a dictionary of `{Symbol,Type{𝘁} where 𝘁<:EngTherm}` pairs.\n
"""
const DEF = Dict{Symbol,Type{𝘁} where 𝘁<:EngTherm}(
    :IB     => MA,      # Default Intensive Base
    :EB     => SY,      # Default Extensive Base
    :XB     => EX,      # Default Exactness Base
)

export DEF


