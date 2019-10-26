#----------------------------------------------------------------------------------------------#
#                                       typeTree utility                                       #
#----------------------------------------------------------------------------------------------#

using InteractiveUtils: subtypes

function typeTree(t::Type, pref=("",); uni=true, concrete=false)
    ret = Array{String,1}()
    ELL, FRK, BAR = uni ? (" └─ ", " ├─ ", " │  ") : (" \\-- ", " +-- ", " |  ")
    SPC = "    "
    LEN = length(pref) - 1
    PREF = LEN > 0 ? ( i == ELL ? SPC : i == FRK ? BAR : i for i in pref[1:LEN]) : ("",)
    append!(ret, ["$(join((PREF..., pref[end])))$(t)\n"])
    ST = subtypes(t)
    LE = length(ST)
    for i in 1:LE
        if isabstracttype(ST[i]) || concrete
            append!(ret, typeTree(ST[i],
                                  (pref..., i < LE ? FRK : ELL),
                                  uni=uni,
                                  concrete=concrete))
        end
    end
    ret
end

export typeTree


