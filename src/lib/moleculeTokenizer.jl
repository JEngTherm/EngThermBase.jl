#----------------------------------------------------------------------------------------------#
#             Simple Molecule Tokenizer for splitting a molecule into its Elements             #
#----------------------------------------------------------------------------------------------#

#······························································································#
#                                          Constants                                           #
#······························································································#

# Thanks to pi.ai for avoiding the tedious typing
# Chemical element symbols as julia symbols
elemSymb = (
    :H,  :He, :Li, :Be, :B,  :C,  :N,  :O,  :F,  :Ne, :Na, :Mg, :Al, :Si, :P,  :S,  :Cl, :Ar,
    :K,  :Ca, :Sc, :Ti, :V,  :Cr, :Mn, :Fe, :Co, :Ni, :Cu, :Zn, :Ga, :Ge, :As, :Se, :Br, :Kr,
    :Rb, :Sr, :Y,  :Zr, :Nb, :Mo, :Tc, :Ru, :Rh, :Pd, :Ag, :Cd, :In, :Sn, :Sb, :Te, :I,  :Xe,
    :Cs, :Ba, :La, :Ce, :Pr, :Nd, :Pm, :Sm, :Eu, :Gd, :Tb, :Dy, :Ho, :Er, :Tm, :Yb, :Lu, :Hf,
    :Ta, :W,  :Re, :Os, :Ir, :Pt, :Au, :Hg, :Tl, :Pb, :Bi, :Po, :At, :Rn, :Fr, :Ra, :Ac, :Th,
    :Pa, :U,  :Np, :Pu, :Am, :Cm, :Bk, :Cf, :Es, :Fm, :Md, :No, :Lr, :Rf, :Db, :Sg, :Bh, :Hs,
    :Mt, :Ds, :Rg, :Cn, :Nh, :Fl, :Mc, :Lv, :Ts, :Og,
)

# Chemical element symbols as strings
elemStr = Tuple(collect(String(i) for i in elemSymb))


#······························································································#
#                                     Molecule Token Types                                     #
#······························································································#

molecTokenTypes = (
    INVALID = UInt8(0),
    STREND  = UInt8(1),
    ELEMENT = UInt8(2),
    AMOUNT  = UInt8(3),
    OPAREN  = UInt8(4),
    CPAREN  = UInt8(5),
)

struct moleculeToken
    tokenType::UInt8
    tokenText::String
    moleculeToken(typ::Integer, txt::AbstractString) = begin
        @assert typ >= 0
        @assert typ <= max(values(molecTokenTypes)...)
        new(UInt8(typ), String(txt))
    end
end


#······························································································#
#                                          Constants                                           #
#······························································································#

digits = "0123456789"
decsep = "."
regnum = digits * decsep
chSym1 = join(sort([ Set([i[1] for i in elemStr])... ]))
chSymb = join(sort([ Set(join(elemStr))... ]))


#······························································································#
#                                      Molecule Tokenizer                                      #
#······························································································#

"""
`nxtToken(txt::AbstractString)::moleculeToken`\n
Returns a single token from the head of the non-empty `txt`.
"""
function nxtToken(txt::AbstractString)::moleculeToken
    len = length(txt)
    (len == 0) && (return moleculeToken(molecTokenTypes.STREND, ""))
    if txt[1] == '('
        return moleculeToken(molecTokenTypes.OPAREN, "(")
    elseif txt[1] == ')'
        return moleculeToken(molecTokenTypes.CPAREN, ")")
    end
    pos, cnt, sep = 1, 1, 0
    if txt[pos] in regnum
        # Scan for regular number
        sep = sep + (txt[pos] in decsep ? 1 : 0)
        pos = nextind(txt, pos)
        while (cnt < len) && (txt[pos] in regnum)
            cnt += 1
            sep = sep + (txt[pos] in decsep ? 1 : 0)
            pos = nextind(txt, pos)
        end
        pos = prevind(txt, pos)
        return sep > 1 ?
            moleculeToken(molecTokenTypes.INVALID, txt[1:pos]) :
            moleculeToken(molecTokenTypes.AMOUNT, txt[1:pos])
    else
        # Scan for chemical element symbol
        if len >= 2
            pos = nextind(txt, pos)
            if txt[1:pos] in elemStr
                return moleculeToken(molecTokenTypes.ELEMENT, txt[1:pos])
            elseif txt[1:1] in elemStr
                return moleculeToken(molecTokenTypes.ELEMENT, txt[1:1])
            else
                return moleculeToken(molecTokenTypes.INVALID, txt[1:1])
            end
        else
            if txt[1:1] in elemStr
                return moleculeToken(molecTokenTypes.ELEMENT, txt[1:1])
            else
                return moleculeToken(molecTokenTypes.INVALID, txt[1:1])
            end
        end
    end
end

"""
`tokenize(txt::AbstractString)::Vector{moleculeToken}`\n
Tokenizes until an EOS is reached.
"""
function tokenize(txt::AbstractString)::Vector{moleculeToken}
    ret = moleculeToken[]
    stop = (molecTokenTypes.STREND, )
    while (length(ret) == 0) || !(ret[end].tokenType in stop)
        ret = append!(ret, [nxtToken(txt)])
        txt = txt[sizeof(ret[end].tokenText)+1:end]
    end
    # Merge consecutive INVALIDs
    RET = moleculeToken[]
    BUF = ""
    for 𝓉 in ret
        if 𝓉.tokenType == molecTokenTypes.INVALID
            BUF *= 𝓉.tokenText
        else
            if length(BUF) > 0
                RET = append!(RET, [moleculeToken(molecTokenTypes.INVALID, BUF)])
                BUF = ""
            end
            RET = append!(RET, [𝓉])
        end
    end
    return RET
