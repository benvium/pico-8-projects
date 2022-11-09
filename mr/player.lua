function player_kill()
    -- _init()
    p.mode="dead"
    p.phase=60

    for i=0,10 do
        local x=p.x+rnd(8)
        local y=p.y+rnd(8)
        local vx=rnd(2)-1
        local vy=rnd(2)-1
        local c=7
        if rnd(1)<0.5 then
            c=8
        end
        particle_add(x,y,vx,vy,c)
        sfx(fx.die,0)
    end
end

function player_init()
    return {
        x=16,
        y=16,
        spr=16,
        mode="play",
        w=1,
        h=1,
        hitbox={
            x=1,
            y=1,
            w=6,
            h=6
        },
        update=function(self)

            if self.mode=="play" then
                local p2x=flr((self.x+4)/8)*8
                local p2y=flr((self.y+4)/8)*8
                -- self.tx=p2x
                -- self.ty=p2y
                -- local tx=flr((self.x+4)/8)
                -- local ty=flr((self.y+4)/8)
                -- local dty=(self.y+4)-((p2.y*8)+4)
                -- local dtx=(self.x+4)-((p2.x*8)+4)
                if (btn(0)) then 
                    --left
                    self.x-=1
                    self.y+=(p2y-self.y)/4
                elseif (btn(1)) then 
                    self.x+=1
                    self.y+=(p2y-self.y)/4

                elseif (btn(2)) then 
                    self.y-=1
                    self.x+=(p2x-self.x)/4
                elseif (btn(3)) then 
                    self.y+=1
                    self.x+=(p2x-self.x)/4
                end

                local tx=flr(flr(self.x+4)/8)
                local ty=flr(flr(self.y+4)/8)
                local t = mget(tx,ty)
                -- if t~=0 then
                    -- dig!!
                    addHole(tx,ty)
                    updateEdges(tx,ty)
                    updateEdges(tx-1,ty)
                    updateEdges(tx+1,ty)
                    updateEdges(tx,ty-1)
                    updateEdges(tx,ty+1)
                -- end
            elseif self.mode=="dead" then
                self.spr=33
                self.phase-=1
                if self.phase==0 then
                    _init()
                end
            end
        end
    }
end