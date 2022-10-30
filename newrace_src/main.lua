
-- distance around the track
distance=0

-- current player/car
score=0

--consts
maxspeed=1.5
steerspeed=2
throwspeedconst=2
acceleration=0.005
--

enginesfx=-1
speed=0
x=0
dx=0
skid=0
carspr=0x040
playerrect = nil

-- how far track is turning left/right
turn=0
-- distance off the ground / fake hill height
height=0

-- background x position
bgx=0
screensize=128

-- size of the road
roadh=78+height

--
rumbley=0

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
    if btn(4) then
        speed=min(maxspeed,speed+acceleration)
    else
        speed=max(0,speed-0.01)
    end
    if btn(5) then
        speed=maxspeed*2
    end

    
    -- throw off sides during turns
    local throwspeed=turn*(speed/maxspeed)*throwspeedconst
    

    -- play skid sound
    local isSkid = abs(dx)>0.3 and abs(throwspeed)>0.3

    if skid==0 and isSkid then
        sfx(0,1)
    end
    if skid>0 and not isSkid then
        sfx(-1,1)
        skid=0
    end
    if isSkid then
        skid+=1
    end

    dx=dx-throwspeed

    x=x+dx

    -- if we go off the sides, slow down the car
    -- todo this should be based on the road width
    local off=60
    if x<-off or x>off then 
        if x<-off then x=-off end
        if x>off then x=off end
        if (speed>(maxspeed/4)) then
            speed*=0.95
        end
        rumbley=(rumbley+1)%3
        if rumble==false then
            rumble=true
            -- TODO the sound effect isn't working yet
            sfx(1,2)
        end
    else
        rumbley=0
        if rumble==true then
            rumble=false
            sfx(-1,2)
        end
    end

    -- engine sfx
    if speed<=0 then 
        sfx(9,2)
    elseif speed<maxspeed/4 then
        sfx(10,2)
    elseif speed<maxspeed/2 then
        sfx(11,2)
    elseif speed<maxspeed/1.5 then
        sfx(13,2)
    else--if speed<maxspeed/1.5 then
        sfx(14,2)
    end
    
    --
    

    -- move down the track
    distance=distance+speed

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

    update_player()
    pts_update()
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

    -- cam shake when you drive off edge
    camera(x,rumbley)
    
    

    -- draw road line-by-line
    for y1=0,roadh do
        local y=y1+screensize-roadh
        local much=y1/roadh
        local perspective = 0.8*(much)+0.08

        local roadw=1.2
        roadw=roadw*0.5*perspective
        local midw=0.5+(turn*(1-much))^3+((x/screensize)*(1-much))
        local edgew=roadw*0.2

        local lgrassw = (midw-roadw-edgew)*screensize
        local ledge = flr((midw-roadw)*screensize)
        local redge = (midw+roadw)*screensize
        local rgrass = (midw+roadw+edgew)*screensize

        
        local isStripe = sin(10*((1-perspective)^3)+(distance*0.17)%3.14)>0
        local shade2=shadinggrs[flr(much*10)+1]
        local grasscolor= isStripe and shade2[1] or shade2[2]

        shade2=shadinglns[flr(much*10)+1]
        local linecolor = isStripe and shade2[1] or shade2[2]

        local roadcolor=shadingroad[flr(much*10)+1]

        line(x, y, lgrassw, y, grasscolor)

        -- left edge
        line(lgrassw, y, ledge, y, linecolor)

        line(ledge, y, redge, y, roadcolor)
        
        line(redge,y,rgrass, y, linecolor)
        line(rgrass, y, screensize+x, y, grasscolor)

        -- line in center of road
        if isStripe then
            line((midw-roadw*0.035)*screensize, y, (midw+roadw*0.035)*screensize, y, linecolor)
        end

    end

 

    -- color(6)
    -- print(stat(7))
    -- print("distance: "..flr(distance))
    -- print("x: "..x)
    -- --print("track: "..getTrack(distance) and getTrack(distance) or -1)
    -- -- print(turn)
    -- print("skid:"..skid)
    

    -- DRAW ROADSIDE OBJECTS
    draw_roadside()

    for car in all(cars) do
        drawobject(car)
    end

    camera(0,0)
    pts_draw()
    camera(x,rumbley)

    -- DRAW PLAYER CAR
    local carx=64+x-16--64-16+turn*16+x
    local cary=96-height/15
    spr(carspr,
    carx,
    cary,
    4,3)

    if skid>0 then
        local s=skid%4==0 and 112 or 114
        spr(s,carx,cary+16,2,1)
        spr(s,carx+16,cary+16,2,1,true)
    end

    -- if playerrect~=nil then
    --     rect(playerrect.x,playerrect.y,playerrect.x+playerrect.w,playerrect.y+playerrect.h,col.white)
    -- end

    camera(0,0)
    draw_hud()
end