end


#----------------------------------------------------------------------------------------------#
#                                       Molecule Parsing                                       #
#----------------------------------------------------------------------------------------------#

#······························································································#
#                                      Molecule DataType                                       #
#······························································································#


"""
`struct Molecule`\n
Auxiliary `Molecule` data type with a `data::Dict{Symbol,Real}` data member.
Inner constructor makes sure `Symbol` keys are chemical element symbols.
"""
struct Molecule
    data::Dict{Symbol,Real}
    Molecule(d::Dict{Symbol,<:Real}) = begin
        D = Dict{Symbol, Real}(
            k => v for (k, v) in
                zip(keys(d), values(d)) if
                    k in elemSymb
        )
        new(D)
    end
end

import Base: +, -, *, /

+(x::Molecule, y::Molecule) = begin
    xkeys, xdata = keys(x.data), x.data
    ykeys, ydata = keys(y.data), y.data
    K = sort([ Set([xkeys..., ykeys...])... ])
    RET = Dict{Symbol,Real}()
    for k in K
        v  = k in xkeys ? xdata[k] : 0.0
        v += k in ykeys ? ydata[k] : 0.0
        RET[k] = v
    end
    return Molecule(RET)
end

-(x::Molecule, y::Molecule) = begin
    xkeys, xdata = keys(x.data), x.data
    ykeys, ydata = keys(y.data), y.data
    K = sort([ Set([xkeys..., ykeys...])... ])
    RET = Dict{Symbol,Real}()
    for k in K
        v  = k in xkeys ? xdata[k] : 0.0
        v -= k in ykeys ? ydata[k] : 0.0
        if abs(v) > cbrt(eps(1.0))
            RET[k] = v
        end
    end
    return Molecule(RET)
end

*(x::Molecule, A::Real) = begin
    return Molecule(Dict{Symbol,Real}(
        k => A * v for (k, v) in zip(keys(x.data), values(x.data))
    ))
end

*(A::Real, x::Molecule) = x * A

/(x::Molecule, A::Real) = x * inv(A)


#······························································································#
#                                       Molecule Parser                                        #
#······························································································#

"""
`molParse(txt::AbstractString)::Molecule`\n
Parses the `txt` argument—something like "CH4", or "(CH3)2(CH2)6"—returning the corresponding
`Molecule` object. Bails out if `txt` contains invalid characters, and if all parentheses aren't
closed.
"""
function molParse(txt::AbstractString)::Molecule
    TOK = tokenize(txt)
    Tty = [ i.tokenType for i in TOK ]
    @assert !(molecTokenTypes.INVALID in TOK)
    @assert count(==(molecTokenTypes.OPAREN), Tty) ==
            count(==(molecTokenTypes.CPAREN), Tty)
    # Algorithm
    lvl = 1
    MUL = Dict(lvl => 1.0, )
    ACC = Dict(lvl => Molecule[], )
    for 𝓉 in TOK
        if 𝓉.tokenType == molecTokenTypes.AMOUNT
            if length(ACC[lvl]) == 0
                # Pre multiplication setup
                MUL[lvl] *= parse(Float64, 𝓉.tokenText)
            else
                # Post-multiplication
                ACC[lvl][end] *= parse(Float64, 𝓉.tokenText)
            end
        end
        if 𝓉.tokenType == molecTokenTypes.ELEMENT
            𝒟 = Dict(Symbol(𝓉.tokenText) => 1.0)
            ACC[lvl] = append!(ACC[lvl], [Molecule(𝒟)])
        end
        if 𝓉.tokenType == molecTokenTypes.OPAREN
            lvl += 1
            !(lvl in keys(MUL)) && (MUL[lvl] = 1.0)
            !(lvl in keys(ACC)) && (ACC[lvl] = Molecule[])
        end
        if 𝓉.tokenType == molecTokenTypes.CPAREN
            # Pre-multiplication
            if MUL[lvl] != 1.0
                ACC[lvl] = MUL[lvl] .* ACC[lvl]
            end
            # Aglomeration & level reset
            ACC[lvl-1] = append!(ACC[lvl-1], [reduce(+, ACC[lvl])])
            MUL[lvl] = 1.0
            ACC[lvl] = Molecule[]
            lvl -= 1
        end
        if 𝓉.tokenType == molecTokenTypes.STREND
            if MUL[lvl] != 1.0
                ACC[lvl] = MUL[lvl] .* ACC[lvl]
            end
        end
    end
    return reduce(+, ACC[lvl])
end

export molParse


#----------------------------------------------------------------------------------------------#
#                                   Molecule Molecular Mass                                    #
#----------------------------------------------------------------------------------------------#

"""
`m_(𝑀::Molecule, 𝑚::NamedTuple = atoM)::m_amt{𝕡,𝕩,MO} where {𝕡,𝕩}`\n
"""
m_(𝑀::Molecule, 𝑚::NamedTuple = atoM)::m_amt{𝕡,𝕩,MO} where {𝕡,𝕩} = begin
    rndKey = keys(𝑚)[1]
    𝕡 = precof(𝑚[rndKey])
    𝕩 = exacof(𝑚[rndKey])
    return 𝕩 == MM ?
        sum([ Measurement{𝕡}(𝑀.data[k]) * 𝑚[k] for k in keys(𝑀.data) ]) :
        sum([              𝕡(𝑀.data[k]) * 𝑚[k] for k in keys(𝑀.data) ])
end


