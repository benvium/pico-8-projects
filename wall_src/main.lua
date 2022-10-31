fx={
    jump=0,
    land=1,
    grab=2,
    coin=3,
    die=4
}

function _init()
    -- used to force you to let go of button 
    -- before you can jump again
    canPress={
        [4]=true,
    }
    cam={
        0
    }
    p = {
        x=8,
        y=10,
        spr=1,
        w=1,
        h=1,
        jump=nil,
        wall=false,
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

          self.spr=psprs.walk

          local canFall = can_move(self,0,1)
          local canGoRight = can_move(self,1,0)
          
          if canFall then
            -- cling to wall
            if not canGoRight then
                self.spr=psprs.wall
                self.jump=nil
                if not self.wall then
                    sfx(fx.grab,0)
                end
                self.wall=true
                self.x = flr(self.x/8)*8
            
            elseif self.jump==nil and self.coyote<=0 then
                -- fall
                self.jump=1
                self.spr=psprs.jump
                self.wall=false
            end
            self.coyote-=1
          else
            -- end jump/fall
            if self.jump~=nil then
                self.jump=nil
                self.y = flr(self.y/8)*8
                self.coyote=3
                sfx(fx.land,0)
            end
          end
          -- left
          if btn(0) then 
            if can_move(self,-2,0) then
              self.x-=2
            end
          end
          -- right
          if btn(1) then 
            if canGoRight then
              self.x+=2
            end
          end
          -- jump
          if btn(2) or btn(5) and canPress[4] then
            canPress[4]=false
            -- jump from ground
            if self.jump==nil then
                if not canFall or self.wall or self.coyote>0 then 
                    self.jump=-3
                    sfx(fx.jump,0)
                    if self.wall then
                        self.x-=2
                    end
                end
            end
        end
          if self.jump~=nil then
            self.spr=psprs.jump
            if can_move(self,0,self.jump) then
                self.jump+=0.25
                self.y+=self.jump
            else
                self.jump=nil
            end
          end

          -- push right
          if self.x<cam[1] then
            if canGoRight then
                self.x+=0.25
            elseif self.x<cam[1]-self.hitbox.w then
                sfx(fx.die,0)
                _init() 
            end
          end

          -- collect
          local noCoin,vx,vy=can_move(self,0,0,2)
          if not noCoin then
            mset(vx/8,vy/8,0)
            sfx(fx.coin,0)
          end
          
        end
    }

    obs={}
    add(obs,p)
end

psprs={
    walk=1,
    wall=17,
    jump=33
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
    cam[1]+=0.25
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
end