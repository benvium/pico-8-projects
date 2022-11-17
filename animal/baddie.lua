-- function baddie_update(self,info,t)
--     -- do nothing if not on screen
--     if self.x>cam[1]+128 or self.x<cam[1]-8 then
--         return
--     end
    
--     if info~=nil and info.update~=nil then
--         info.update(self)
--     end

--     -- remove when off-screen
--     if self.x<cam[1]-self.hitbox.w then
--         del(obs,self)
--     end

--     baddie_collide(self,t)
-- end

function baddie_draw(self)
    if self._draw then 
        self:_draw()
    else
        spr(self.spr, self.x, self.y, self.w, self.h, (self.dx or 0)<0)
    end
end

function baddie_add(x,y,t,info)
    local ob = {
        x=x,
        y=y,
        spr=t,
        t=t,
        w=1,
        h=1,
        hitbox={
            x=0,
            y=0,
            w=7,
            h=7
        },
        health=info.health,
        update=function(self)
            -- move
            if can_move(self,self.dx or 0, self.dy or 0, 0) then
                self.x+=self.dx or 0
                self.y+=self.dy or 0
            end

            -- -- do nothing if not on screen
            -- if self.x>cam[1]+128 or self.x<cam[1]-8 then
            --     return
            -- end
            
            if info~=nil and info.update~=nil then
                info.update(self)
            end

            -- -- remove when off-screen
            -- if self.x<cam[1]-self.hitbox.w then
            --     del(obs,self)
            -- end
        end,
        _draw=info.draw,
        draw=baddie_draw
    }
    add(obs,ob)
    return ob
end

function baddie_collide(self,t)

end

-- replace baddie and collectable tiles with sprites
function baddie_init()
    baddies={}
    for x=0,16 do
        for y=0,16 do
            local t=mget(x,y)
            local info = baddie_types[t]
            if info~=nil then 
                -- remove tile
                mset(x,y,0)
                baddie_add(x*8,y*8,t,info)
            end
        end
    end
end

baddie_types={
    -- pig
    [25]={
        update=function(self)
            self.dx = rnd(3)-1.5
            self.dy = rnd(3)-1.5
        end
    },
    -- chicken
    [34]={
        health=600,
        draw=function(self)
            spr(self.spr, self.x, self.y, self.w, self.h, (self.dx or 0)<0)

            if self.health<300 then
                local h = min(self.health/300,300)
                rectfill(self.x,self.y-1,self.x+7,self.y-1,0)
                rectfill(self.x,self.y-1,self.x+7*h,self.y-1,8)
            end
        end,
        update=function(self)

            self.health-=0.5

            -- EXPLODE if out of health
            if self.health<=0 then
                del(obs,self)
                del(baddies,self)
                offset=0.1

                local tx=flr((self.x+3)/8)
                local ty=flr((self.y+3)/8)

                sfx(3,0)

                --- draw a hole
                mset(16+tx,48+ty,2)

                for i=1,10 do 
                    smoke_add(self.x+3+rnd(10)-5,self.y+3+rnd(10)-5,0,col.red1,0)
                    smoke_add(self.x+3+rnd(10)-5,self.y+3+rnd(10)-5,0,col.white,i*2)
                    smoke_add(self.x+3+rnd(10)-5,self.y+3+rnd(10)-5,0,col.red2,i*3)
                end
                
                for i=1,10 do
                    particle_add(self.x+3,self.y+3,rnd(5)-2.5,rnd(5)-2.5,col.white)
                    particle_add(self.x+3,self.y+3,rnd(5)-2.5,rnd(5)-2.5,col.yellow,i*2)
                    particle_add(self.x+3,self.y+3,rnd(5)-2.5,rnd(5)-2.5,col.red,i)
                end
                return
            end

            -- lay eggs
            if self.health>300 and flr(rnd(1000))==0 then
                sfx(2,0)
                collectable_add(self.x,self.y-1,48,collectable_types[48])
            end

            -- munch through food
            if self.eat_cooldown~=nil then
                self.eat_cooldown-=1
                if self.eat_cooldown<0 then self.eat_cooldown=nil end
            else
                local move = self.health<120 and 10 or 30
                -- move
                if flr(rnd(move))==1 then
                    self.dx = rnd(2)-1
                    self.dy = rnd(2)-1
                end

                if self.health<500 then
                    -- if it touches an apple, eat it a bit
                    for c in all(collectables) do
                        if c.eat~=nil and collide(self,c) then
                            self.dx=0
                            self.dy=0
                            c:eat()
                            self.eat_cooldown=60
                            self.health=min(self.health+200, 600)
                            break
                        end
                    end
                end
            end
        end
    }
}