-------------------
-- roadside objects

obs = {}

-- TODO re-add the sea
function addSea(d)
    for i=d,d+200,2 do
        add(obs,{
            d=i,
            x=1,
            sprx=10*8, 
            spry=3*8,
            w=6,
            h=1,
            scalex=10,
            scaley=3,
            ax=-0.2,
            ay=-0.2,
            zIndex=-1
        })
    end
    for i=d+50,d+150,50 do
        add(obs,{
            d=i,
        x=1,
        sprx=112, 
        spry=8,
        w=2,
        h=2,
        scalex=4,
        scaley=4,
        ax=-3,
        ay=1,
        zIndex=-1
        })
    end
end

-- spawn an item
function addRoadsideItem(distance, type,forceX) 
    local ob
    if type=="tree" then
        ob={
            sprx=4*8, 
            spry=0,
            w=3,
            h=4,
            ax=1+rnd(1)/5, -- vary positions
            flipx=flr(rnd(2))==0,
        }
    elseif type=="lard" then
        -- Lard sign
        ob={
            sprx=7*8,
            spry=0,
            w=3,
            h=2,
            ax=1, -- anchor right
        }
    elseif type=="thirty" then
        -- 30 sign
        ob={
            sprx=7*8, 
            spry=2*8,
            w=1,
            h=2,
            ax=2, -- anchor right
        }
    elseif type=="person" then
        if rnd(2)<1 then
            -- woman
            ob={
                sprx=8*8, 
                spry=2*8,
                w=1,
                h=2,
                scale=2,
                ax=2, -- anchor right
            }
        else
            -- man
            ob={
                sprx=9*8, 
                spry=2*8,
                w=1,
                h=2,
                scale=2,
                ax=2, -- anchor right
            }
        end
    elseif type=="stand" then
        -- race stands
        ob={
            sprx=0, 
            spry=112,
            w=2,
            h=2,
            scale=4,
            ax=1,
            -- ax=1+rnd(0.3), -- anchor right
        }
    elseif type=="left" then
        ob={
            sprx=0, 
            spry=96,
            w=2,
            h=2,
            scale=3,
            ax=0,
            x=1,
            flipx=true
        }
    elseif type=="right" then
        ob={
            sprx=0, 
            spry=96,
            w=2,
            h=2,
            scale=3,
            ax=1,
            x=-1,
        }
    elseif type=="postLeft" then
        ob={
            sprx=16, 
            spry=96,
            w=1,
            h=4,
            scale=6,
            ax=1,
            x=-1,
        }
    elseif type=="postRight" then
        ob={
            sprx=16, 
            spry=96,
            w=1,
            h=4,
            scale=6,
            ax=0,
            x=1,
        }
    elseif type=="postTop" then
        ob={
            sprx=24, 
            spry=120,
            w=8,
            h=1,
            scale=6,
            ax=0.5,
            ay=1,
            x=0,
        }
    end
    if ob==nil then return end
    ob.d=distance
    if forceX~=nil then
        ob.x=forceX
        -- todo dupe
        ob.ax=forceX>0 and -ob.ax or ob.ax
        ob.flipx=forceX>0
    end
    if ob.x==nil then
        local flip = rnd(1)<0.5
        ob.x=flip and 1 or -1
        ob.ax= flip and -ob.ax or ob.ax
        ob.flipx=flip
    end
    
    if ob.scale==nil then
        ob.scale=3
    end 
    add(obs,ob,1)
end



local lastSpawned=0
local altLast=1

function spawn(distance)
    local details = getTrack2(distance)
    if details~=nil then
        local items=details[3]
        local itemMode=details[4]
        -- printh("items: "..tostring(details))
        -- local toSpawn={}

        if itemMode=="all" then
            for i=1,#items do
                local itemName=items[i]
                addRoadsideItem(distance, itemName)
            end 
        elseif itemMode=="both" then
            for itemName in all(items) do
                addRoadsideItem(distance, itemName,-1)
                addRoadsideItem(distance, itemName,1)
            end
        elseif itemMode=="alt" then
            altLast=((altLast+1)%#items)+1
            addRoadsideItem(distance, items[altLast])
        elseif itemMode=="random" or itemMode==nil then
            addRoadsideItem(distance, rnd(items))
        end
        
        
    end
end

function _init()
    -- spawn initial roadside objects
    for i=0,100,10 do
        spawn(i)
    end
end

function update_roadside()
     -- UPDATE RECTS OF ROADSIDE OBJECTS
    for ob in all(obs) do
        updateobject(ob)
    end

    -- spawn items in the distance
    if distance-lastSpawned>=10 then
        lastSpawned=flr(distance)
        spawn(distance+100)
    end
end

function draw_roadside()
    for ob in all(obs) do
        if ob.zIndex==-1 then
            drawobject(ob)
        end
    end
    for ob in all(obs) do
        if ob.zIndex==0 or ob.zIndex==nil then
            drawobject(ob)
        end
    end
    for ob in all(obs) do
        if ob.zIndex==1 then
            drawobject(ob)
        end
    end
end

function updateobject(ob)
    local obd=ob.d-distance
    local clipd=100

    -- remove object if behind you
    if obd<-20 and ob.keep~=true then
        del(obs,ob)
        return
    end

    if obd > -10 and obd<clipd then
        local ay=((clipd-obd)/clipd)^3.8
        local py=ay*roadh+(screensize-roadh)
        -- local much=py/roadh
        -- not quite right speed
        -- also duplicated from road drawing, move into function
        local perspective = 0.8*(ay)+0.08
        local midw=0.5+(turn*(1-ay))^3+((x/screensize)*(1-ay))
        local roadw=1.2
        roadw=roadw*0.5*perspective
        local px=(midw+roadw*ob.x)*screensize

        
        local scalex=ob.scale~=nil and ob.scale or ob.scalex
        local scaley=ob.scale~=nil and ob.scale or ob.scaley
        --sspr takes a RECTANGLE from the sprite sheet, not a sprite number (for some reason)
        local scaledh=ob.h*8*perspective*scaley
        local scaledw=ob.w*8*perspective*scalex
        ob.rect = {
            x=px-scaledw*ob.ax,
            y=py-scaledh*(ob.ay==nil and 1 or ob.ay),
            w=scaledw,
            h=scaledh,
        }

        -- check for collisions (for gems)
        if ob.collide and playerrect~=nil then
            if intersects(ob.rect, playerrect) then
                
                score+=1
                if score>=gems then
                    sfx(5,3)
                else
                    sfx(4,3)
                end
                -- todo score
                del(obs, ob)
            end
        end
    else
        ob.rect=nil
    end
end

-- call updateobject first!
function drawobject(ob) 
    if ob.rect==nil then return end
    
    sspr(
        ob.sprx,
        ob.spry,
        ob.w*8,
        ob.h*8,
        ob.rect.x,
        ob.rect.y,
        ob.rect.w,
        ob.rect.h,
        ob.flipx
    )

    
    -- rect(ob.rect.x, ob.rect.y, ob.rect.x+ob.rect.w, ob.rect.y+ob.rect.h, col.white)
end