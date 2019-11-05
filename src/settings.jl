#----------------------------------------------------------------------------------------------#
#                                       Package Defaults                                       #
#----------------------------------------------------------------------------------------------#

# This file is included right after abstract type definitions, and before anything else,
# therefore, only abstract types must initialize the `DEF` dictionary. Package defaults' purpose
# is different from that of package / thermodynamics constants (see constants.jl), which is
# included after thermodynamic amounts are defined.

"""
`const DEF = Dict{Symbol,Type{𝘁} where 𝘁<:AbstractThermodynamics}(...)`\n
Package defaults: a dictionary of `{Symbol,Type{𝘁} where 𝘁<:AbstractThermodynamics}` pairs.\n
"""
const DEF = Dict{Symbol,Type{𝘁} where 𝘁<:AbstractThermodynamics}(
    :IB     => MA,      # Default Intensive Base
    :EB     => SY,      # Default Extensive Base
    :XB     => EX,      # Default Exactness Base
)

export DEF


