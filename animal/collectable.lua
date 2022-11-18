-- replace collectable tiles with sprites
function collectable_init()
    collectables={}
    for x=0,16 do
        for y=0,16 do
            local t=mget(x,y)
            local info = collectable_types[t]
            if info~=nil then 
                -- remove tile
                mset(x,y,0)
                collectable_add(x*8,y*8,t,info)
            end
        end
    end
end


function collectable_update(self)
    if self._update~=nil then
        self:_update()
    end
end

function collectable_del(self)
    if player.carry_item==self then
        player.carry_item=nil
    end
    del(obs,self)
    del(collectables,self)
end

function collectable_re_add(self)
    add(obs,self)
    add(collectables,self)
end

function collectable_draw(self)
    if self._draw==nil then
        spr(self.spr, self.x, self.y, self.w, self.h)
    else
        self:_draw()
    end
end

function collectable_add(x,y,t,info)
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
        carry=info.carry,
        edible=info.edible,
        eat=info.eat,
        _collect=info.collect,
        _update=info.update,
        _draw=info.draw,
        update=collectable_update,
        draw=collectable_draw,
    }
    add(collectables,ob)
    add(obs,ob)
    return ob
end

function apple_kill(self)
    collectable_del(self)
    particle_add(self.x+3,self.y+3,(rnd(5)-2.5)/2,(rnd(5)-2.5)/25,col.red1,0,10)
    particle_add(self.x+3,self.y+3,(rnd(5)-2.5)/2,(rnd(5)-2.5)/2,col.red2,0,10)
    particle_add(self.x+3,self.y+3,(rnd(5)-2.5)/2,(rnd(5)-2.5)/2,col.red1,0,10)
    particle_add(self.x+3,self.y+3,(rnd(5)-2.5)/2,(rnd(5)-2.5)/2,col.red2,0,10)
end

collectable_types = {
    -- apple
    [52]={
        health=4,
        carry=true,
        eat=function(self)

            sfx(4,0)

            self.health-=1
            self.spr=(4-self.health)+52
            if self.health<=0 then
                apple_kill(self)
            else
                particle_add(self.x+3,self.y+3,(rnd(5)-2.5)/2,(rnd(5)-2.5)/2,col.white,0,10)
                particle_add(self.x+3,self.y+3,(rnd(5)-2.5)/2,(rnd(5)-2.5)/2,col.white,0,10)
            end
        end,
    },
    [48]={
        health=300,
        carry=true,
        update=function(self)
            self.health-=1

            printh("egg health: "..self.health)

            if self.health==180 then
                sfx(7,0)
            end

            if self.health<180 then
                self.spr=49
            end
            if self.health<120 then
                self.spr=50
            end
            if self.health<60 then
                self.spr=51
            end
            if self.health<=0 then
                collectable_del(self)
                sfx(8,0)
                -- becomes a chicken!
                baddie_add(self.x,self.y,34,baddie_types[34])
            end
        end
    }
}