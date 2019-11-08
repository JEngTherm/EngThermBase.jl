# Plain Float Type Unions
# -----------------------

"""
`PETY{𝗽} = Union{𝗽} where 𝗽<:Union{Float16,Float32,Float64,BigFloat}`\n
𝗣lain 𝗘xact 𝗧𝗬pe: Plain (unitless) Julia Floats.
"""
PETY{𝗽} = Union{𝗽} where 𝗽<:PREC

"""
`PMTY{𝗽} = Union{Measurement{𝗽}} where 𝗽<:Union{Float16,Float32,Float64,BigFloat}`\n
𝗣lain 𝗠easurement 𝗧𝗬pe: Plain (unitless) `Measurement`s.
"""
PMTY{𝗽} = Union{Measurement{𝗽}} where 𝗽<:PREC


# United Float Type Unions
# ------------------------

"""
`UETY{𝗽,𝗱} = Union{Quantity{𝗽,𝗱}} where {𝗽<:PREC,𝗱}`\n
𝗨nited 𝗘xact 𝗧𝗬pe: `PREC`ision-parametric united `Quantity`(ie)s.
"""
UETY{𝗽,𝗱} = Union{Quantity{𝗽,𝗱}} where {𝗽<:PREC,𝗱}

"""
`UMTY{𝗽,𝗱} = Union{Quantity{Measurement{𝗽},𝗱}} where {𝗽<:PREC,𝗱}`\n
𝗨nited 𝗠easurement 𝗧𝗬pe: `PREC`ision-parametric, `Measurement` united `Quantity`(ie)s.
"""
UMTY{𝗽,𝗱} = Union{Quantity{Measurement{𝗽},𝗱}} where {𝗽<:PREC,𝗱}

"""
`UATY{𝗽,𝗱} = Union{UETY{𝗽,𝗱},UMTY{𝗽,𝗱}} where {𝗽<:PREC,𝗱}`
𝗨nited 𝗔mount 𝗧𝗬pe: `PREC`ision and `EXAC`tness-parametric, united `Quantity`(ie)s — the default
underlying data type for `EngTherm` `AMOUNTS`.
"""
UATY{𝗽,𝗱} = Union{UETY{𝗽,𝗱},UMTY{𝗽,𝗱}} where {𝗽<:PREC,𝗱}


#----------------------------------------------------------------------------------------------#
#                                        Auxiliar Types                                        #
#----------------------------------------------------------------------------------------------#

# The 4 type quadrants are:
#
#                  |    plain   united      |
#  ----------------+------------------------+
#   float-based    |    bareF   UATY{𝗽,𝗱}   |
#   non-float reals|    bareR   unitR       |

# REAL: plain Julia Reals other than `PREC` (since Unitful.Quantity <: Number)
REAL = Union{AbstractIrrational,Integer,Rational}

# Bare, unitless floats
bareF = Union{𝗽, Measurement{𝗽}} where 𝗽<:PREC

# Bare, unitless reals
bareR = Union{𝘁, Measurement{𝘁}} where 𝘁<:REAL

# Unit-ed reals
unitR = Union{Quantity{𝘁}, Quantity{Measurement{𝘁}}} where 𝘁<:REAL


