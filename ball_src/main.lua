obs={}

function addBall(x,y,dx,dy)
    add(obs, {
        x=x,
        y=y,
        spr=1,
        ax=0.5,
        ay=0.5,
        w=8,
        h=8,
        dx=dx,
        dy=dy,
        type="ball"
    })
end

addBall(64,32,0,0)
addBall(32,64,-2,0)
addBall(48,12,3,0)

addBall(64,32,0,0)
addBall(32,54,-2,0)
addBall(48,22,3,0)

addBall(60,22,0,0)
addBall(35,24,-2,0)
addBall(42,12,3,0)

add(obs, {
    x=65,
    y=65,
    spr=5,
    w=8,
    h=8,
    dx=0,
    dy=0,
    type="player"
})

-- -- function bt(ob)
-- --     return ob.x+(ob.h*, ob
-- -- end

-- function canFall(ob) 
--     if mapFlag(ob.x+ob.h)
-- end

-- function mapFlag(x,y) 
--     return mget(x/8,y/8)
-- end

function trlbCol(ob,flag)
    
    local tl=map_flag(ob.x, ob.y, flag)
    -- local tm=map_flag(ob.x+ob.w/2, ob.y, flag)
    local tr=map_flag(ob.x+ob.w-1, ob.y, flag)
    -- local rm=map_flag(ob.x+ob.w-1, ob.y+ob.h/2, flag)
    local bl=map_flag(ob.x, ob.y+ob.h-1, flag)
    -- local bm=map_flag(ob.x+ob.w/2, ob.y+ob.h-1, flag)
    local br=map_flag(ob.x+ob.w-1, ob.y+ob.h-1, flag)
    -- local lm=map_flag(ob.x, ob.y+ob.h/2, flag)

    local res = {
        b=bl or br,
        r=tr or br,
        l=tl or bl,
        t=tl or tr,
        -- tm=tm,
        -- rm=rm,
        -- bm=bm,
        -- lm=lm
    }
    res.col=res.b or res.t or res.l or res.r

    printh(ob.x..","..ob.y..'='..(res.col and "YES" or "NO"))
    return res
end

function firstCol(ob,flag)
    local len = sqrt(ob.dx^2+ob.dy^2)

    -- won't be true if things move..
    if len==0 then
        return {col=false}
    end

    local i=0

    local okPos = {ob.x,ob.y}
    -- move in direction of vector until we hit something
    while true do
        i+=1
        if i>len then i=len end
        local newPos = {
            ob.x+ob.dx*(i/len),
            ob.y+ob.dy*(i/len)
        }
        local res = trlbCol({
                x=newPos[1],
                y=newPos[2],
                h=ob.h,
                w=ob.w
            },flag)
        if res.col then
            -- how much we couldn't MOVE
            ob.cx = (ob.x+ob.dx)-okPos[1]
            ob.cy = (ob.y+ob.dy)-okPos[2]
            ob.x = okPos[1]
            ob.y = okPos[2]
            return res
        end
        okPos = newPos
        if i==len then break end
    end
    -- didn't hit anything, move
    ob.x += ob.dx
    ob.y += ob.dy
    return {col=false}
end

function firstCol2(ob,flag)
    local myob={
        x=ob.x+ob.dx,
        y=ob.y+ob.dy,
        h=ob.h,
        w=ob.w
    }
    -- try destination
    local destCol = trlbCol(myob,flag)
    if not destCol.col then return {col=false} end

    local move=false
    -- if right, move left until 'out'
    if destCol.r and ob.dx>0 then
        ob.x-=1
        move=true
    end

    if destCol.l and ob.dx<0 then
        ob.x+=1
        move=true
    end

    if destCol.b and ob.dy>0 then
        ob.y-=1
        move=true
    end

    if destCol.t and ob.dy<0 then
        ob.y+=1
        move=true
    end

    if move then
        return firstCol(ob,flag) 
    end
    
    -- otherwise return the original one    
    return destCol
end

function _update()
    for ob in all(obs) do
        -- gravity!
        ob.dy+=0.25

        if ob.type=="player" then
            ob.dx=0
            ob.dy=0
            if btn(0) then
                ob.dx=-15
            end
            if btn(1) then
                ob.dx=15
            end
            if btn(2) then
                ob.dy=-15
            end
            if btn(3) then
                ob.dy=15
            end
        end

        local colz = firstCol(ob,0)

        if colz.col then
            if ob.type=="ball" then
                -- if colz.b then     
                --     if (abs(ob.dy)<1.5) then 
                --         ob.dy=0
                --         -- friction
                --         ob.dx*=0.98
                --     else  
                --         ob.dy=-(ob.dy*0.8)
                --         ob.dx+=rnd(0.5)-0.25
                --     end
                -- end
                -- -- if colz.t then     
                -- --     ob.dy=2 ---(ob.dy*0.6)
                -- -- end
                -- if (colz.r or colz.l) and not colz.b then
                --     ob.dx=-ob.dx*0.6
                -- end
            end
            if ob.type=="player" then
                if colz.l or colz.r then
                    ob.dx=0
                end
                if colz.t or colz.b then
                    ob.dy=0
                end
            end
        end 
    end

    if btn(5) then
        if not wasBtn5 then
            wasBtn5=true
            for ob in all(obs) do
                ob.dy-=3+rnd(3)
                ob.dx+=rnd(3)-1
            end
        end
    else
        wasBtn5=false
    end
end

wasBtn5=false

function _draw()
    cls(0)
    map(0,0,0,0,16,16)
    for ob in all(obs) do
        spr(ob.spr, ob.x, ob.y, ob.w/8,ob.h/8)

        if ob.type=="player" then
            print(ob.x.." "..ob.y.." "..ob.dx.." "..ob.dy, 7)
        end
    end
end
