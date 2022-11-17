function apple_kill(self)
    sfx(fx.split,0)
    del(obs,self)
    del(apples,self)
    smoke_add(self.x+4,self.y+4,0,col.red1)
    smoke_add(self.x+4,self.y+4,0,col.red2)
    particle_add(self.x+4, self.y+4,-1,-1,col.red1)
    particle_add(self.x+4, self.y+4,1,-1,col.red2)
    particle_add(self.x+4, self.y+4,1,1,col.red1)
    particle_add(self.x+4, self.y+4,-1,1,col.red2)
end

function apple_update(self)
    local xb=self.x+3
    local yb=self.y+8
    -- fall if nothing underneath
    if not map_flag(xb,yb,0) then
        
        if self.mode=="idle" then
            if abs(p.x-self.x)<7 and p.y>self.y+6 and p.y<self.y+13 then
                -- do nothing if player right underneath, hold up!
                printh("hold up "..rnd())
                return
            else
                self.mode="fall"
                self.dy=1
                self.fall_distance=0
                sfx(fx.fall,0) 
                -- self.x=flr((self.x+3)/8)*8
            end
        end
        if self.mode=="fall" then
            self.y+=self.dy
            
            -- lock to 8x8 grid when falling
            local p2x=flr((self.x+3)/8)*8
            self.x+=(p2x-self.x)/6

            self.fall_distance+=1

            -- check for collision with other apples
            for o in all(obs) do
                if o~=self and o.type=="apple" and collide(self,o) then
                    apple_kill(self)
                    apple_kill(o)
                end
            end
        end
    elseif self.mode=="fall" then
        -- stop falling 
        self.mode="idle"
        self.dy=0
        sfx(-1,0)

        -- break on contact with ground if fallen far enough
        if self.fall_distance>8 then   
            apple_kill(self)
        else
            self.fall_distance=nil
        end
    end

    if collide(p,self)  then
        -- kill player if squashed
        if self.mode=="fall" then 
            if self.fall_distance~=nil and self.fall_distance>2 then
                player_kill()
                return
            else
                printh("caught apple in time")
                self.mode="idle"
                self.fall_distance=nil
                self.dy=0
                sfx(-1,0)
                -- stop it falling
                return
            end 
        elseif self.mode=="idle" then
            -- not falling, push apple sideways
            if p.x<self.x then
                if not map_flag(self.x+8,self.y+3,0) then
                    self.x+=1
                else
                    printh("cannot push right")
                    p.x-=1
                end
            elseif p.x>self.x then
                if not map_flag(self.x,self.y+3,0) then
                    self.x-=1
                else
                    printh("cannot push left")
                    p.x+=1
                end
            elseif p.y>=self.y then
                printh("cannot push up")
                p.y+=1
            end
        end
    end
end


function apple_add(tx,ty)
    local apple={
        x=tx*8,
        y=ty*8,
        dx=0,
        dy=0,
        spr=17,
        w=1,
        h=1,
        type="apple",
        hitbox={
            x=0,
            y=0,
            w=7,
            h=7
        },
        -- debug_label=function(self) 
        --     local msg=self.mode
        --     if self.fall_distance~=nil then
        --         msg=msg..","..self.fall_distance
        --     end
        --     msg=msg..","..self.x..","..self.y
        --     return msg
        -- end,
        mode="idle",
        update=apple_update,
    }
    add(obs,apple)
    add(apples,apple)
end