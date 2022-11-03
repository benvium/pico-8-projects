fx={
    jump=0,
    land=1,
    grab=2,
    coin=3,
    die=4,
    up=5,
    thump=6,
    kill=7,
    fanfare=8,
    gun=9,
    horse=12,
    shoot=13,
}

cartdata("benvium_jump_dev")

default_walkspeed=1

current_level=2

function _init()
    level=levels[current_level]
    music(-1)
    if level.music~=nil then
        music(0)
    end

    particles={}

    mode="game"
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
    p = player_init()

    obs={}
    add(obs,p)

      -- replace baddie and collectable tiles with sprites
      for x=0,128 do
        for y=level.tiley,level.tiley+15 do
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
                            baddie_update(self,info,t)
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

                    local ob = {
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
                    }
                    -- copy over any extra info from the definition
                    if info.draw~=nil then
                        ob.draw=info.draw
                    end
                    if info.frames~=nil then
                        ob.frames=info.frames
                    end
                    add(obs,ob)
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

                mset(x,y,nt)
            end
        end
    end
end

function player_kill()
    if p.mode~="dead" then
        p.mode="dead"
        sfx(fx.die,0)
        for i=1,10 do
            particle_add_at_ob(p,col.blue2)
            particle_add_at_ob(p,col.blue3)
            particle_add_at_ob(p,col.white)
        end
    end
end

psprs={
    idle=1,
    walk={18,19,20},
    wall=17,
    jump=33,
    dead=49
}

function draw_object(ob)
    local isOnScreen=(ob.x+ob.h*8)>=cam[1] and ob.x<=cam[1]+128
    if not isOnScreen then return end

    -- custom draw function?
    if ob.draw then
        ob:draw(ob)
    elseif ob.spr then
        spr(ob.spr,ob.x,ob.y,ob.w,ob.h,ob.flipx,ob.flipy)
    end
end

function _update60()
    if mode=="game" then
        for ob in all(obs) do
            ob:update()
        end

        for pt in all(particles) do
            pt:update()
        end
        
        -- move camera to follow player
        if p.x>cam[1]+64 then
            cam[1]=p.x-64
        end
    elseif mode=="end" then
        end_update()
    end
end

function _draw()
    if mode=="game" then
        cls()
        camera(0,0)

        --background parallax
        local bgorigintilex=level.bgtilex
        local bgw=16
        local bgtilex=flr(cam[1]/2/8)%bgw
        local bgoffsetx=8-(cam[1]/2)%8-8
        local bgtilew=bgw-bgtilex
        map(bgorigintilex+bgtilex,16,bgoffsetx,0,bgtilew,16)
        -- draw wrapped-around background
        map(bgorigintilex,16,(16-bgtilex)*8+bgoffsetx,0,bgtilex+1,16)

        -- level
        map(flr(cam[1]/8),level.tiley,8-cam[1]%8-8,0,17,16)

        camera(cam[1],level.tiley*8)

        for pt in all(particles) do
            pt:draw()
        end

        for ob in all(obs) do
            draw_object(ob)
        end
        camera(0,0)
        -- print(p.mode)
        -- print(p.phase)
        -- print(walkframe)
        -- print("obs:"..#obs)
    elseif mode=="end" then
        end_draw()
    end
end