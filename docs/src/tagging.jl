# # Tagging (and Re-tagging)
# 
# This example illustrates the fundamental building block of `EngThermBase.jl`, which is
# engineerign thermodynamics quantities—herein denoted as `AMOUNTS` as not to confuse with
# [Unitful.jl](https://github.com/PainterQubits/Unitful.jl)'s `Quantity` unit'ed type.
# 
# First one loads the package:

using EngThermBase

# then, one can either use (i) an `AMOUNTS`'s type constructor, or (ii) it's corresponding
# function, or (iii) it's alias as to build a tagged amount:
# 
# ## Tagging with type constructors:
# 
# All `EngThermBase.jl` amount types are 5 ASCII characters long ending with "`amt`". For
# instance, the temperature type is `T_amt`:

T1 = T_amt(325u"K")     # This constructor checks and converts units if necessary
#-
T2 = T_amt(325)         # This constructor applies the type's default unit
#-
T1 == T2

# ## Tagging with the corresponding function:
# 
# A given amount type's corresponding function is named after the first 2 characters of a type
# name. The temperature, for instance, will be `T_`:

T3 = T_()               # The temp. function method without arguments returns the _stdT
#-
T4 = T_(40u"°C")        # This fallsback to the appropriate `T_amt` constructor

# ## Tagging with the function alias:
# 
# `EngThermBase.jl` amount function aliases are meant to render the code more readable (closer to
# mainstream engineering textbook notation) while using high- Unicode code-points (as to avoid
# polluting the variable space with one-letter functions.

T5 = 𝗧()                # \bsansT<tab>, identical to `T_()`
#-
T6 = 𝗧(40u"°C")         # Identical to `T_(40u"°C")`
#-
(T3 == T5, T4 == T6)


