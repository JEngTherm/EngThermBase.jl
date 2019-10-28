#----------------------------------------------------------------------------------------------#
#                                  Concrete Type Definitions                                   #
#----------------------------------------------------------------------------------------------#

#······························································································#
#                    Concrete Conceptual States -- from Maxwell's Relations                    #
#······························································································#

# Helmholtz's
"""
`struct TvPair{𝘁<:AbstractFloat} <: ConceptualState{𝘁}`\n
The \$(T, v)\$ conceptual Helmholtz state, or unsubstantial intensive property pair.\n
Conceptual states are just a pair (or a triad) of predefined intensive properties, without
regard of whether those properties are independent or not, since that analysis would require
knowledge of substance model.
"""
struct TvPair{𝘁<:AbstractFloat} <: ConceptualState{𝘁}
    T::system_T{𝘁}      # The state temperature
    v::intensive_V{𝘁}   # The state specific volume
    function TvPair(T::system_T{𝘁}, v::intensive_V{𝘁}) where 𝘁<:AbstractFloat
        @assert minT(𝘁) <= T            "T < minimum T"
        @assert minv(𝘁, BO(v)) <= v     "v < minimum v"
        @assert T <= maxT(𝘁)            "T > maximum T"
        @assert v <= maxv(𝘁, BO(v))     "v > maximum v"
        new{𝘁}(T, v)
    end
end

export TvPair

"`T(st::TvPair{𝘁})::system_T{𝘁} where 𝘁`"
T(st::TvPair) = st.T
"`v(st::TvPair{𝘁})::intensive_V{𝘁} where 𝘁`"
v(st::TvPair) = st.v
Tuple(st::TvPair) = (st.T, st.v)
TvPair(t::Tuple{system_T{𝘁},intensive_V{𝘁}}) where 𝘁 = TvPair(t...)


# Gibbs'
"""
`struct TPPair{𝘁<:AbstractFloat} <: ConceptualState{𝘁}`\n
The \$(T, P)\$ conceptual Gibbs state, or unsubstantial intensive property pair.\n
Conceptual states are just a pair (or a triad) of predefined intensive properties, without
regard of whether those properties are independent or not, since that analysis would require
knowledge of substance model.
"""
struct TPPair{𝘁<:AbstractFloat} <: ConceptualState{𝘁}
    T::system_T{𝘁}      # The state temperature
    P::system_P{𝘁}      # The state pressure
    function TPPair(T::system_T{𝘁}, P::system_P{𝘁}) where 𝘁<:AbstractFloat
        @assert minT(𝘁) <= T            "T < minimum T"
        @assert minP(𝘁) <= P            "P < minimum P"
        @assert T <= maxT(𝘁)            "T > maximum T"
        @assert P <= maxP(𝘁)            "P > maximum P"
        new{𝘁}(T, P)
    end
end

export TPPair

"`T(st::TPPair{𝘁})::system_T{𝘁} where 𝘁`"
T(st::TPPair) = st.T
"`P(st::TPPair{𝘁})::system_P{𝘁} where 𝘁`"
P(st::TPPair) = st.P
Tuple(st::TPPair) = (st.T, st.P)
TPPair(t::Tuple{system_T{𝘁},system_P{𝘁}}) where 𝘁 = TPPair(t...)


#----------------------------------------------------------------------------------------------#
#                                      State Type Unions                                       #
#----------------------------------------------------------------------------------------------#

"""
`anyT{𝘁} = Union{system_T{𝘁},TvPair{𝘁},TPPair{𝘁}} where 𝘁<:AbstractFloat`\n
A `st::anyT` is any `T`-function-bearing type that retrieves an _actual_ temperature, instead of
creating one. This _includes_ all types declared in its definition, since an actual temperature
can be retrieved from those types; however _excludes_ plain `Number`s and
`Unitful.Quantity`(ies) that have dimensions of temperature, despite the fact that a `T()` call
with those argument types successfully builds a `system_T`, since a conversion takes place—the
`Number` wasn't a temperature before the conversion, and `Unitful.Quantity`(ies) conventions are
broader than this package `AbstractAmount` subtypes.
"""
anyT{𝘁} = Union{system_T{𝘁},TvPair{𝘁},TPPair{𝘁}} where 𝘁<:AbstractFloat

export anyT


