function home_init()
    music(0)
end

function home_update()
    if btn(5) then
        btnPressed=true
    end
    if not btn(5) and btnPressed then
        btnPressed=false
        music(-1)
        mode="race"
        race_init()
        roadside_init()
        cars_init()
    end
end

function home_draw()
    cls(col.blue3)
    map(0,0,0,0,16,16)
    spr(4,4,128-36,2,4)
    spr(16,16,128-24,4,3)
    spr(64,64-16,128-24,4,3)
    spr(128,128-16-32,128-24,4,3)

    rectfill(0, 15, 128, 16+6, col.blue1)
    cursor(33,16)
    print("r e d  r a c e r", col.blue2)
    cursor(31,16)
    print("r e d  r a c e r", col.grey1)
    cursor(32,16)
    print("r e d  r a c e r", col.white)
    cursor(32,32)
    print("press X to start", col.white)
end

function end_init()
    min_time=90
    sfx(-1,0)
    sfx(-1,1)
    sfx(-1,2)
    sfx(-1,3)
    sfx(25)
end

local btnPressed=false
function end_update()
    min_time-=1
    if btn(5) and min_time<0 then
        btnPressed=true
    end
    if not btn(5) and btnPressed and min_time<0 then
        btnPressed=false
        mode="home"
        home_init()
    end
end

function end_draw()
    cls(col.black)
    map(0,16,0,0,16,16)

    rectfill(0, 15, 128, 16+6, col.blue1)
    cursor(33,16)
    print("r e d  r a c e r", col.blue2)
    cursor(31,16)
    print("r e d  r a c e r", col.grey1)
    cursor(32,16)
    print("r e d  r a c e r", col.white)

    
    for i=1,#laptimes do
        local tm=laptimes[i]
        cursor(43,38+(i-1)*9)
        print("lap "..i.." "..flr(tm)..":"..flr(tm*100)-100*flr(tm),col.white)
    end

    cursor(32,90)
    if min_time<0 then
        print("press X to finish", col.black)
    end
end