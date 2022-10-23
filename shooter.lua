
sprs={
    ship=1,
    laser=3,
}

p={
    x=5,
    y=64-8,
    dx=0,
    dy=0,
    spr=sprs.ship,
    h=2,
    w=2,
    update=function(self)
        if btn(0) then
            p.dx-=1
        end
        if btn(1) then
            p.dx+=1
        end
        if btn(2) then
            p.dy-=1
        end
        if btn(3) then
            p.dy+=1
        end
        -- shoot
        if btn(4) then
            add(obs, {
                x=p.x+6,
                y=p.y+6,
                dx=3,
                spr=sprs.laser,
                w=1,
                h=1,
                update=function (self)
                    self.x=self.x+self.dx
                    if self.x>128 then
                        -- remove
                        local d = del(obs,self)
                        self.x=0
                    end
                end
            })
        end
    
        p.x=max(0,min(128-16, p.x+p.dx))
        p.y=max(0,min(128-16, p.y+p.dy))
        p.dx=0
        p.dy=0
    end
}

obs={
    p,
}

function _update60() 
 for ob in all(obs)  do
    ob:update()
 end
end

bg = {
    x=0
}

function _draw()
    cls()
    print("obs:"..count(obs))
    map(0,0,bg.sx,0,16,16)
    for ob in all(obs) do
        spr(ob.spr, ob.x, ob.y, ob.w, ob.h)
    end
end