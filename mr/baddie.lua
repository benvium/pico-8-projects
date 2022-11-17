function baddie_add(x,y)
    local baddie={
        x=x,
        y=y,
        spr=32,
        w=1,
        h=1,
        dx=1,
        dy=0,
        hitbox={
            x=0,
            y=0,
            w=7,
            h=7
        },
        -- debug_label=function(self) 
        --     local msg=self.dx..","..self.dy
        --     return msg
        -- end,
        update=baddie_update
    }
    add(obs, baddie)
    add(baddies, baddie)
end

function baddie_kill(self)
    sfx(fx.die,0)
    for i=1,10 do
        local x=self.x+rnd(8)
        local y=self.y+rnd(8)
        local vx=rnd(2)-1
        local vy=rnd(2)-1
        local c=7
        if rnd(1)<0.5 then
            c=8
        end
        particle_add(x,y,vx,vy,c)
    end
    del(obs,self)
    del(baddies,self)
end

function baddie_can_move(self, dx, dy)
    local mapCanMove = can_move(self,dx,dy)
    local appleCollide = false
    for apple in all(apples) do
        if will_collide(self,apple) then
            appleCollide=true
            if apple.mode=="fall" then
                baddie_kill(self)
                return
            else
                -- if can_move(self,-self.dx, -self.dy) then
                --     -- self.x
                -- end
                -- ideally push baddie away somehow
            end
        end
    end
    for baddie in all(baddies) do
        if baddie~=self and will_collide(self,baddie) then
            appleCollide=true
        end
    end
    return mapCanMove and not appleCollide
end

function baddie_update(self)
    local mx=self.x+4
    local my=self.y+4
    -- local tx=flr(flr(mx)/8)
    -- local ty=flr(flr(my)/8)
    -- local appleCollide=false
    -- local canMove=can_move(self,self.dx,self.dy)

    if baddie_can_move(self, self.dx, self.dy) then
        self.x+=self.dx
        self.y+=self.dy
    else

        -- try left
        local leftVec={-self.dy, self.dx}
        local rightVec={self.dy, -self.dx}
        local backVec={-self.dx, -self.dy}

        local order = rnd()>0.5 and {leftVec, rightVec, backVec} or {rightVec, leftVec, backVec}

        -- todo this will ALWAYS turn left
        -- for vec in all(order) do
        --     if baddie_can_move(self, vec[1], vec[2]) then
        --         self.dx=vec[1]
        --         self.dy=vec[2]
        --         break
        --     end
        -- end
        -- todo fiox above

        if baddie_can_move(self, order[1][1], order[1][2]) then
            self.dx=leftVec[1]
            self.dy=leftVec[2]
        elseif baddie_can_move(self, rightVec[1], rightVec[2]) then
            self.dx=rightVec[1]
            self.dy=rightVec[2]
        else
            -- reverse!
            self.dx=-self.dx
            self.dy=-self.dy
        end


        -- -- change direction..
        -- local opts={
        --     {1,0},
        --     {-1,0},
        --     {0,1},
        --     {0,-1}
        -- }
        -- local newdir=opts[flr(rnd(#opts))+1]
        -- self.dx=newdir[1]
        -- self.dy=newdir[2]
    end

    if collide(self,p) then
        player_kill()
    end
    

    -- printh(self.x.." "..self.y..""..(flr(self.x)%8)..' '..(flr(self.y)%8))
    -- if flr(self.x)%8~=0 or flr(self.y)%8~=0 then
    --     self.x+=self.dx
    --     self.y+=self.dy
    --     return
    -- end
    -- stop()

    -- if tx*8~=self.x and ty*8~=self.y then return end

    -- is current tile a choice point
    
    
    -- local left={self.dy,-1*self.dx}
    -- local right={self.dy,1*self.dx}
    -- local forwards={self.dx,self.dy}
    -- local canTurnLeft = not map_flag(mx+left[1]*4,my+left[2]*4,0)
    -- local canTurnRight = not map_flag(mx+right[1]*4,my+right[2]*4,0)
    -- local canGoForwards = not map_flag(mx+forwards[1]*4,my+forwards[2]*4,0)
    -- -- local canGoForwards = not map_flag(self.x,self.y,0)
    -- -- stop(canGoForwards)
    -- -- if canGoForwards then
    -- --     self.x+=self.dx
    -- --     self.y+=self.dy
    -- -- end
      
    -- -- end
    -- -- todo this'll go crazy in open areas..!

    -- local options={}
    -- if canTurnLeft then
    --     add(options,left)
    -- end
    -- if canTurnRight then
    --     add(options,right)
    -- end
    -- if canGoForwards then
    --     add(options,forwards)
    -- end
    -- -- stop(tostring(options))

    -- if #options==0 then
    --     -- no options, turn around
    --     self.dx=-1*self.dx
    --     self.dy=-1*self.dy
    -- else
    --     -- choose a random option (todo choose own towards player)
    --     local choice = options[flr(rnd(#options))+1]

    --     self.x+=choice[1]
    --     self.y+=choice[2]
    -- end
end