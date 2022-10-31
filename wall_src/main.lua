fx={
    jump=0,
    land=1,
    grab=2,
    coin=3,
    die=4,
    up=5
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
        mode="walk",
        jump=nil,
        jumpx=0,
        wall=false,
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

          local canFall = can_move(self,0,1)
          local canGoRight = can_move(self,1,0)
          
          if canFall then
            -- cling to wall
            if not canGoRight  then
                if self.mode=="jump" then
                    self.spr=psprs.wall
                    sfx(fx.grab,0)
                    self.jumpcooldown=4
                    self.mode="wall"
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

          self.jumpcooldown=max(0,self.jumpcooldown-1)

          -- move lr - on floor, or in air
          if self.mode~="wall" and self.mode~="walljump" then
            -- left
            if btn(0) then 
                if can_move(self,-2,0) then
                    self.x-=2
                elseif can_move(self,-1,0) then
                    self.x-=1
                end
            end
            -- right
            if btn(1) then 
                if can_move(self,2,0) then
                    self.x+=2
                elseif can_move(self,1,0) then
                    self.x+=1
                end
            end
          end
          -- jump - if on floor or from wall
          if (btn(2) or btn(5)) and self.jumpcooldown<=0 then
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
                self.jump+=0.25
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
            end
            if self.jump>-2 then
                self.mode="jump"
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

          if self.mode=="walk" then
            self.spr=psprs.walk
          elseif self.mode=="jump" then
            self.spr=psprs.jump
          elseif self.mode=="wall" then
            self.spr=psprs.wall
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
    camera(0,0)
    print(p.mode)
end