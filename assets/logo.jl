using Luxor

SIDE=500
RADIUS=SIDE/(2√3)
yOFF=0.25*RADIUS
DARK=0.6
LW=1.5
letters = ["E", "Θ", "B"]

Drawing(SIDE, SIDE, "logo.svg")
origin()
translate(0,yOFF)
rotate(deg2rad(-90.0))

const colors = (Luxor.julia_green, Luxor.julia_purple, Luxor.julia_blue)
corners = ngon(Point(0, 0), RADIUS, 3, vertices=true)

fontface("SBL BibLit")

for i in 1:3
    # Fills
    setcolor(colors[i] .* DARK)
    circle(corners[i], (√3/2)*RADIUS, action = :fill)
    # Draw stokes
    setline(LW)
    setcolor((0.65,0.65,0.45))
    circle(corners[i], (√3/2)*RADIUS - 1LW, action = :stroke)
    setline(1.5*LW)
    setcolor("black")
    circle(corners[i], (√3/2)*RADIUS - 0LW, action = :stroke)
    setcolor("black")
    circle(corners[i], (√3/2)*RADIUS - 2LW, action = :stroke)
    # Draws Letters
    fontsize(RADIUS+4LW)
    setcolor("black")
    text(letters[i], corners[i], valign = :center, halign = :center, angle = pi/2)
    fontsize(RADIUS+0LW)
    setcolor((0.65,0.65,0.45))
    text(letters[i], corners[i], valign = :center, halign = :center, angle = pi/2)
end

finish()

