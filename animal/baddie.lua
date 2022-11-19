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

            if info~=nil and info.update~=nil then
                info.update(self)
            end
        end,
        _draw=info.draw,
        draw=baddie_draw
    }
    add(obs,ob)
    add(baddies,ob)
    return ob
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

function chicken_explode(self)
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

    -- damage nearby chickens
    for b in all(baddies) do
        if b.t==34 then
            local dx = b.x-self.x
            local dy = b.y-self.y
            local d = sqrt(dx*dx+dy*dy)
            if d<48 then
                b.health-=75
                if d<32 then
                    b.health-=150

                    if d<16 then
                        b.health-=300
                    end
                end
                -- move chicken away
                b.dx = dx/d*2
                b.dy = dy/d*2
            end
        end
    end

    -- destroy nearby collectables
    for c in all(collectables) do
        local dx = c.x-self.x
        local dy = c.y-self.y
        local d = sqrt(dx*dx+dy*dy)
        if d<32 then
            apple_kill(c)
        end
    end

    -- kill player if nearby
    -- todo make work?
    -- if player~=nil then
    --     local dx = player.x-self.x
    --     local dy = player.y-self.y
    --     local d = sqrt(dx*dx+dy*dy)
    --     if d<32 then
    --         player.health=0
    --     end
    -- end

    exploded+=1

    if #baddies<=0 then
        local isHighscore = score > high_score
        if isHighscore then
            dset(0, score)
        end
        mode="end"
        dtb_disp("all your chickens asplode!")
        if isHighscore then
            dtb_disp("new high score! " .. score)
        else
            dtb_disp("you scored "..score.." points. the high score is "..high_score)
        end
        dtb_disp("why not try again?", function()
            mode="intro"
            _init()
        end)
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

            if self.health<300 and self.health>0 then
                local h = min(self.health/300,300)
                rectfill(self.x,self.y-1,self.x+7,self.y-1,0)
                rectfill(self.x,self.y-1,self.x+7*h,self.y-1,8)
            end
        end,
        update=function(self)

            if self.mode==nil then self.mode="ok" end

            if self.mode=="will_explode" then
                self.explode_timeout-=1

                -- vibrate violently!
                self.dx = rnd(3)-1.5
                self.dy = rnd(3)-1.5

                smoke_add(self.x+3+rnd(5)-2.5,self.y-5,-0.5,col.white,0,1)

                if self.explode_timeout<=0 then
                    chicken_explode(self)
                end
            end

            if self.mode=="ok" then
                self.health-=0.5

                -- EXPLODE if out of health
                if self.health<=0 then
                    self.mode="will_explode"
                    self.explode_timeout=40
                    return
                end

                -- warn!
                if self.health==150 then
                sfx(5,1) 
                elseif self.health==75 then
                sfx(6,1) 
                end

                -- lay eggs
                if self.health>500 then
                    if self.egg_timer==nil then
                        self.egg_timer=0
                    end
                    self.egg_timer+=1

                    -- more eggs as game goes on
                    if self.egg_timer>(600-flr(score/10)) then
                        self.egg_timer=0
                        sfx(2,0)
                        collectable_add(self.x,self.y-1,48,collectable_types[48])
                    end
                end

                -- munch through food
                if self.eat_cooldown~=nil then
                    self.eat_cooldown-=1
                    if self.eat_cooldown<0 then self.eat_cooldown=nil end
                else
                    local move = self.health<120 and 10 or 30
                    -- move
                    if flr(rnd(move))==1 then
                        self.dx = rnd(.5)-.25
                        self.dy = rnd(.5)-.25


                        -- speed up as game goes on
                        self.dx*=1+score/3000
                        self.dy*=1+score/3000
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
        end
    }
}