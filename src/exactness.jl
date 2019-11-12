# Plain Float Type Unions
# -----------------------

"""
`PMTY{𝗽} = Union{Measurement{𝗽}} where 𝗽<:Union{Float16,Float32,Float64,BigFloat}`\n
𝗣lain 𝗠easurement 𝗧𝗬pe: Plain (unitless) `Measurement`s.
"""
PMTY{𝗽} = Union{Measurement{𝗽}} where 𝗽<:PREC


# United Float Type Unions
# ------------------------

"""
`UETY{𝗽,𝗱,𝘂} = Union{Quantity{𝗽,𝗱,𝘂}} where {𝗽<:PREC,𝗱,𝘂}`\n
𝗨nited 𝗘xact 𝗧𝗬pe: `PREC`ision-parametric united `Quantity`(ie)s.
"""
UETY{𝗽,𝗱,𝘂} = Union{Quantity{𝗽,𝗱,𝘂}} where {𝗽<:PREC,𝗱,𝘂}

"""
`UMTY{𝗽,𝗱,𝘂} = Union{Quantity{Measurement{𝗽},𝗱,𝘂}} where {𝗽<:PREC,𝗱,𝘂}`\n
𝗨nited 𝗠easurement 𝗧𝗬pe: `PREC`ision-parametric, `Measurement` united `Quantity`(ie)s.
"""
UMTY{𝗽,𝗱,𝘂} = Union{Quantity{Measurement{𝗽},𝗱,𝘂}} where {𝗽<:PREC,𝗱,𝘂}

"""
`UATY{𝗽,𝗱,𝘂} = Union{UETY{𝗽,𝗱,𝘂},UMTY{𝗽,𝗱,𝘂}} where {𝗽<:PREC,𝗱,𝘂}`
𝗨nited 𝗔mount 𝗧𝗬pe: `PREC`ision and `EXAC`tness-parametric, united `Quantity`(ie)s — the default
underlying data type for `EngTherm` `AMOUNTS`.
"""
UATY{𝗽,𝗱,𝘂} = Union{UETY{𝗽,𝗱,𝘂},UMTY{𝗽,𝗱,𝘂}} where {𝗽<:PREC,𝗱,𝘂}


#----------------------------------------------------------------------------------------------#
#                                        Auxiliar Types                                        #
#----------------------------------------------------------------------------------------------#

# The 4 type quadrants are:
#
#                  |    plain       united      |
#  ----------------+----------------------------+
#   float-based    |    plnF{𝗽}     UATY{𝗽,𝗱,𝘂} |
#   non-float reals|    plnR{𝘁}     uniR{𝘁,𝗱,𝘂} |

# REAL: plain Julia Reals other than `PREC` (since Unitful.Quantity <: Number)
REAL = Union{AbstractIrrational,Integer,Rational}

# Plain, unitless floats
plnF{𝗽} = Union{𝗽, Measurement{𝗽}} where 𝗽<:PREC

# Plain, unitless non-float reals
plnR{𝘁} = Union{𝘁, Measurement{𝘁}} where 𝘁<:REAL

# Unit-ed reals
uniR{𝘁,𝗱,𝘂} = Union{Quantity{𝘁,𝗱,𝘂}, Quantity{Measurement{𝘁},𝗱,𝘂}} where {𝘁<:REAL,𝗱,𝘂}


#----------------------------------------------------------------------------------------------#
#                                   Raw Quantity Constructor                                   #
#----------------------------------------------------------------------------------------------#

# Dimensionless and Unitless constants
const DLESS = NoDims
const ULESS = Unitful.FreeUnits{(),NoDims,nothing}

# Adapted from https://github.com/PainterQubits/Unitful.jl/issues/283#issuecomment-552285299
_qty(x::𝗽) where 𝗽<:PREC = Quantity{𝗽, DLESS, ULESS}(x)
_qty(x::UETY{𝗽,𝗱,𝘂}) where {𝗽,𝗱,𝘂} = Quantity{𝗽,𝗱,𝘂}(x)
_qty(x::UMTY{𝗽,𝗱,𝘂}) where {𝗽,𝗱,𝘂} = Quantity{Measurement{𝗽},𝗱,𝘂}(x)


#----------------------------------------------------------------------------------------------#
#                                        Promote Rules                                         #
#----------------------------------------------------------------------------------------------#

import Base: promote_rule

promote_rule(::Type{EX}, ::Type{EX}) = EX
promote_rule(::Type{EX}, ::Type{MM}) = MM
promote_rule(::Type{MM}, ::Type{EX}) = MM
promote_rule(::Type{MM}, ::Type{MM}) = MM


