fx={
    flap=0,
    die=1,
    sing=2,
    win=3,
    off=4
}

function _init()
    mode="game"
    cam={0,0}
    camdx=0
    obs={}
    countdown=120
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

                if map_flag(p.x,p.y+6,1) and p.dy>0 then
                    p.dy=0
                end
            elseif p.mode=="dead" then
                if p.y==100 then
                    p.spr=9
                else 
                    p.spr=8
                end
                if p.x<(cam[1]-20) and p.y>=100 then
                    sfx(fx.off)
                    _init()
                end
            end

            

            if map_flag(p.x,p.y+6,3) then
                mode="win"
                countdown=240
                sfx(fx.win)
                return
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
    if mode=="game" then
        for ob in all(obs) do
            ob:update()
        end
        countdown-=1
        if countdown==0 then
            sfx(fx.sing)
        end
        if countdown<0 then
            camdx=min(camdx+0.05,1)
            cam[1]=(cam[1]+camdx)%(128*8)
        end
    elseif mode=="win" then
        countdown-=1
        if countdown<0 then
            _init()
        end
    end
end

function _draw()
    cls(col.blue1)

    if mode=="game" then

        camera(0,0)
         --background parallax

         map(16,32,0,0,16,16)
         local bgw=16
         local bgtilex=flr(cam[1]/4/8)%bgw
         local bgoffsetx=8-(cam[1]/4)%8-8
         local bgtilew=bgw-bgtilex
         map(bgtilex,32,bgoffsetx,-24,bgtilew,16)
         -- draw wrapped-around background
         map(0,32,(16-bgtilex)*8+bgoffsetx,-24,bgtilex+1,16)

        --background parallax
        bgw=16
        bgtilex=flr(cam[1]/2/8)%bgw
        bgoffsetx=8-(cam[1]/2)%8-8
        bgtilew=bgw-bgtilex
        map(bgtilex,16,bgoffsetx,0,bgtilew,16)
        -- draw wrapped-around background
        map(0,16,(16-bgtilex)*8+bgoffsetx,0,bgtilex+1,16)
        -- level
        map(flr(cam[1]/8),0,8-cam[1]%8-8,0,17,16)

        camera(cam[1],0)
        print("press x or z to flap!",24-1,32,col.black)
        print("press x or z to flap!",24+1,32,col.black)
        print("press x or z to flap!",24,32,col.white)
        for ob in all(obs) do
            spr(ob.spr, ob.x, ob.y)
        end
    elseif mode=="win" then
        cls(col.blue1)
        camera(0,0)
        map(111,0,0,0,16,16)
        print("home safe!",20,32,col.white)
    end
end