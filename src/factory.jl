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
`function mk1ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, fpp::Bool=true,
xp::Bool=true)`\n
Declares a new, 1-parameter abstract type `TY{𝘁} <: TP{𝘁}`, if `fpp` (fully parametric parent)
is `true` (default), or `TY{𝘁} <: TP`, otherwise. Argument `what` is inserted in the new type
documentation, and `xp` controls whether or not the new abstract type is exported (default
`true`).
"""
function mk1ParAbs(TY::Symbol, TP::Symbol, what::AbstractString,
                   fpp::Bool=true, xp::Bool=true)
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    dcStr = """
`abstract type $(TY){𝘁} <: $(TP)$(pp ? "{𝘁}" : "") end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if pp
        @eval (abstract type $TY{𝘁} <: $TP{𝘁} end)  # 𝘁: U+1d601 or \bsanst<TAB> in julia REPL
    else
        @eval (abstract type $TY{𝘁} <: $TP end)
    end
    @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end

"""
`function mk2ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, fpp::Bool=true,
xp::Bool=true)`\n
Declares a new, 2-parameter abstract type `TY{𝗽,𝘅} <: TP{𝗽,𝘅}`, if `fpp` (fully parametric
parent) is `true` (default), or `TY{𝗽,𝘅} <: TP{𝗽}`, otherwise. Argument `what` is inserted in
the new type documentation, and `xp` controls whether or not the new abstract type is exported
(default `true`).
"""
function mk2ParAbs(TY::Symbol, TP::Symbol, what::AbstractString,
                   pp::Bool=true, xp::Bool=true)
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    dcStr = """
`abstract type $(TY){𝗽,𝘅} <: $(TP)$(pp ? "{𝗽,𝘅}" : "{𝗽}") end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if pp
        @eval (abstract type $TY{𝗽,𝘅} <: $TP{𝗽,𝘅} end)
    else
        @eval (abstract type $TY{𝗽,𝘅} <: $TP{𝗽} end)
    end
    @eval begin
        # Type documentation
        @doc $dcStr $TY
        # Type exporting
        if $(xp); export $TY; end
    end
end

"""
`function mk3ParAbs(TY::Symbol, TP::Symbol, what::AbstractString, fpp::Bool=true,
xp::Bool=true)`\n
Declares a new, 3-parameter abstract type `TY{𝗽,𝘅,𝗯} <: TP{𝗽,𝘅,𝗯}`, if `fpp` (fully parametric
parent) is `true` (default), or `TY{𝗽,𝘅,𝗯} <: TP{𝗽,𝘅}`, otherwise. Argument `what` is inserted
in the new type documentation, and `xp` controls whether or not the new abstract type is
exported (default `true`).
"""
function mk3ParAbs(TY::Symbol, TP::Symbol, what::AbstractString,
                   pp::Bool=true, xp::Bool=true)
    #if !(eval(TP) isa DataType)
    #    error("Type parent must be a DataType. Got $(string(TP)).")
    #end
    hiStr = tyArchy(eval(TP))
    dcStr = """
`abstract type $(TY){𝗽,𝘅,𝗯} <: $(TP)$(pp ? "{𝗽,𝘅,𝗯}" : "{𝗽,𝘅}") end`\n
Abstract supertype for $(what).\n
## Hierarchy\n
`$(TY) <: $(hiStr)`
    """
    if pp
        @eval (abstract type $TY{𝗽,𝘅,𝗯} <: $TP{𝗽,𝘅,𝗯} end)
    else
        @eval (abstract type $TY{𝗽,𝘅,𝗯} <: $TP{𝗽,𝘅} end)
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


