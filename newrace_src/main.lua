function race_init() 
    -- current player/car
    distance=0 -- distance around the track
    lap=1
    score=0
    starttime=time()
    laptimes={}
    enginesfx=-1
    speed=0
    x=0
    dx=0
    skid=0
    carspr=0x040
    playerrect = nil
    turn=0 -- how far track is turning left/right
    height=0 -- current fake hill height
    bgx=0 -- background x position
    rumbley=0 -- shake the car when off-road
    roadh=78+height -- size of the road
    lastAmbience=0 -- SFX for certain bits of course
end

mode="home"

--consts
screensize=128
maxspeed=1.5
steerspeed=2
throwspeedconst=2.5
acceleration=0.005


function _init()
    if mode=="home" then
        home_init()
    elseif mode=="race" then
        race_init()
    elseif mode=="end" then
        end_init()
    end
end

----------------------------
--- UPDATE ---
----------------------------
function _update60()
    if mode=="home" then
        home_update()
    elseif mode=="end" then
        end_update()
    elseif mode=="race" then
        -- steering
        if btn(1) then
            dx=speed*steerspeed
        elseif btn(0) then
            dx=-speed*steerspeed
        else
            dx=0
        end
        if btn(5) then
            -- temporary debug warp speed!
            speed=min(maxspeed,speed+acceleration)
        else
            speed=max(0,speed-0.01)
        end
        if btn(4) then
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
        else
            sfx(14,2)
        end
        
        -- move down the track
        distance=distance+speed
        local newLap=flr(distance/trackLength2)+1
        if newLap>lap then
            laptimes[lap]=time()-starttime
            starttime=time()
            lap=newLap
            
            if (newLap>=6) then
                mode ="end"
                end_init()
                return
            else
                sfx(7,3)
            end
        end

        -- get track
        local trackNow,through=getTrack2(distance)

        -- ambient SFX
        local ambience=trackNow[6]
        if ambience~=lastAmbience then
            if ambience~=nil then
                sfx(ambience,0)
            else
                sfx(-1,0)
            end
            lastAmbience=ambience
        end

        -- interpolate between turns
        local turnNow=trackNow[2]
        local trackNext=getTrack2((distance-through)+trackNow[1])
        local turnNext=trackNext[2]
        local turnDiff=turnNext-turnNow
        turn = (through/trackNow[1])*turnDiff+turnNow

        -- interpolate between hills
        local hillNow = trackNow[5]
        local hillNext = trackNext[5]
        if hillNow==nil then hillNow=0 end
        if hillNext==nil then hillNext=0 end
        local hillDiff=hillNext-hillNow
        height = (through/trackNow[1]) * hillDiff+hillNow
        roadh = 78 + height*50

        -- scroll mountains left and right as we turn
        bgx=(bgx-turn*(speed/maxspeed)*0.75)%128

        update_cars()
        update_roadside()

        update_player()
        pts_update()
    end
end

----------------------------
--- DRAW ---
----------------------------
function _draw()
    if mode=="home" then
        home_draw()
    elseif mode=="end" then
        end_draw()
    elseif mode=="race" then

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
end
