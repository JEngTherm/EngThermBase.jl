using InteractiveUtils

function union2vec(theU::Union)
    ret = DataType[]
    while theU isa Union
        push!(ret, theU.a)
        theU = theU.b
    end
    push!(ret, theU)
    return ret
end


#----------------------------------------------------------------------------------------------#
#                                       abstract.test.jl                                       #
#----------------------------------------------------------------------------------------------#

@testset "abstract.test.jl: PREC, EXAC, and BASE type Union tests                 " begin
    # All PREC members must be floats:
    for __t in union2vec(EngThermBase.PREC)
        @test __t <: AbstractFloat
    end
    # EXAC must contain all ExactBase subtypes:
    @test Set(union2vec(EngThermBase.EXAC)) ==
          Set(subtypes(ExactBase))
    # BASE must contain all ThermBase subtypes:
    @test Set(union2vec(EngThermBase.BASE)) == 
          Set(vcat([ subtypes(i) for i in subtypes(ThermBase) ]...))
end

@testset "abstract.test.jl: EngThermBase type tree tests                          " begin
    # All types and parents
    for (__t, __p) in [
        # Top-Level
        (:AbstractTherm     , :Any          ),
        # BASES branch
        (  :BASES           , :AbstractTherm),
        (    :ThermBase     , :BASES        ),
        (      :IntBase     , :ThermBase    ),
        (        :MA        , :IntBase      ),
        (        :MO        , :IntBase      ),
        (      :ExtBase     , :ThermBase    ),
        (        :SY        , :ExtBase      ),
        (        :DT        , :ExtBase      ),
        (    :ExactBase     , :BASES        ),
        (      :EX          , :ExactBase    ),
        (      :MM          , :ExactBase    ),
        # AUX branch
        (  :AUX             , :AbstractTherm),
        (    :AuxFunc       , :AUX          ),
        # AMOUNTS branch
        (  :AMOUNTS         , :AbstractTherm),
        (    :WholeAmt      , :AMOUNTS      ),
        (      :WProperty   , :WholeAmt     ),
        (      :WInteract   , :WholeAmt     ),
        (      :WUnranked   , :WholeAmt     ),
        (    :BasedAmt      , :AMOUNTS      ),
        (      :BProperty   , :BasedAmt     ),
        (      :BInteract   , :BasedAmt     ),
        (      :BUnranked   , :BasedAmt     ),
        (    :GenerAmt      , :AMOUNTS      ),
        # COMBOS branch
        (  :COMBOS          , :AbstractTherm),
        (    :PropPair      , :COMBOS       ),
        (      :ChFPair     , :PropPair     ),
        (      :EoSPair     , :PropPair     ),
        (    :PropTrio      , :COMBOS       ),
        (    :PropQuad      , :COMBOS       ),
        # MODELS branch
        (  :MODELS          , :AbstractTherm),
        (    :Heat          , :MODELS       ),
        (      :ConstHeat   , :Heat         ),
        (      :UnvarHeat   , :Heat         ),
        (      :BivarHeat   , :Heat         ),
        (      :GenerHeat   , :Heat         ),
        (    :Medium        , :MODELS       ),
        (      :Substance   , :Medium       ),
        (    :System        , :MODELS       ),
        (      :Scope       , :System       ),
        (        :PureSubs  , :Scope        ),
        (        :Mixtures  , :Scope        ),
        (          :Unreact , :Mixtures     ),
        (          :Reactiv , :Mixtures     ),
    ]
        @test typeof(eval(__t)) in (DataType, UnionAll)
        @test typeof(eval(__p)) in (DataType, UnionAll)
        __S = supertype(eval(__t))
        while typeof(__S) == UnionAll
            __S = __S.body
        end
        @test eval(__p) === __S.name.wrapper
    end
end


