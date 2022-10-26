-------------------
-- roadside objects

obs = {}

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

addSea(200)
addSea(800)

-- temp gen obs
for i=0,200 do
    local ob
    local obchoice=flr(rnd(5))
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
    elseif obchoice==2 then
        -- 30 sign
        ob={
            sprx=7*8, 
            spry=2*8,
            w=1,
            h=2,
            ax=2, -- anchor right
        }
    elseif obchoice==3 then
        -- woman
        ob={
            sprx=8*8, 
            spry=2*8,
            w=1,
            h=2,
            scale=2,
            ax=2, -- anchor right
        }
    elseif obchoice==4 then
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

    ob.d=i*10

    -- no objects during addSea
    -- if ((ob.d>200 and ob.d < 400) or (ob.d>800 and ob.d<100)) then
    --     return
    -- end

    local isLeft=flr(rnd(2))==0;
    ob.x=isLeft and -1 or 1
    if ob.scale==nil then
        ob.scale=3
    end 
    if not isLeft then
        ob.ax = -ob.ax
        -- flip anchor
    end
    add(obs, ob, 1)
end





function update_roadside()
     -- UPDATE RECTS OF ROADSIDE OBJECTS
    for ob in all(obs) do
        updateobject(ob)
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
    if obd > -10 and obd<clipd then
        local ay=((clipd-obd)/clipd)^3.5
        -- not quite right speed
        -- also duplicated from road drawing, move into function
        local perspective = 0.8*(ay)+0.08
        local midw=0.5+(turn*(1-ay))^3
        local roadw=1.2
        roadw=roadw*0.5*perspective
        local px=(midw+roadw*ob.x)*screensize

        local py=ay*roadh+(screensize-roadh)
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
end