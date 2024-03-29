function player_kill()
    if p.mode~="dead" and not p.invincible then

        if p.powerup=='horse' then
            p.powerup=nil
            
            local horse = baddie_add(p.x,p.y-3,34,baddies[34])
            -- horse.flipx=true
            horse.scared=true
            horse.scared_cooldown=30
            sfx(fx.horse_hit,2)

            -- make invincible for short time
            p.powerup="hit"
            p.poweruptime=15
            
            return
        end
        p.mode="dead"
        sfx(fx.die,0)
        for i=1,10 do
            particle_add_at_ob(p,col.blue2)
            particle_add_at_ob(p,col.blue3)
            particle_add_at_ob(p,col.white)
        end
    end
end


function player_init()
    p = {
        x=8,
        y=10+level.tiley*8,
        spr=1,
        w=1,
        h=1,
        mode="walk",
        walkspeed=1,
        jump=nil,
        double_jump=nil, -- todo ensure user has let go of jump first. also implement please
        flipx=false,
        wall=false,
        phase=0,
        bullets={}, -- e.g. horse carrot
        bullet_cooldown=0,
        powerup=nil, -- e.g. ultrameat
        poweruptime=0,
        coyote=0, -- time left to jump after falling
        hitbox={
            x=0,
            y=0,
            w=7,
            h=7
        },
        ---------------------------------------------------------------
        -- DRAW FUNCTION
        ---------------------------------------------------------------
        draw=function(self)
            local offsety=0
            local offsetx=0
            local s=self.spr
            if self.powerup=="ultrameat" then
                if flr(self.poweruptime)%2==0 then
                    pal(col.white, col.red2)
                    pal(col.grey2, col.red2)
                else
                    pal(col.white, col.black)
                    pal(col.grey2, col.black)
                end
            elseif self.powerup=="horse" then
                spr(34,self.x,self.y,1,1,self.flipx)
                offsety=-2
                offsetx=2*(self.flipx and -1 or 1)
                s=32
            end
            spr(s,self.x+offsetx,self.y+offsety,1,1,self.flipx)
            pal()
        end,
        ---------------------------------------------------------------
        -- UPDATE FUNCTION
        ---------------------------------------------------------------
        update=function(self) 

        -- POWERUPS
        p.invincible=self.poweruptime~=nil and self.poweruptime>0 and (self.powerup=="ultrameat" or self.powerup=="hit")
        local walkspeed = default_walkspeed
        if p.poweruptime~=nil and p.poweruptime>0 then
            p.poweruptime-=1
            if p.poweruptime==0 then
                p.powerup=nil
            end
        end

        if p.invincible then
            if self.powerup=="ultrameat" then
                walkspeed*=1.5
                smoke_add(self.x+self.w*4,self.y+self.h*4,0,col.red1)
            end
        end
        if self.powerup=="horse" then
            p.bullet_cooldown-=1
            wallspeed=1.5
            if btn(4) and #p.bullets<1 and p.bullet_cooldown<=0 then
                sfx(fx.shoot)
                p.bullet_cooldown=60
                local dx=4*(p.flipx and 1 or -1)
                
                local bullet={
                    x=self.x,
                    y=self.y-2,
                    h=1,
                    w=1,
                    spr=47,
                    flipx=p.flipx,
                    hitbox={
                      x=0,
                      y=0+3,
                      h=3,
                      w=8
                    },
                    update=function(self) 
                        if not can_move(self,dx,0,0) or self.x>127+16+cam[1] or self.x<-8-16+cam[1] then
                            del(obs,self)
                            del(p.bullets,self)
                            for i=1,3 do
                                particle_add_at_ob(self, col.orange)
                            end
                        end
                        self.x+=dx
                    end
                }
                add(obs, bullet,1)
                add(p.bullets, bullet)
            end
        end

        -- todo may not need this now
        if not btn(4) then
            canPress[4]=true
        end

        -- restart if you fall off the map
          if self.y>128+level.tiley*8 then
            _init()
            return
          end

          if self.mode=="dead" then
            self.y+=1
            self.spr=psprs.dead
            return
          end

          local canFall = can_move(self,0,1)
          local canGoRight = can_move(self,1,0)
          
          if canFall then
            -- cling to wall
            if not canGoRight  then
                if self.mode=="jump" then
                    self.spr=psprs.wall
                    sfx(fx.land,0)
                    smoke_add(self.x+6+rnd(1),self.y+3+rnd(1))
                    self.mode="wall"
                    self.flipx=false
                    self.x = flr(self.x/8)*8
                    self.double_jump=nil
                end
            
            elseif self.mode=="walk" then
                -- fall
                self.jump=1
                self.mode="jump"
            end
          else
            -- can't fall: end jump/fall
            if self.mode=="jump" then
                self.mode="walk"
                self.y = flr(self.y/8)*8
                self.double_jump=nil
                sfx(fx.land,0)
                smoke_add(self.x+3+rnd(1),self.y+7+rnd(1))
            end
          end

          -- wall-walking
          if self.mode=="wall" then

            

            if canFall then
                if flr(self.y%2)==0 then
                    smoke_add(self.x+6+rnd(1),self.y+6+rnd(1),0,col.grey2)
                end
                self.y+=1

                if canGoRight then
                    self.mode="jump"
                end
            end

            -- climb up
            if btn(2) and can_move(self,0,-1) then
                self.y-=2

                -- get-up
                if can_move(self,3,0) then
                    self.mode="walk"
                    self.x+=3
                    sfx(fx.land,0)
                    self.flipx=not self.flipx
                end
            end

            if not canFall then
                self.mode="walk"
                self.y = flr(self.y/8)*8
                self.flipx=not self.flipx
                -- face forwards
            end           
          end

          -- move lr - on floor, or in air
          if self.mode~="walljump" then
            local moved=false
            -- left
            if btn(0) then 
                if can_move(self,-walkspeed,0) then
                    self.x-=walkspeed
                    moved=true
                elseif can_move(self,-walkspeed/2,0) then
                    self.x-=walkspeed/2
                    moved=true
                end
                if self.mode=="wall" and moved then
                    -- let go
                    self.mode="jump"
                end
                if moved then
                    self.flipx=false
                end
                if self.x<cam[1] then
                    self.x=cam[1]
                end
            end
            
            -- right
            if btn(1) then 
                if can_move(self,walkspeed,0) then
                    self.x+=walkspeed
                    moved=true
                elseif can_move(self,walkspeed/2,0) then
                    self.x+=walkspeed/2
                    moved=true
                else
                    self.mode="wall"
                    self.flipx=false
                end
                if moved then
                    self.flipx=true
                end
            end
            if moved then
                self.phase=(self.phase+1)%30
            else
                self.phase=0
            end
          end
          -- jump - if on floor or from wall
          if btn(5) then
            canPress[5]=false

            -- jump from ground
            if self.mode~="jump" 
            and can_move(self,0,-2,0) 
            and self.y>2
            then
                self.double_jump='wait'
                if self.mode=="walk" then
                    self.mode="jump"
                    self.jump=-4
                    sfx(fx.jump,1)
                elseif self.mode=="wall" then
                    self.mode="walljump"
                    self.jump=-4
                    sfx(fx.jump,1)
                end
            elseif self.mode=="jump" and self.double_jump=='ok' then
                -- PERFORM DOUBLE JUMP
                self.jump=-4
                sfx(fx.jump2,1)
                for i=0,2 do
                    smoke_add(self.x+3+rnd(2),self.y+7+rnd(2))
                end
                self.double_jump='done'
            end

        elseif self.double_jump=='wait' then
            self.double_jump='ok'
        end
          if self.mode=="jump" then
            if self.jump==nil then self.jump=0 end
            if can_move(self,0,self.jump) then
                self.jump=min(3, self.jump+0.25)
                self.y+=self.jump
            else
                self.jump=nil
                self.mode="walk" -- will then fall
            end
          end

          if self.mode=="walljump" then
            if can_move(self,-0.5,self.jump) then
                self.jump+=0.25
                self.y+=self.jump
                self.x+=-0.5
            else
                -- can't walljump - fall
                self.mode="jump" 
            end
            if self.jump>-2 then
                self.mode="jump"
            end
          end

          if self.mode=="walk" then
            walkframe=flr((self.phase/30)*(#psprs.walk))+1
            self.spr=psprs.walk[walkframe]
          elseif self.mode=="jump" then
            self.spr=psprs.jump
          elseif self.mode=="wall" then
            self.spr=psprs.wall
          end

          -- dont allow going off top of screen
          if self.y<0 then
            self.y=0
          end
        end
    }
    return p
end