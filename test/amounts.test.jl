#----------------------------------------------------------------------------------------------#
#                                       amounts.test.jl                                        #
#----------------------------------------------------------------------------------------------#

@testset "amounts.test.jl: Generic Amount constructor tests                       " begin
    for 𝕋 in (:__amt, )
        for ℙ in (Float16, Float32, Float64, BigFloat)
            for 𝕌 in (
                u"m", u"s", u"m/s", u"N", u"N/m^2", u"J", u"J/s", u"K", u"1/K", u"mol",
                u"mol/s", u"kg/kmol", u"kJ/kg", u"kJ/kg/s", u"kJ/kg/K", u"kJ/kg/K/s",
            )
                #--------------------------------------------------------------------------#
                #                            Exact Constructors                            #
                #--------------------------------------------------------------------------#
                amnt = eval(𝕋)(one(ℙ))                          # unitless arg
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){ℙ}
                @test amnt isa eval(𝕋){ℙ,EX}
                amnt = eval(𝕋)(one(ℙ) * 𝕌)                      # unit-ed arg
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){ℙ}
                @test amnt isa eval(𝕋){ℙ,EX}
                amnt = eval(𝕋)(amnt)                            # copy constructor
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){ℙ}
                @test amnt isa eval(𝕋){ℙ,EX}
                amnt = eval(𝕋){ℙ,EX}(one(ℙ))                    # non-conv, fully spec'd
                @test amnt isa eval(𝕋){ℙ,EX}
                amnt = eval(𝕋){ℙ,EX}(one(ℙ) * 𝕌)                # non-conv, fully spec'd, unit
                @test amnt isa eval(𝕋){ℙ,EX}
                #--------------------------------------------------------------------------#
                #                         Measurements Constructor                         #
                #--------------------------------------------------------------------------#
                amnt = eval(𝕋)(one(ℙ) ± one(ℙ)/ℙ(10))           # unitless arg
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){ℙ}
                @test amnt isa eval(𝕋){ℙ,MM}
                amnt = eval(𝕋)((one(ℙ) ± one(ℙ)/ℙ(10)) * 𝕌)     # unit-ed arg
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){ℙ}
                @test amnt isa eval(𝕋){ℙ,MM}
                amnt = eval(𝕋)(amnt)                            # copy constructor
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){ℙ}
                @test amnt isa eval(𝕋){ℙ,MM}
                amnt = eval(𝕋){ℙ,MM}(one(ℙ) ± one(ℙ))           # non-conv, fully spec'd
                @test amnt isa eval(𝕋){ℙ,MM}
                amnt = eval(𝕋){ℙ,MM}((one(ℙ) ± one(ℙ)) * 𝕌)     # non-conv, fully spec'd, unit
                @test amnt isa eval(𝕋){ℙ,MM}
            end
        end
        for 𝕍 in Real[Irrational{:ℯ}(), Irrational{:π}(), 2//3, 1//10, 3, 2]
            for 𝕌 in (
                u"m", u"s", u"m/s", u"N", u"N/m^2", u"J", u"J/s", u"K", u"1/K", u"mol",
                u"mol/s", u"kg/kmol", u"kJ/kg", u"kJ/kg/s", u"kJ/kg/K", u"kJ/kg/K/s",
            )
                #--------------------------------------------------------------------------#
                #                            Exact Constructors                            #
                #--------------------------------------------------------------------------#
                amnt = eval(𝕋)(𝕍)                               # unitless arg
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){Float64}
                @test amnt isa eval(𝕋){Float64,EX}
                amnt = eval(𝕋)(𝕍 * 𝕌)                           # unit-ed arg
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){Float64}
                @test amnt isa eval(𝕋){Float64,EX}
                amnt = eval(𝕋)(amnt)                            # copy constructor
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){Float64}
                @test amnt isa eval(𝕋){Float64,EX}
                amnt = eval(𝕋){Float64,EX}(𝕍)                   # non-conv, fully spec'd
                @test amnt isa eval(𝕋){Float64,EX}
                amnt = eval(𝕋){Float64,EX}(𝕍 * 𝕌)               # non-conv, fully spec'd, unit
                @test amnt isa eval(𝕋){Float64,EX}
                #--------------------------------------------------------------------------#
                #                         Measurements Constructor                         #
                #--------------------------------------------------------------------------#
                amnt = eval(𝕋)(𝕍 ± 𝕍)                           # unitless arg
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){Float64}
                @test amnt isa eval(𝕋){Float64,MM}
                amnt = eval(𝕋)((𝕍 ± 𝕍) * 𝕌)                     # unit-ed arg
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){Float64}
                @test amnt isa eval(𝕋){Float64,MM}
                amnt = eval(𝕋)(amnt)                            # copy constructor
                @test amnt isa eval(𝕋)
                @test amnt isa eval(𝕋){Float64}
                @test amnt isa eval(𝕋){Float64,MM}
                amnt = eval(𝕋){Float64,MM}(𝕍 ± 𝕍)               # non-conv, fully spec'd
                @test amnt isa eval(𝕋){Float64,MM}
                amnt = eval(𝕋){Float64,MM}((𝕍 ± 𝕍) * 𝕌)         # non-conv, fully spec'd, unit
                @test amnt isa eval(𝕋){Float64,MM}
            end
        end
    end
