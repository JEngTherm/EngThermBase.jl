#----------------------------------------------------------------------------------------------#
#                                    Abstract Type Factory                                     #
#----------------------------------------------------------------------------------------------#

function tyArchy(t::Union{DataType,UnionAll})
    h = Any[t]; while h[end] != Any; append!(h, [supertype(h[end])]); end
    H = Tuple(string(nameof(i)) for i in h)
    join(H, " <: ")
end

function mkOneAbsTy(TY::Symbol, TP::Symbol, what::AbstractString, xp::Bool=true)
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

function mkParAbsTy(TY::Symbol, TP::Symbol, what::AbstractString,
                    pp::Bool=true, xp::Bool=true)
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


