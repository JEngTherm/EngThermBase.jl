#----------------------------------------------------------------------------------------------#
#                                        Type Exactness                                        #
#----------------------------------------------------------------------------------------------#

# Imports
using Measurements: Measurement
using Unitful: Quantity


#----------------------------------------------------------------------------------------------#
#                                  Exactness Type Definitions                                  #
#----------------------------------------------------------------------------------------------#

# Precision: plain Julia AbstractFloats **BEFORE** importing Measurements
FLO = Union{Float16,Float32,Float64,BigFloat}

# Exact types
ETY{𝘁} = Quantity{𝘁} where 𝘁<:FLO

# Measurement types
MTY{𝘁} = Quantity{Measurement{𝘁}} where 𝘁<:FLO

# θ Quantity types
QTY{𝘁} = Union{ETY{𝘁},MTY{𝘁}} where 𝘁<:FLO


