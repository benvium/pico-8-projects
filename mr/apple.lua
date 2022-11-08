function apple_kill(self)
    sfx(fx.split,0)
    del(obs,self)
    smoke_add(self.x+4,self.y+4,0,col.red1)
    smoke_add(self.x+4,self.y+4,0,col.red2)
    particle_add(self.x+4, self.y+4,-1,-1,col.red1)
    particle_add(self.x+4, self.y+4,1,-1,col.red2)
    particle_add(self.x+4, self.y+4,1,1,col.red1)
    particle_add(self.x+4, self.y+4,-1,1,col.red2)
end

function apple_add(tx,ty)
    add(obs,{
        x=tx*8,
        y=ty*8,
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
        mode="idle",
        update=function(self)
            if collide(p,self) then
                -- kill player if squashed
                if self.mode=="fall" then
                    if self.y<p.y then
                        player_kill()
                    end
                    return
                    -- push apple sideways
                elseif p.x<self.x then
                    if not map_flag(self.x+8,self.y+3,0) then
                        self.x+=1
                    else
                        p.x-=1
                    end
                elseif p.x>self.x and not map_flag(self.x,self.y+3,0) then
                    if not map_flag(self.x,self.y+3,0) then
                        self.x-=1
                    else
                        p.x+=1
                    end
                end
            end


            local xb=self.x+3
            local yb=self.y+8
            -- fall if nothing underneath
            if not map_flag(xb,yb,0) then

                -- ensure jumps to point where it'll fall
                -- todo 'sticks' if you keep moving
                local p2x=flr((xb)/8)*8
                
                self.x=p2x
                if self.mode=="idle" then
                    if abs(p.x-self.x)<7 and p.y>self.y+6 and p.y<self.y+10 then
                        -- do nothing if player right underneath, hold up!
                        printh("hold up "..rnd())
                    else
                        self.mode="fall"
                        self.fall_distance=0
                        sfx(fx.fall,0) 
                    end
                end
                if self.mode=="fall" then
                    self.y+=1
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
                -- break on contact
                self.mode="idle"
                sfx(-1,0)

                if self.fall_distance>8 then   
                    apple_kill(self)
                end
            end
        end
    })
end