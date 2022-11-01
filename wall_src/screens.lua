function end_init()
    min_time=90
    sfx(-1,0)
    sfx(-1,1)
    sfx(-1,2)
    sfx(-1,3)
    sfx(fx.fanfare)
end

local btnPressed=false
function end_update()
    min_time-=1
    if btn(5) and min_time<0 then
        btnPressed=true
    end
    if not btn(5) and btnPressed and min_time<0 then
        btnPressed=false
        mode="game"
        _init()
    end
end

function end_draw()
    cls(col.black)
    map(0,16,0,0,16,16)

    rectfill(0, 15, 128, 16+6, col.blue1)
    cursor(33,16)
    print("y o u  w i n", col.blue2)
    cursor(31,16)
    print("y o u  w i n", col.grey1)
    cursor(32,16)
    print("y o u  w i n", col.white)    


    cursor(32,90)
    if min_time<0 then
        print("press X to finish", col.black)
    end
end