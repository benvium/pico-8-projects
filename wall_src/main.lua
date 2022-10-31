fx={
    jump=0,
    land=1,
    grab=2,
    coin=3,
    die=4,
    up=5,
    thump=6,
    kill=7,
    
}

function _init()
    -- force reload map
    reload(0x1000, 0x1000, 0x2000)
    -- used to force you to let go of button 
    -- before you can jump again
    canPress={
        [4]=true,
    }
    cam={
        0
    }
    -- player setup
    p = {
        x=8,
        y=10,
        spr=1,
        w=1,
        h=1,
        mode="walk",
        jump=nil,
        jumpx=0,
        flipx=false,
        wall=false,
        phase=0,
        jumpcooldown=0,
        coyote=0, -- time left to jump after falling
        hitbox={
            x=0,
            y=0,
            w=7,
            h=7
        },
        update=function(self) 
          if not btn(4) then
            canPress[4]=true
          end

          if self.mode=="dead" then
            self.y+=1
            self.spr=psprs.dead
            if self.y>128 then
                _init()
            end
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
                    self.jumpcooldown=4
                    self.mode="wall"
                    self.flipx=false
                    self.x = flr(self.x/8)*8
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
                self.coyote=3
                self.jumpcooldown=10
                sfx(fx.land,0)
            end
          end

          -- wall-walking
          if self.mode=="wall" then
            if btn(2) and can_move(self,0,-1) then
                self.y-=1

                -- get-up
                if can_move(self,3,0) then
                    self.mode="walk"
                    self.x+=3
                    sfx(fx.land,0)
                    self.flipx=true
                end
            end
            if btn(3) then
                if can_move(self,0,1) then
                    self.y+=1

                    -- fall-off
                    if can_move(self,1,0) then
                        self.mode="walk"
                    end
                else
                    self.mode="walk"
                end
            end
            
          end

          self.jumpcooldown=max(0,self.jumpcooldown-1)

          -- move lr - on floor, or in air
          if self.mode~="walljump" then
            local moved=false
            -- left
            if btn(0) then 
                if can_move(self,-2,0) then
                    self.x-=2
                    moved=true
                elseif can_move(self,-1,0) then
                    self.x-=1
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
                if can_move(self,2,0) then
                    self.x+=2
                    moved=true
                elseif can_move(self,1,0) then
                    self.x+=1
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
                self.phase=(self.phase+1)%30+1
                -- if self.phase%10==0 then
                --     sfx(fx.walk,0)
                -- end
            else
                self.phase=0
            end
          end
          -- jump - if on floor or from wall
          if btn(5) and self.jumpcooldown<=0 then
            canPress[4]=false
            -- jump from ground
            if self.mode~="jump" then
                if self.mode=="walk" then
                    self.mode="jump"
                    self.jump=-3
                    sfx(fx.jump,0)
                elseif self.mode=="wall" then
                    self.mode="walljump"
                    self.jump=-4
                end
            end
        end
          if self.mode=="jump" then
            if self.jump==nil then self.jump=0 end
            if can_move(self,0,self.jump) then
                self.jump=min(2, self.jump+0.25)
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

          -- collect
          local noCoin,vx,vy=can_move(self,0,0,2)
          if not noCoin then
            mset(vx/8,vy/8,0)
            sfx(fx.coin,0)
          end

          if self.mode=="walk" then
            walkframe=flr((self.phase/30)*(#psprs.walk))+1
            self.spr=psprs.walk[walkframe]
          elseif self.mode=="jump" then
            self.spr=psprs.jump
          elseif self.mode=="wall" then
            self.spr=psprs.wall
          end
        end
    }

    obs={}
    add(obs,p)

      -- replace baddie map tiles with sprites
      for x=0,128 do
        for y=0,15 do
            local t=mget(x,y)
            -- flag 3 means baddie
            local f=fget(t,3)
            if f then
                local info = baddies[t]
                if info~=nil then 
                    -- remove tile
                    mset(x,y,0)
                    -- add object
                    add(obs,{
                        x=x*8,
                        y=y*8,
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
                        killable=info.killable,
                        update=function(self)

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

                            baddieCollide(self,t)
                        end
                    })
                end
            end
            -- flag 4 means collectable
            local f=fget(t,4)
            if f then 
                local info = collectable[t]
                if info~=nil then 
                    -- remove tile
                    mset(x,y,0)
                    add(obs,{
                        x=x*8,
                        y=y*8,
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
                        update=function(self)

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

                            --baddieCollide(self,t)
                        end
                    })
                end
            end

            -- rewrite wall edges so we don't need to manually draw them
            -- 2=plain wall
            if t==2 then
                local above=mget(x,y-1)~=0
                local below=mget(x,y+1)~=0
                local left=mget(x-1,y)~=0
                local right=mget(x+1,y)~=0
                

                local nt=2
                if above and below and left and right then
                    nt=2
                elseif not above and not below and not left and not right then
                    -- single block
                    nt=59
                elseif not above and not below and not left and right then
                    nt=60
                elseif not above and not below and left and right then
                    nt=58
                elseif not left and above and right and below then
                    nt=10
                elseif not above and not right and not below and left then
                    nt=44
                elseif not above and not left and not right and below then
                    nt=13
                elseif not left and not right and above and below then 
                    nt=12
                elseif not left and not right and not below and above then
                    nt=14
                elseif not left and not above and right and below then
                    nt=26
                elseif not above and left and right and below then
                    nt=29
                elseif left and below and not above and not right then
                    nt=27
                elseif not right and above and left and below then
                    nt=11
                elseif not left and above and right and not below then
                    nt=42
                elseif not below and left and right and above then
                    nt=45
                elseif not below and not right and left and above then
                    nt=43
                end

                -- print("t"..t.." a:"..above.." b:"..below.." l:"..left.." r:"..right)
                -- stop()
                -- elseif not above and not below and left and right then
                --     nt=58
                --     -- across
                -- elseif above and below and not left and not right then
                --     nt=12
                --     -- up/down
                -- elseif above and not below and not left and not right then
                --     nt=28
                --     -- up
                -- elseif not above and below and not left and not right then
                --     nt=13
                --     -- down
                -- elseif not above and not below and left and not right then
                --     nt=44
                --     -- left
                -- elseif not above and not below and not left and right then
                --     nt=45
                --     -- right
                -- end

                mset(x,y,nt)


                -- if mget(x-1,y)==0 then
                --     -- one-thick wall
                --     if mget(x+1,y)==0 then
                --         mset(x,y,12)
                --     else
                --         -- left edge
                --         mset(x,y,10)
                --     end
                -- elseif mget(x+1,y)==0 then
                --     mset(x,y,11)
                -- end
            end
        end
    end
end

function baddieCollide(self,t)
    if collide(self,p) then
        if ((self.y-p.y)>3) and self.killable then
            sfx(fx.kill,0)
            del(obs,self) 
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
            p.mode="jump"
            p.jump=-3
        else
            if p.mode~="dead" then
                sfx(fx.die,0)
                p.mode="dead"
            end
        end

    end
end

function collide(a, b)
    return intersects({
        x=a.x+a.hitbox.x,
        y=a.y+a.hitbox.y,
        w=a.hitbox.w,
        h=a.hitbox.h
    },{
        x=b.x+b.hitbox.x,
        y=b.y+b.hitbox.y,
        w=b.hitbox.w,
        h=b.hitbox.h
    })
end

function intersects(a, b)
    local rectA={
        left=a.x,
        right=a.x+a.w,
        top=a.y,
        bottom=a.y+a.h
    }
    local rectB={
        left=b.x,
        right=b.x+b.w,
        top=b.y,
        bottom=b.y+b.h
    }
    return max(rectA.left, rectB.left) < min(rectA.right, rectB.right)
    and max(rectA.top, rectB.top) < min(rectA.bottom, rectB.bottom);
end

psprs={
    idle=1,
    walk={18,19,20},
    wall=17,
    jump=33,
    dead=49
}

function can_move(ob,dx,dy,flag)
    if flag==nil then flag=0 end
    local newx=ob.x+ob.hitbox.x+dx
    local newy=ob.y+ob.hitbox.y+dy
    local vx,vy
    vx=newx+ob.hitbox.w/2
    vy=newy+ob.hitbox.h
    local b=map_flag(vx,vy,flag)
    if b then return false,vx,vy end
    vx=newx
    vy=newy+ob.hitbox.h
    local bl=map_flag(vx,vy,flag)
    if bl then return false,vx,vy end
    vx=newx+ob.hitbox.w
    vy=newy+ob.hitbox.h
    local br=map_flag(vx,vy,flag)
    if br then return false,vx,vy end
    vx=newx+ob.hitbox.w/2
    vy=newy
    local t=map_flag(vx,vy,flag)
    if t then return false,vx,vy end
    vx=newx
    vy=newy
    local tl=map_flag(vx,vy,flag)
    if tl then return false,vx,vy end
    vx=newx+ob.hitbox.w
    vy=newy
    local tr=map_flag(vx,vy,flag)
    if tr then return false,vx,vy end
    vx=newx
    vy=newy+ob.hitbox.h/2
    local l=map_flag(vx,vy,flag)
    if l then return false,vx,vy end
    vx=newx+ob.hitbox.w
    vy=newy+ob.hitbox.h/2
    local r=map_flag(vx,vy,flag)
    if r then return false,vx,vy end
    
    return true
end

function draw_object(ob)
    spr(ob.spr,ob.x,ob.y,ob.w,ob.h,ob.flipx,ob.flipy)
end

function _update60()
    for ob in all(obs) do
        ob:update()
    end
    -- cam[1]+=0.25
    if p.x>cam[1]+64 then
        cam[1]=p.x-64
    end
end

function _draw()
    cls()
    camera(0,0)
    map(flr(cam[1]/2/8),16,8-(cam[1]/2)%8-8,0,17,16)
    map(flr(cam[1]/8),0,8-cam[1]%8-8,0,17,16)
    camera(cam[1],0)
    for ob in all(obs) do
        draw_object(ob)
    end
    camera(0,0)
    print(p.mode)
    print(p.phase)
    print(walkframe)
end