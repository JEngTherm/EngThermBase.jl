#----------------------------------------------------------------------------------------------#
#                                    Abstract Type Factory                                     #
#----------------------------------------------------------------------------------------------#

"""
`function tyArchy(t::Union{DataType,UnionAll})`\n
Returns a string suitable for documenting the hierarchy of an abstract type.
"""
function tyArchy(t::Union{DataType,UnionAll})
    h = Any[t]; while h[end] != Any; append!(h, [supertype(h[end])]); end
    H = Tuple(string(nameof(i)) for i in h)
    join(H, " <: ")
end

"""
`function mkNonPAbs(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)`\n
Declares exactly one new, non-parametric, abstract type `TY <: TP`. Argument `what` is inserted
in the new type documentation, and `xp` controls whether or not the new abstract type is
exported (default `true`).
"""
function mkNonPAbs(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)
    if !(eval(TP) isa DataType)
        error("Type parent must be a DataType. Got $(string(TP)).")
    end
    hiStr = tyArchy(eval(TP))
    dcStr = """
`abstract type $(TY) <: $(TP) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    @eval begin
        # Abstract type definition
        abstract type $TY <: $TP end
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end

"""
`function mk1ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, pp::Integer=1,
xp::Bool=true)`\n
Declares a new, 1-parameter abstract type. Parent type parameter count is a function of `pp`, so
that declarations are as follows:\n
- `TY{𝗽} <: TP{𝗽}` for `pp >= 1` (default);
- `TY{𝗽} <: TP` for `pp <= 0`.\n
Argument `what` is inserted in the new type documentation, and `xp` controls whether or not the
new abstract type is exported (default `true`).
"""
function mk1ParAbs(TY::Symbol, TP::Symbol, what::AbstractString,
                   pp::Integer=1, xp::Bool=true)
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    ppSrt = pp>=1 ? "{𝗽}" : ""
    dcStr = """
`abstract type $(TY){𝗽,𝘅} <: $(TP)$(ppStr) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if      pp>=1   @eval (abstract type $TY{𝗽} <: $TP{𝗽} end)
    elseif  pp<=0   @eval (abstract type $TY{𝗽} <: $TP end)
    end
    @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end

"""
`function mk2ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, pp::Integer=2,
xp::Bool=true)`\n
Declares a new, 2-parameter abstract type. Parent type parameter count is a function of `pp`, so
that declarations are as follows:\n
- `TY{𝗽,𝘅} <: TP{𝗽,𝘅}` for `pp >= 2` (default);
- `TY{𝗽,𝘅} <: TP{𝗽}` for `pp = 1`;
- `TY{𝗽,𝘅} <: TP` for `pp <= 0`.\n
Argument `what` is inserted in the new type documentation, and `xp` controls whether or not the
new abstract type is exported (default `true`).
"""
function mk2ParAbs(TY::Symbol, TP::Symbol, what::AbstractString,
                   pp::Integer=2, xp::Bool=true)
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    ppSrt = pp>=2 ? "{𝗽,𝘅}" : pp==1 ? "{𝗽}" : ""
    dcStr = """
`abstract type $(TY){𝗽,𝘅} <: $(TP)$(ppStr) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if      pp>=2   @eval (abstract type $TY{𝘁,𝗽} <: $TP{𝘁,𝗽} end)
    elseif  pp==1   @eval (abstract type $TY{𝘁,𝗽} <: $TP{𝘁} end)
    elseif  pp<=0   @eval (abstract type $TY{𝘁,𝗽} <: $TP end)
    end
    @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end

"""
`function mk3ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, pp::Integer=3,
xp::Bool=true)`\n
Declares a new, 3-parameter abstract type. Parent type parameter count is a function of `pp`, so
that declarations are as follows:\n
- `TY{𝗽,𝘅,𝗯} <: TP{𝗽,𝘅,𝗯}` for `pp >= 3` (default);
- `TY{𝗽,𝘅,𝗯} <: TP{𝗽,𝘅}` for `pp == 2`;
- `TY{𝗽,𝘅,𝗯} <: TP{𝗽}` for `pp = 1`;
- `TY{𝗽,𝘅,𝗯} <: TP` for `pp <= 0`.\n
Argument `what` is inserted in the new type documentation, and `xp` controls whether or not the
new abstract type is exported (default `true`).
"""
function mk3ParAbs(TY::Symbol, TP::Symbol, what::AbstractString,
                   pp::Integer=3, xp::Bool=true)
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    ppSrt = pp>=3 ? "{𝗽,𝘅,𝗯}" : pp==2 ? "{𝗽,𝘅}" : pp==1 ? "{𝗽}" : ""
    dcStr = """
`abstract type $(TY){𝗽,𝘅,𝗯} <: $(TP)$(ppStr) end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if      pp>=3   @eval (abstract type $TY{𝗽,𝘅,𝗯} <: $TP{𝗽,𝘅,𝗯} end)
    elseif  pp==2   @eval (abstract type $TY{𝗽,𝘅,𝗯} <: $TP{𝗽,𝘅} end)
    elseif  pp==1   @eval (abstract type $TY{𝗽,𝘅,𝗯} <: $TP{𝗽} end)
    elseif  pp<=0   @eval (abstract type $TY{𝗽,𝘅,𝗯} <: $TP end)
    end
    @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end


#----------------------------------------------------------------------------------------------#
#                               Singleton Concrete Type Factory                                #
#----------------------------------------------------------------------------------------------#

"""
`function mkSingleTy(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)`\n
Declares a new, non-parametric, singleton, concrete type `TY <: TP`. Argument `what` is inserted
in the new type documentation, and `xp` controls whether or not the new singleton type is
exported (default `true`).
"""
function mkSingleTy(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)
    if !(eval(TP) isa DataType)
        error("Type parent must be a DataType. Got $(string(TP)).")
    end
    hiStr = tyArchy(eval(TP))
    dcStr = """
`struct $(TY) <: $(TP) end`\n
Singleton type for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    @eval begin
        # Singleton type definition
        struct $TY <: $TP end
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end


