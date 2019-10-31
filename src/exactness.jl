#----------------------------------------------------------------------------------------------#
#                                        Type Exactness                                        #
#----------------------------------------------------------------------------------------------#

# Imports
using Measurements: Measurement
using Intervals: Interval
using Unitful: Quantity


#----------------------------------------------------------------------------------------------#
#                                  Exactness Type Definitions                                  #
#----------------------------------------------------------------------------------------------#

# Precision: plain Julia AbstractFloats **BEFORE** importing Measurements
FLO = Union{Float16,Float32,Float64,BigFloat}

# Exact types
ETY{𝘁} = Union{Quantity{𝘁}} where 𝘁<:FLO

## ```julia-repl
## julia> typeof(measurement(0.1u"m", 0.01u"m"))
## Quantity{Measurement{Float64},𝐋,Unitful.FreeUnits{(m,),𝐋,nothing}}
## 
## julia> typeof(Interval(0.1u"m", 0.01u"m"))
## Interval{Quantity{Float64,𝐋,Unitful.FreeUnits{(m,),𝐋,nothing}}}
## ```

# Measurement types
MTY{𝘁} = Union{Quantity{Measurement{𝘁}}} where 𝘁<:FLO

# Interval types
ITY{𝘁} = Union{Interval{Quantity{𝘁}}} where 𝘁<:FLO

# Thermodynamic quantity
QTY{𝘁} = Union{ETY{𝘁},MTY{𝘁},ITY{𝘁}} where 𝘁<:FLO

## ```julia-repl
## julia> 0.1u"m" isa QTY{Float64}
## true
## 
## julia> measurement(0.1f0, 0.01f0)u"m" isa QTY{Float32}
## true
## 
## julia> Interval(0.1f0u"m", 0.2f0u"m") isa QTY{Float32}
## false
## ```

# TODO: ditch Intervals, since it doesn't play well with others?


