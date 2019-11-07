#----------------------------------------------------------------------------------------------#
#                        Unexported Type Aliases -- Shorter Signatures                         #
#----------------------------------------------------------------------------------------------#

const F16 = Float16
const F32 = Float32
const F64 = Float64
const BIG = BigFloat

const MEA = Measurement
const QTY = Quantity

#----------------------------------------------------------------------------------------------#
#                                        Type Exactness                                        #
#----------------------------------------------------------------------------------------------#

# \sansF<TAB>: plain Julia Floats (since Measurements.Measurement <: AbstractFloat)
𝖥 = Union{F16,F32,F64,BIG}

# Exact types: all type params are \bsans#<TAB>
EXT{𝘁} = QTY{𝘁} where 𝘁<:𝖥

# Measurement types
MMT{𝘁} = QTY{MEA{𝘁}} where 𝘁<:𝖥

# θ Quantity types
AMT{𝘁} = Union{EXT{𝘁},MMT{𝘁}} where 𝘁<:𝖥


#----------------------------------------------------------------------------------------------#
#                                        Auxiliar Types                                        #
#----------------------------------------------------------------------------------------------#

# The 4 type quadrants are:
# -------------------------
#   bareF   AMT{𝘁}  | float-based
#   bareR   unitR   | non-float reals
#   -----------------
#   plain   united

# \sansR<TAB>: plain Julia Reals (since Unitful.Quantity <: Number)
𝖱 = Union{AbstractIrrational,Integer,Rational}

# Bare, unitless floats
bareF = Union{𝘁, MMT{𝘁}} where 𝘁<:𝖥

# Bare, unitless reals
bareR = Union{𝘁, MMT{𝘁}} where 𝘁<:𝖱

# United reals
unitR = Union{QTY{𝘁}, QTY{MMT{𝘁}}} where 𝘁<:𝖱


