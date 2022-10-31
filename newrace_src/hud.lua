local speedow=30
local debug=false

function draw_hud()

    -- speedo
    rectfill(6, 6, 6+speedow,6+5,col.blue1)
    rect(6, 6, 6+speedow,6+5,col.grey2)
    rectfill(7, 7, 7+speed/maxspeed*(speedow-2),10,col.red2)
    rect(7, 7, 7+speed/maxspeed*(speedow-2),10,col.red1)

    spr(1,100-11,5,1,1)
    print(score.." / "..gems, 100,6,col.white)

    spr(122,64-20,5,1,1,true)
    spr(121,64-12,5,1,1)
    spr(115+lap,64-4,5,1,1)
    spr(122,64+4,5,1,1)

    -- 
    local t=getTrack2(distance)
    if t~=nil then
        -- local d=t[1]==nil and 'n/a' or t[1]
        -- local turn=t[2]==nil and 'n/a' or t[2]
        -- local items=t[3]==nil and 'n/a' or t[3]
        -- local hill=t[4]==nil and 'n/a' or t[4]
        -- print("track: "..d.." "..turn.." "..items.." "..hill)
        -- print("",0,0)

        -- for i=1,4 do
        --     print(tostring(t[i]), 0,0,col.black)
        -- end

        -- for i=1,#t[4] do
        --     print(tostring(t[4][i]), 0,32,col.black)
        -- end

    end

    for tm in all(laptimes) do
        print(flr(tm)..":"..flr(tm*100)-100*flr(tm),col.black)
    end

    if debug then
        print("obs:"..#obs,col.black)
        print("cars:"..#cars,col.black)
        print("pts:"..#pts,col.black)
        print("distance: "..flr(distance%trackLength2).."/"..trackLength2, col.black)
        print("through: "..flr(through),col.black)
    end
end