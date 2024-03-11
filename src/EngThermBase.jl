# Module
module EngThermBase

# Imports
using Reexport
@reexport using Unitful
@reexport using Measurements

# Includes - abstract supertypes
include("abstract.jl")

# Includes - default settings
include("settings.jl")

# Includes - type exactness
include("exactness.jl")

# Includes - concrete types
include("amounts.jl")
include("operations.jl")
include("constants.jl")
include("combos.jl")

# Includes - data libraries
include("lib/moleculeTokenizer.jl")     # For molecule parsing
include("lib/atoM.jl")                  # Selected Elements' atomic masses

# Module
end
