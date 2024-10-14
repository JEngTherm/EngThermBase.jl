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
    # --- line 1
    H  = m_(measurement("1.00794(7)"),     MO),
    He = m_(measurement("4.002602(2)"),    MO),
    # --- line 2
    Li = m_(measurement("6.941(2)"),       MO),
    Be = m_(measurement("9.012182(3)"),    MO),
    B  = m_(measurement("10.811(7)"),      MO),
    C  = m_(measurement("12.0107(8)"),     MO),
    N  = m_(measurement("14.0067(2)"),     MO),
    O  = m_(measurement("15.9994(3)"),     MO),
    F  = m_(measurement("18.9984032(5)"),  MO),
    Ne = m_(measurement("20.1797(6)"),     MO),
    # --- line 3
    Na = m_(measurement("22.989770(2)"),   MO),
    Mg = m_(measurement("24.3050(6)"),     MO),
    Al = m_(measurement("26.981538(2)"),   MO),
    Si = m_(measurement("28.0855(3)"),     MO),
    P  = m_(measurement("30.973761(2)"),   MO),
    S  = m_(measurement("32.065(5)"),      MO),
    Cl = m_(measurement("35.453(2)"),      MO),
    Ar = m_(measurement("39.948(1)"),      MO),
    # --- line 4
    K  = m_(measurement("39.0983(1)"),     MO),
    Ca = m_(measurement("40.078(4)"),      MO),
    Sc = m_(measurement("44.955910(8)"),   MO),
    Ti = m_(measurement("47.867(1)"),      MO),
    V  = m_(measurement("50.9415(1)"),     MO),
    Cr = m_(measurement("51.9961(6)"),     MO),
    Mn = m_(measurement("54.938049(9)"),   MO),
    Fe = m_(measurement("55.845(2)"),      MO),
    Co = m_(measurement("58.933200(9)"),   MO),
    Ni = m_(measurement("58.6934(2)"),     MO),
    Cu = m_(measurement("63.546(3)"),      MO),
    Zn = m_(measurement("65.409(4)"),      MO),
    Ga = m_(measurement("69.723(1)"),      MO),
    Ge = m_(measurement("72.64(1)"),       MO),
    As = m_(measurement("74.92160(2)"),    MO),
    Se = m_(measurement("78.96(3)"),       MO),
    Br = m_(measurement("79.904(1)"),      MO),
    Kr = m_(measurement("83.798(2)"),      MO),
    # --- line 5
    Rb = m_(measurement("85.4678(3)"),     MO),
    Sr = m_(measurement("87.62(1)"),       MO),
    Y  = m_(measurement("88.90585(2)"),    MO),
    Zr = m_(measurement("91.224(2)"),      MO),
    Nb = m_(measurement("92.90638(2)"),    MO),
    Mo = m_(measurement("95.94(2)"),       MO),
    Tc = m_( 97.9072 * (1.0 ± 0.05),       MO),
    Ru = m_(measurement("101.07(2)"),      MO),
    Rh = m_(measurement("102.90550(2)"),   MO),
    Pd = m_(measurement("106.42(1)"),      MO),
    Ag = m_(measurement("107.8682(2)"),    MO),
    Cd = m_(measurement("112.411(8)"),     MO),
    In = m_(measurement("114.818(3)"),     MO),
    Sn = m_(measurement("118.710(7)"),     MO),
    Sb = m_(measurement("121.760(1)"),     MO),
    Te = m_(measurement("127.60(3)"),      MO),
    I  = m_(measurement("126.90447(3)"),   MO),
    Xe = m_(measurement("131.293(6)"),     MO),
    # --- line 6
    Cs = m_(measurement("132.90545(2)"),   MO),
    Ba = m_(measurement("137.327(7)"),     MO),
    Lu = m_(measurement("174.967(1)"),     MO),
    Hf = m_(measurement("178.49(2)"),      MO),
    Ta = m_(measurement("180.9479(1)"),    MO),
    W  = m_(measurement("183.84(1)"),      MO),
    Re = m_(measurement("186.207(1)"),     MO),
    Os = m_(measurement("190.23(3)"),      MO),
    Ir = m_(measurement("192.217(3)"),     MO),
    Pt = m_(measurement("195.078(2)"),     MO),
    Au = m_(measurement("196.96655(2)"),   MO),
    Hg = m_(measurement("200.59(2)"),      MO),
    Tl = m_(measurement("204.3833(2)"),    MO),
    Pb = m_(measurement("207.2(1)"),       MO),
    Bi = m_(measurement("208.98038(2)"),   MO),
    Po = m_(208.9824 * (1.0 ± 0.05),       MO),
    At = m_(209.9871 * (1.0 ± 0.05),       MO),
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


#----------------------------------------------------------------------------------------------#
#                                       The Exported One                                       #
#----------------------------------------------------------------------------------------------#

atoM = atoM_64

export atoM


