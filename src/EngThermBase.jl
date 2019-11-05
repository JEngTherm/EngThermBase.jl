# Module
module EngThermBase

# Includes - abstract types
include("factory.jl")
include("abstract.jl")

# Includes - default settings
include("settings.jl")

# Includes - type exactness
include("exactness.jl")

# Includes - concrete types
include("amounts.jl")
## include("states.jl")
## include("constants.jl")

# Includes - functionalities
include("utils.jl")

# Module
end
