fx={
    flap=0,
    die=1,
}

function _init()
    cam={0,0}
    obs={}
    -- the player
    p={
        x=32,
        y=64,
        h=1,
        w=1,
        spr=6,
        dy=0,
        mode="ok",
        update=function ()
            -- gravity
            p.dy=p.dy+0.08

            if p.mode=="ok" then
                if (btn(2) or btn(4) or btn(5)) and p.dy>0 then
                    sfx(fx.flap)
                    p.dy=-2
                end

                if p.dy>0 then
                    p.spr=6
                else
                    p.spr=7
                end
                p.x=cam[1]+32
            elseif p.mode=="dead" then
                if p.y==100 then
                    p.spr=9
                else 
                    p.spr=8
                end
                if p.x<(cam[1]-20) and p.y>=100 then
                    _init()
                end
            end

            p.y=max(0, min(p.y+p.dy,100))

            if (map_flag(p.x+6,p.y+2,0) 
            or map_flag(p.x+6,p.y+6,0))
            and p.mode ~="dead"
            then
                sfx(fx.die)
                p.mode="dead"
            end
        end
    }
    add(obs,p)
end

function _update60()
    for ob in all(obs) do
        ob:update()
    end
    cam[1]=(cam[1]+1)%(128*8)
end

function _draw()
    cls(col.blue1)

    

    -- --background parallax
    -- local bgw=16
    -- local bgtilex=flr(cam[1]/2/8)%bgw
    -- local bgoffsetx=8-(cam[1]/2)%8-8
    -- local bgtilew=bgw-bgtilex
    -- map(bgtilex,16,bgoffsetx,0,bgtilew,16)
    -- -- draw wrapped-around background
    -- map(0,16,(16-bgtilex)*8+bgoffsetx,0,bgtilex+1,16)
    camera(0,0)
    --background parallax
    local bgw=16
    local bgtilex=flr(cam[1]/2/8)%bgw
    local bgoffsetx=8-(cam[1]/2)%8-8
    local bgtilew=bgw-bgtilex
    map(bgtilex,16,bgoffsetx,0,bgtilew,16)
    -- draw wrapped-around background
    map(0,16,(16-bgtilex)*8+bgoffsetx,0,bgtilex+1,16)
    -- level
    map(flr(cam[1]/8),0,8-cam[1]%8-8,0,17,16)

    camera(cam[1],0)
    for ob in all(obs) do
        spr(ob.spr, ob.x, ob.y)
    end
end