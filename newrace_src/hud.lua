local speedow=30
function draw_hud()

    -- speedo
    rectfill(6, 6, 6+speedow,6+5,col.blue1)
    rect(6, 6, 6+speedow,6+5,col.grey2)
    rectfill(7, 7, 7+speed/maxspeed*(speedow-2),10,col.red2)
    rect(7, 7, 7+speed/maxspeed*(speedow-2),10,col.red1)

    print(score, 64,2,col.white)
    print(gems, 73,2,col.white)
end