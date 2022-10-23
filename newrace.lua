col={
    green1=3,
    green2=11,
    blue1=1,
    blue2=13,
    blue3=12,
    grey1=5,
    grey2=6,
    white=7,
    red1=2,
    red2=8
}

distance=0
speed=0
maxspeed=3
x=0
dx=0
steerspeed=0.4
skid=false

carsprite={
    center=64,
    l1=196,
    l2=200,
    r1=132,
    r2=136
}

function _update60()

    if btn(1) then
        dx=speed*steerspeed
    elseif btn(0) then
        dx=-speed*steerspeed
    else
        dx=0
    end
    if btn(2) then
        height=min(50,height+2)
    end
    if btn(3) then
        height=max(-40,height-2)
    end
    if btn(4) then
        speed=min(maxspeed,speed+0.02)
    else
        speed=max(0,speed-0.06)
    end

    
    -- throw off sides during turns
    local throwspeed=turn*(speed/maxspeed)
    

    -- play skid sound
    local isSkid = abs(dx)>0.3 and abs(throwspeed)>0.3

    if not skid and isSkid then
        sfx(0,1)
        skid=true
    end
    if skid and not isSkid then
        sfx(-1,1)
        skid=false
    end

    dx=dx-throwspeed

    x=x+dx
    distance=(distance+speed)%(tracklength*100)

    local trackidx=flr(distance/100)
    local track = track[trackidx]

    if track==nil then track=0 end

    if speed>0 then
     turn=turn+((track-turn)/(15*(speed/maxspeed)))
    end

    bgx=(bgx-turn*(speed/maxspeed)*0.75)%128
end

shadingrdtx = {
    -- 0,
    -- 2,
    -- 4,
    6,
    8,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
}

shadinggrs = {
    {col.green1,col.grey1},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
}

shadinglns = {
    {col.grey1,col.red1},
    {col.blue2,col.red1},
    -- {col.grey2,col.red2},
    -- {col.grey2,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
}

turn=0
height=0

track={
    0,
    0.3,1,1,1,1,0.3,
    0,
    -0.3,-1,-1,-1,-0.3,
    0,
    0,
    -0.5,-0.5,0.5,0.5,-0.5,-0.5,0.5,0.5
}

tracklength=count(track)

bgx=0

function _draw()
    cls()
    local screensize=128
    local roadh=78+height

    -- background
    map(0,5,bgx-128,64-8-roadh,16,16)
    map(0,5,bgx,64-8-roadh,16,16)
    map(0,5,bgx+128,64-8-roadh,16,16)
    -- ^ todo ineffecient! drawing too much
    -- map(0,13,0,roadh-96,16,16)

    for y1=0,roadh do
        local y=y1+screensize-roadh --+height)
        local much=y1/roadh
        local perspective = 0.8*(much)+0.08

        local roadw=1.2
        roadw=roadw*0.5*perspective
        local midw=0.5+(turn*(1-much))^3
        local edgew=roadw*0.2

        local lgrassw = (midw-roadw-edgew)*screensize
        local ledge = (midw-roadw)*screensize
        local redge = (midw+roadw)*screensize
        local rgrass = (midw+roadw+edgew)*screensize

        
        local isStripe = sin(10*((1-perspective)^3)+(distance*0.05)%3.14)>0
        
        local shade=shadingrdtx[flr(much*16)+1]
        --local roady = l and shade or shade+2

        local shade2=shadinggrs[flr(much*10)+1]
        local grasscolor= isStripe and shade2[1] or shade2[2]

        shade2=shadinglns[flr(much*10)+1]
        local linecolor = isStripe and shade2[1] or shade2[2]

        -- draw road first over whole screen
        local tlineY = (shade+(y%2))/8
        if isStripe then
         tlineY=tlineY+2
        end
        tline(0, y, 128, y, 0, tlineY)
        line(0, y, lgrassw, y, grasscolor)

        -- left edge
        line(lgrassw, y, ledge, y, linecolor)
        
        line(redge,y,rgrass, y, linecolor)
        line(rgrass, y, screensize, y, grasscolor)

    end

    local carspr=0x40
    if height>20 then
        carspr=0x48
    elseif height<-10 then
        carspr=0x44
    elseif  speed>0.1 then 
            if btn(1) then
            -- only support turning when flat...
            carspr=skid and carsprite.r2 or carsprite.r1
        elseif btn(0) then
            carspr=skid and carsprite.l2 or carsprite.l1
        end
    end

    local tr=0 --btn(1) and 1 or 0 --//turn>0.5 and 1 or 0
    local tl=0 --btn(0) and 1 or 0-- turn<-0.5 and 1 or 0
    spr(carspr,
    64-16+turn*16+x,
    96+height/10+tl
    ,2,3)

    spr
    (carspr+0x02,
    16+64-16+turn*16+x,
    96+height/10+tr,
    2,3)

    color(6)
    print(stat(7))
    print("distance: "..flr(distance))
    print("x: "..x)
    --print("track: "..getTrack(distance) and getTrack(distance) or -1)
    print(turn)

    -- temp object
    spr(0x176, 96, 32)
end

-------------------
-- roadside objects

local ob = {}

function updateOb() 
end

function drawOb()
end

-- 3d Projection
-- y_screen = (y_world*scale / z) + (screen_height >> 1)
-- or:
-- z = (y_world*scale) / (y_screen - (screen_height >> 1))
-- http://www.extentofthejam.com/pseudo/#curves