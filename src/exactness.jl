#----------------------------------------------------------------------------------------------#
#                        Unexported Type Aliases -- Shorter Signatures                         #
#----------------------------------------------------------------------------------------------#

const MEAS = Measurement
const QTTY = Quantity

#----------------------------------------------------------------------------------------------#
#                                        Type Exactness                                        #
#----------------------------------------------------------------------------------------------#

# Exact types: all type params are \bsans#<TAB>
ETY{𝗽,𝗱} = Union{QTTY{𝗽,𝗱}} where {𝗽<:PREC,𝗱}

# Measurement types
MTY{𝗽,𝗱} = Union{QTTY{MEAS{𝗽},𝗱}} where {𝗽<:PREC,𝗱}

# Therm Amount types
ATY{𝗽,𝗱} = Union{ETY{𝗽,𝗱},MTY{𝗽,𝗱}} where {𝗽<:PREC,𝗱}


#----------------------------------------------------------------------------------------------#
#                                        Auxiliar Types                                        #
#----------------------------------------------------------------------------------------------#

# The 4 type quadrants are:
#
#                  |    plain   united      |
#  ----------------+------------------------+
#   float-based    |    bareF   ATY{𝗽,𝗱}    |
#   non-float reals|    bareR   unitR       |

# REAL: plain Julia Reals other than `PREC` (since Unitful.Quantity <: Number)
REAL = Union{AbstractIrrational,Integer,Rational}

# Bare, unitless floats
bareF = Union{𝗽, MEAS{𝗽}} where 𝗽<:PREC

# Bare, unitless reals
bareR = Union{𝘁, MEAS{𝘁}} where 𝘁<:REAL

# Unit-ed reals
unitR = Union{QTTY{𝘁}, QTTY{MEAS{𝘁}}} where 𝘁<:REAL


