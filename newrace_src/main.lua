
-- distance around the track
distance=0

-- current player/car

--consts
maxspeed=3
steerspeed=0.4
--


speed=0
x=0
dx=0
skid=false

-- how far track is turning left/right
turn=0
-- distance off the ground / fake hill height
height=0

-- background x position
bgx=0
screensize=128

-- size of the road
roadh=78+height


----------------------------
--- UPDATE ---
----------------------------
function _update60()

    if btn(1) then
        dx=speed*steerspeed
    elseif btn(0) then
        dx=-speed*steerspeed
    else
        dx=0
    end
    -- if btn(2) then
    --     height=min(50,height+2)
    --     roadh=78+height
    -- end
    -- if btn(3) then
    --     height=max(-40,height-2)
    --     roadh=78+height
    -- end
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

    -- if we go off the sides, slow down the car
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
            sfx(1,2)
        end
    else
        if rumble==true then
            rumble=false
            sfx(-1,2)
        end
    end
    

    -- move down the track
    distance=(distance+speed)%(tracklength*100)

    -- interpolate between turns
    local trackidx=flr(distance/100)
    local trackNow = track[trackidx%tracklength+1]
    local trackNext = track[trackidx%tracklength+2]
    if trackNow==nil then trackNow=0 end
    if trackNext==nil then trackNext=0 end
    turn = trackNow + (trackNext-trackNow)*(distance%100)/100

    -- interpolate between hills
    local hillidx=flr(distance/100)
    local hillNow = hills[hillidx%tracklength+1]
    local hillNext = hills[hillidx%tracklength+2]
    if hillNow==nil then hillNow=0 end
    if hillNext==nil then hillNext=0 end
    height = (hillNow + (hillNext-hillNow)*(distance%100)/100)*50
    roadh = 78 + height

    -- scroll mountains left and right as we turn
    bgx=(bgx-turn*(speed/maxspeed)*0.75)%128

    update_cars()
    update_roadside()
end

----------------------------
--- DRAW ---
----------------------------
function _draw()
    cls(col.blue3)
    
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
        line(flr(ledge), y, redge, y, roadcolor)
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
    draw_roadside()

    for car in all(cars) do
        drawobject(car)
    end


    -- DRAW PLAYER CAR
    spr(carspr,
    64-16+turn*16+x,
    96-height/15
    ,4,3)
end
