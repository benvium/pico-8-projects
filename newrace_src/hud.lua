local speedow=30
function draw_hud()

    -- speedo
    rectfill(6, 6, 6+speedow,6+5,col.blue1)
    rect(6, 6, 6+speedow,6+5,col.grey2)
    rectfill(7, 7, 7+speed/maxspeed*(speedow-2),10,col.red2)
    rect(7, 7, 7+speed/maxspeed*(speedow-2),10,col.red1)

    print(score.." / "..gems, 64,2,col.white)

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

    print("obs:"..#obs,col.black)
    print("cars:"..#cars,col.black)
    print("pts:"..#pts,col.black)
    print("distance: "..flr(distance%trackLength2).."/"..trackLength2, col.black)
end