#----------------------------------------------------------------------------------------------#
#                                        Type Exactness                                        #
#----------------------------------------------------------------------------------------------#

# \sansF<TAB>: plain Julia Floats (since Measurements.Measurement <: AbstractFloat)
𝖥 = Union{Float16,Float32,Float64,BigFloat}

# Exact types: all type params are \bsans#<TAB>
ETY{𝘁} = Quantity{𝘁} where 𝘁<:𝖥

# Measurement types
MTY{𝘁} = Quantity{Measurement{𝘁}} where 𝘁<:𝖥

# θ Quantity types
QTY{𝘁} = Union{ETY{𝘁},MTY{𝘁}} where 𝘁<:𝖥


#----------------------------------------------------------------------------------------------#
#                                        Auxiliar Types                                        #
#----------------------------------------------------------------------------------------------#

# The 4 type quadrants are:
# -------------------------
#   bareF   QTY{𝘁}  | float-based
#   bareR   unitR   | non-float reals
#   -----------------
#   plain   united

# \sansR<TAB>: plain Julia Reals (since Unitful.Quantity <: Number)
𝖱 = Union{AbstractIrrational,Integer,Rational}

# Bare, unitless floats
bareF = Union{𝘁, Measurement{𝘁}} where 𝘁<:𝖥

# Bare, unitless reals
bareR = Union{𝘁, Measurement{𝘁}} where 𝘁<:𝖱

# United reals
unitR = Union{Quantity{𝘁}, Quantity{Measurement{𝘁}}} where 𝘁<:𝖱


