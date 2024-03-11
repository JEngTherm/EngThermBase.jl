#----------------------------------------------------------------------------------------------#
#                         Selected Elements' Atomic Mass Data Library                          #
#----------------------------------------------------------------------------------------------#

"""
`atoM_64 = (; ...)`\n
`NamedTuple` of atomic weights, with uncertainty, by chemical element symbol. Entries are of
Measurement{Float64} precision.\n
Data Source:
    [1] Lide, David, L; CRC Handbook of Chemistry and Physics, 86th Ed. Boca Raton, London, New
    York, Singapore. 2005--2006.
"""
atoM_64 = (;
    H  = m_(measurement("1.00794(7)"),     MO),
    He = m_(measurement("4.002602(2)"),    MO),
    Li = m_(measurement("6.941(2)"),       MO),
    Be = m_(measurement("9.012182(3)"),    MO),
    B  = m_(measurement("10.811(7)"),      MO),
    C  = m_(measurement("12.0107(8)"),     MO),
    N  = m_(measurement("14.0067(2)"),     MO),
    O  = m_(measurement("15.9994(3)"),     MO),
    F  = m_(measurement("18.9984032(5)"),  MO),
    Ne = m_(measurement("20.1797(6)"),     MO),
    Na = m_(measurement("22.989770(2)"),   MO),
    Mg = m_(measurement("24.3050(6)"),     MO),
    Al = m_(measurement("26.981538(2)"),   MO),
    Si = m_(measurement("28.0855(3)"),     MO),
    P  = m_(measurement("30.973761(2)"),   MO),
    S  = m_(measurement("32.065(5)"),      MO),
    Cl = m_(measurement("35.453(2)"),      MO),
    Ar = m_(measurement("39.948(1)"),      MO),
    K  = m_(measurement("39.0983(1)"),     MO),
    Ca = m_(measurement("40.078(4)"),      MO),
    Kr = m_(measurement("83.798(2)"),      MO),
    Xe = m_(measurement("131.293(6)"),     MO),
    Hg = m_(measurement("200.59(2)"),      MO),
    Rn = m_(222.0176 * (1.0 ± 0.05),       MO),
)

"""
`atoM_32`\n
`NamedTuple` of atomic weights, with uncertainty, by chemical element symbol. Entries are of
Measurement{Float32} precision.\n
Data Source:
    [1] Lide, David, L; CRC Handbook of Chemistry and Physics, 86th Ed. Boca Raton, London, New
    York, Singapore. 2005--2006.
"""
atoM_32 = NamedTuple{keys(atoM_64)}(
    (m_(Measurement{Float32}(bare(v)), MO) for v in values(atoM_64))
)

atoM = atoM_32

"""
`atoM_16`\n
`NamedTuple` of atomic weights, with uncertainty, by chemical element symbol. Entries are of
Measurement{Float16} precision.\n
Data Source:
    [1] Lide, David, L; CRC Handbook of Chemistry and Physics, 86th Ed. Boca Raton, London, New
    York, Singapore. 2005--2006.
"""
atoM_16 = NamedTuple{keys(atoM_64)}(
    (m_(Measurement{Float16}(bare(v)), MO) for v in values(atoM_64))
)

export atoM


