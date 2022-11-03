function baddie_update(self,info,t)
    -- do nothing if not on screen
    if self.x>cam[1]+128 or self.x<cam[1]-8 then
        return
    end
    
    if info~=nil and info.update~=nil then
        info.update(self)
    end

    -- remove when off-screen
    if self.x<cam[1]-self.hitbox.w then
        del(obs,self)
    end

    baddie_collide(self,t)
end

function baddie_collide(self,t)
    if p.mode=="dead" then return end

    local invincible=p.powerup=="ultrameat"

    local shot=false
    for bl in all(p.bullets) do
        stop()
        if collide(self,bl) then
            shot=true
            break
        end
    end

    if collide(self,p) or shot then

        if self.dangerous==nil or self.dangerous then
            -- determine if player should die or baddie
            if (((self.y-p.y)>1) and self.killable) or invincible then
                sfx(fx.kill,0)
                del(obs,self) 
                for i=1,5 do
                    particle_add_at_ob(self,col.green2)
                    particle_add_at_ob(self,col.green1)
                    particle_add_at_ob(self,col.brown)
                end
                -- add 'squashed' version and animate downwards
                add(obs,{
                    x=self.x,
                    y=self.y,
                    spr=t+1,
                    w=1,
                    h=1,
                    update=function(self)
                        self.y+=1
                        if self.y>128 then
                            del(obs,self)
                        end
                    end
                })
                if not invincible then
                    p.mode="jump"
                    p.jump=-3
                end
            else
                if not shot then
                    player_kill()   
                end
            end
        end
    end
end

baddies={
    -- mini horse
    [34]={
        update=function(self)
            self.dangerous=false

            -- if self.phase==nil then
            --     self.phase=rnd(60)
            --     self.orig_y=self.y
            -- end

            -- local dy=0
            -- if self.phase<30 then
            --     dy-=0.1
            -- elseif self.phase<40 then
            --     dy+=0.1
            -- end
            -- self.y=self.y-1

            if collide(self,p) then
                del(obs, self)
                p.powerup='horse'
                sfx(fx.horse,3)
            end
        end
    },
    -- green
    [5]={
        killable=true,
        update=function(self)
            if self.dx==nil then
                self.dx=-0.5
            end
            -- this moves all the off-screen ones too
            if can_move(self,self.dx,0) then
                self.x+=self.dx
            else
                self.dx*=-0.5
            end
            -- fall
            if can_move(self,0,1) then
                self.y+=1
            end
        end
    },
    -- wolf/bat - vertical
    [7]={
        killable=true,
        update=function(self)
            if self.phase==nil then
                self.phase=rnd(60)
            end
            self.phase=(self.phase+1)%60
            local y=sin(self.phase/60)
            if can_move(self,0,y) then
                self.y+=y
            end
        end
    },
     -- wolf/bat - horizontal
     [62]={
        killable=true,
        update=function(self)
            if self.phase==nil then
                self.phase=rnd(60)
            end
            self.phase=(self.phase+1)%60
            local dx=sin(self.phase/60)
            if can_move(self,0,dx) then
                self.x+=dx
            end
        end
    },
    -- munch plant
    [24]={
        killable=true,
        update=function(self)
            if p.mode=="dead" then
                return
            end

            local dx=p.x-self.x
            local dy=p.y-self.y
            local dist=sqrt(dx*dx+dy*dy)
            self.spr=24
            if dist < 32 then
                if can_move(self,dx/20,0) then
                    self.x+=dx/30
                    self.spr=41
                end
            end
        end
    },
    -- bullet bills
    [3]={
        killable=true,
        update=function(self)
            if self.phase==nil then
                self.phase=0
                sfx(fx.gun,1)
            end
            self.phase=(self.phase+1)%10
            self.x-=1
            self.y=self.y+(sin((self.x-cam[1])/128)/8)

            if self.phase==0 then
                particle_add_at_ob(self, col.white, "smoke")
            end
        end
    },
    -- thwomp
    [9]={
        killable=false,
        update=function(self)
            if self.phase==nil then
                self.phase=60
            end
            if self.mode==nil then
                self.mode="waitUp"
            end

            self.phase-=1
            if self.mode=="waitUp" then
                if self.phase<=0 then
                    self.mode="down"
                    self.dy=1
                end
            elseif self.mode=="down" then
                if can_move(self,0,self.dy) then
                    self.y+=self.dy
                    self.dy+=min(2,0.25)
                else
                    if can_move(self,0,1) then
                        self.y+=1
                    end
                    sfx(fx.thump,1)
                    self.y=flr(self.y/8)*8
                    self.mode="waitDown"
                    self.phase=30
                end
            elseif self.mode=="waitDown" then
                if self.phase<=0 then
                    self.mode="up"
                end
            elseif self.mode=="up" then
                if can_move(self,0,-1) and self.y>0 then
                    self.y-=1
                else
                    self.mode="waitUp"
                    self.phase=60
                end
            end
            -- self.phase=(self.phase+1)%60
            -- local y=sin(self.phase/60)
            -- if can_move(self,0,y) then
            --     self.y+=y
            -- end
        end
    }
}