end


@testset "amounts.test.jl: Whole Amount constructor tests                         " begin
    for 𝕋 in (:T_amt, :P_amt, :veamt, :spamt, :t_amt, :gvamt, :z_amt,
              :Z_amt, :gaamt, :beamt, :kTamt, :ksamt, :k_amt, :csamt,
              :Maamt, :mJamt, :mSamt, :x_amt, :Pramt, :vramt, :ø_amt)
        for ℙ in (Float16, Float32, Float64, BigFloat)
            # Obtain corresponding 𝕋 amount's units
            𝕌 = unit(eval(𝕋)(one(ℙ))())
            #--------------------------------------------------------------------------#
            #                            Exact Constructors                            #
            #--------------------------------------------------------------------------#
            amnt = eval(𝕋)(one(ℙ))                          # unitless arg
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){ℙ}
            @test amnt isa eval(𝕋){ℙ,EX}
            amnt = eval(𝕋)(one(ℙ) * 𝕌)                      # unit-ed arg
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){ℙ}
            @test amnt isa eval(𝕋){ℙ,EX}
            amnt = eval(𝕋)(amnt)                            # copy constructor
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){ℙ}
            @test amnt isa eval(𝕋){ℙ,EX}
            amnt = eval(𝕋){ℙ,EX}(one(ℙ))                    # non-conv, fully spec'd
            @test amnt isa eval(𝕋){ℙ,EX}
            amnt = eval(𝕋){ℙ,EX}(one(ℙ) * 𝕌)                # non-conv, fully spec'd, unit
            @test amnt isa eval(𝕋){ℙ,EX}
            #--------------------------------------------------------------------------#
            #                         Measurements Constructor                         #
            #--------------------------------------------------------------------------#
            amnt = eval(𝕋)(one(ℙ) ± one(ℙ)/ℙ(10))           # unitless arg
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){ℙ}
            @test amnt isa eval(𝕋){ℙ,MM}
            amnt = eval(𝕋)((one(ℙ) ± one(ℙ)/ℙ(10)) * 𝕌)     # unit-ed arg
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){ℙ}
            @test amnt isa eval(𝕋){ℙ,MM}
            amnt = eval(𝕋)(amnt)                            # copy constructor
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){ℙ}
            @test amnt isa eval(𝕋){ℙ,MM}
            amnt = eval(𝕋){ℙ,MM}(one(ℙ) ± one(ℙ))           # non-conv, fully spec'd
            @test amnt isa eval(𝕋){ℙ,MM}
            amnt = eval(𝕋){ℙ,MM}((one(ℙ) ± one(ℙ)) * 𝕌)     # non-conv, fully spec'd, unit
            @test amnt isa eval(𝕋){ℙ,MM}
        end
        for 𝕍 in Real[Irrational{:ℯ}(), Irrational{:π}(), 2//3, 1//10, 3, 2]
            # Obtain corresponding 𝕋 amount's units
            𝕌 = unit(eval(𝕋)(𝕍)())
            #--------------------------------------------------------------------------#
            #                            Exact Constructors                            #
            #--------------------------------------------------------------------------#
            amnt = eval(𝕋)(𝕍)                               # unitless arg
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){Float64}
            @test amnt isa eval(𝕋){Float64,EX}
            amnt = eval(𝕋)(𝕍 * 𝕌)                           # unit-ed arg
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){Float64}
            @test amnt isa eval(𝕋){Float64,EX}
            amnt = eval(𝕋)(amnt)                            # copy constructor
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){Float64}
            @test amnt isa eval(𝕋){Float64,EX}
            amnt = eval(𝕋){Float64,EX}(𝕍)                   # non-conv, fully spec'd
            @test amnt isa eval(𝕋){Float64,EX}
            amnt = eval(𝕋){Float64,EX}(𝕍 * 𝕌)               # non-conv, fully spec'd, unit
            @test amnt isa eval(𝕋){Float64,EX}
            #--------------------------------------------------------------------------#
            #                         Measurements Constructor                         #
            #--------------------------------------------------------------------------#
            amnt = eval(𝕋)(𝕍 ± 𝕍)                           # unitless arg
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){Float64}
            @test amnt isa eval(𝕋){Float64,MM}
            amnt = eval(𝕋)((𝕍 ± 𝕍) * 𝕌)                     # unit-ed arg
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){Float64}
            @test amnt isa eval(𝕋){Float64,MM}
            amnt = eval(𝕋)(amnt)                            # copy constructor
            @test amnt isa eval(𝕋)
            @test amnt isa eval(𝕋){Float64}
            @test amnt isa eval(𝕋){Float64,MM}
            amnt = eval(𝕋){Float64,MM}(𝕍 ± 𝕍)               # non-conv, fully spec'd
            @test amnt isa eval(𝕋){Float64,MM}
            amnt = eval(𝕋){Float64,MM}((𝕍 ± 𝕍) * 𝕌)         # non-conv, fully spec'd, unit
            @test amnt isa eval(𝕋){Float64,MM}
        end
    end
end


