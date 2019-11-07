#----------------------------------------------------------------------------------------------#
#                        Unexported Type Aliases -- Shorter Signatures                         #
#----------------------------------------------------------------------------------------------#

const FL16 = Float16
const FL32 = Float32
const FL64 = Float64
const BIGF = BigFloat

const MEAS = Measurement
const QTTY = Quantity

#----------------------------------------------------------------------------------------------#
#                                        Type Exactness                                        #
#----------------------------------------------------------------------------------------------#

# \sansF<TAB>: plain Julia Floats (since Measurements.Measurement <: AbstractFloat)
𝖥 = Union{FL16,FL32,FL64,BIGF}

# Exact types: all type params are \bsans#<TAB>
ETY{𝘁} = QTTY{𝘁} where 𝘁<:𝖥

# Measurement types
MTY{𝘁} = QTTY{MEAS{𝘁}} where 𝘁<:𝖥

# θ Amount types
ATY{𝘁} = Union{ETY{𝘁},MTY{𝘁}} where 𝘁<:𝖥


#----------------------------------------------------------------------------------------------#
#                                        Auxiliar Types                                        #
#----------------------------------------------------------------------------------------------#

# The 4 type quadrants are:
# -------------------------
#   bareF   ATY{𝘁}  | float-based
#   bareR   unitR   | non-float reals
#   -----------------
#   plain   united

# \sansR<TAB>: plain Julia Reals (since Unitful.Quantity <: Number)
𝖱 = Union{AbstractIrrational,Integer,Rational}

# Bare, unitless floats
bareF = Union{𝘁, MEAS{𝘁}} where 𝘁<:𝖥

# Bare, unitless reals
bareR = Union{𝘁, MEAS{𝘁}} where 𝘁<:𝖱

# United reals
unitR = Union{QTTY{𝘁}, QTTY{MEAS{𝘁}}} where 𝘁<:𝖱


