function baddie_add(x,y)
    add(obs, {
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
        update=baddie_update
    })
end

function baddie_update(self)
    local mx=self.x+4
    local my=self.y+4
    -- local tx=flr(flr(mx)/8)
    -- local ty=flr(flr(my)/8)

    -- printh(self.x.." "..self.y..""..(flr(self.x)%8)..' '..(flr(self.y)%8))
    if flr(self.x)%8~=0 or flr(self.y)%8~=0 then
        self.x+=self.dx
        self.y+=self.dy
        return
    end
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