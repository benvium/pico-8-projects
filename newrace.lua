local col={
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

local distance=0
local speed=0
local maxspeed=3
local x=0
local dx=0
local steerspeed=0.4
local skid=false

local carsprite={
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
    local off=60
    if x<-off or x>off then 
        if x<-off then x=-off end
        if x>off then x=off end
        if (speed>(maxspeed/4)) then
            speed*=0.95
        end
        if rumble==false then
            rumble=true
            -- TODO the sound effect isn't working yet
            -- sfx(1,1)
        end
    else
        -- if rumble==true then
        --     rumble=false
        --     sfx(-1,1)
        -- end
    end
    


    distance=(distance+speed)%(tracklength*100)

    local trackidx=flr(distance/100)
    local track = track[trackidx]

    if track==nil then track=0 end

    if speed>0 then
     turn=turn+((track-turn)/(15*(speed/maxspeed)))
    end

    bgx=(bgx-turn*(speed/maxspeed)*0.75)%128
end

local shadinggrs = {
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

local shadingroad = {
    col.blue2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
}

shadinglns = {
    {col.grey2,col.red1},
    {col.white,col.red1},
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
    0.3,0.7,0.7,0.7,0.7,0.3,
    0,
    -0.3,-1,-1,-1,-0.3,
    0,
    0,
    -0.5,-0.5,0.5,0.5,-0.5,-0.5,0.5,0.5
}

tracklength=count(track)

bgx=0
screensize=128

-- -- converts x -1..1 to a position on the road in pixels
-- -- much %age down road (0=top)
-- -- midw middle of the screen
-- -- roadw2 width of the road
-- function roadX(x, roadw2, much)
--     local perspective = 0.8*(much)+0.08
--     local roadw=roadw2*0.5*perspective
--     local midw=0.5+(turn*(1-much))^3
--     local x2 = midw-(x*perspective*screensize)--midw-roadw-x
--     return x2
-- end

-------------------
-- roadside objects

local obs = {}

-- temp gen obs
for i=0,200 do
    local ob
    local obchoice=flr(rnd(3))
    if obchoice==0 then
        -- TREE
        ob={
            sprx=4*8, -- spr 1 coords
            spry=0,
            w=3,
            h=4,
            ax=1+rnd(1)/5, -- anchor right
            flipx=flr(rnd(2))==0,
        }
    elseif obchoice==1 then
        -- Lard sign
        ob={
            sprx=7*8,
            spry=0,
            w=3,
            h=2,
            ax=1, -- anchor right
        }
    else
        -- 30 sign
        ob={
            sprx=7*8, 
            spry=2*8,
            w=1,
            h=2,
            ax=2, -- anchor right
        }
    end

    ob.d=i*10
    local isLeft=flr(rnd(2))==0;
    ob.x=isLeft and -1 or 1
    ob.scale=3
    if not isLeft then
        ob.ax = -ob.ax
        -- flip anchor
    end
    add(obs, ob, 1)
end

local roadh=78+height

function _draw()
    cls()
    
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
        
        -- local shade=shadingrdtx[flr(much*16)+1]
        --local roady = l and shade or shade+2

        local shade2=shadinggrs[flr(much*10)+1]
        local grasscolor= isStripe and shade2[1] or shade2[2]

        shade2=shadinglns[flr(much*10)+1]
        local linecolor = isStripe and shade2[1] or shade2[2]

        -- draw road first over whole screen
        -- local tlineY = (shade+(y%2))/8
        -- if isStripe then
        --  tlineY=tlineY+2
        -- end
        -- tline(0, y, 128, y, 0, tlineY)

        local roadcolor=shadingroad[flr(much*10)+1]
        line(ledge, y, redge, y, roadcolor)
        line(0, y, lgrassw, y, grasscolor)

        -- left edge
        line(lgrassw, y, ledge, y, linecolor)
        
        line(redge,y,rgrass, y, linecolor)
        line(rgrass, y, screensize, y, grasscolor)

        -- line in center of road
        if isStripe then
            line((midw-roadw*0.035)*screensize, y, (midw+roadw*0.035)*screensize, y, linecolor)
        end

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

    color(6)
    print(stat(7))
    print("distance: "..flr(distance))
    print("x: "..x)
    --print("track: "..getTrack(distance) and getTrack(distance) or -1)
    -- print(turn)
    

    -- DRAW ROADSIDE OBJECTS
    for ob in all(obs) do
        drawobject(ob)
    end

    -- DRAW ENEMY CARS
    -- temp
    drawobject({
        d=50,
        x=-.3,
        sprx=0*8, 
        spry=1*8,
        w=4,
        h=3,
        ax=0.5, -- anchor center
        scale=1.25
    })

    drawobject({
        d=100,
        x=.3,
        sprx=0*8, 
        spry=1*8,
        w=4,
        h=3,
        ax=0.5, -- anchor center
        scale=1.25
    })

    -- DRAW THE CAR
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
end


function drawobject(ob) 
    local obd=ob.d-distance
    local clipd=100
    if obd > -10 and obd<clipd then
        local ay=((clipd-obd)/clipd)^3.5
        -- not quite right speed
        -- also duplicated from road drawing, move into function
        local perspective = 0.8*(ay)+0.08
        local midw=0.5+(turn*(1-ay))^3
        local roadw=1.2
        roadw=roadw*0.5*perspective
        local px=(midw+roadw*ob.x)*screensize
        
        printh("px:"..px.." ob.x:"..ob.x.." midw:"..midw.." ob.x+midw:"..ob.x+midw)

        local py=ay*roadh+(screensize-roadh)
        --sspr takes a RECTANGLE from the sprite sheet, not a sprite number (for some reason)
        local scaledh=ob.h*8*perspective*ob.scale
        local scaledw=ob.w*8*perspective*ob.scale
        sspr(
            ob.sprx,
            ob.spry,
            ob.w*8,
            ob.h*8,
            px-scaledw*ob.ax,
            py-scaledh, --move up based on the height
            scaledw,
            scaledh,
            ob.flipx
        )
    end
end