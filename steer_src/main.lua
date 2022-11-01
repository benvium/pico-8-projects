

function _init()
    cam={0,0}
    obs={}
    p={
        x=64-4,
        y=64-4,
        h=1,
        w=1,
        dx=0,
        dy=0,
        spr=16,
        angle=0,
        update=function(self)
            self.dx+=cos(self.angle/360)*0.01
            if self.dx>1 then
                self.dx=1
            elseif self.dx<-1 then
                self.dx=-1
            end
            if self.dy>1 then
                self.dy=1
            elseif self.dy<-1 then
                self.dy=-1
            end
            self.dy+=sin(self.angle/360)*0.01
            self.x=self.x+self.dx
            self.y=self.y+self.dy
            if self.x<0 then
                self.x=0
            end
            if self.x>127 then
                self.x=127
            end
            if self.y<0 then
                self.y=0
            end
            if self.y>127 then
                self.y=127
            end
            self.spr=(16+flr(self.angle/22.5))%32

            if btn(0) then
                self.angle=flr(self.angle+22.5/4)%360
            end
            if btn(1) then
                self.angle=flr(self.angle-22.5/4)%360
            end
        end
    }
    add(obs,p)
end

function draw_object(ob)
    -- local isOnScreen=(ob.x+ob.h*8)>=cam[1] and ob.x<=cam[1]+128
    -- if not isOnScreen then return end

    -- custom draw function?
    if ob.draw then
        ob:draw(ob)
    elseif ob.spr then
        spr(ob.spr,ob.x,ob.y,ob.w,ob.h,ob.flipx,ob.flipy)
    end
end

function _update60()
    for ob in all(obs) do
        ob:update()
    end
    
    -- move camera to follow player
    if p.x>cam[1]+64 then
        cam[1]=p.x-64
    end
end

function _draw()
    cls()
    camera(0,0)

    for ob in all(obs) do
        draw_object(ob)
    end
    print("angle: "..p.angle,0,0,7)
    print("spr: "..p.spr)
    print("x: "..flr(p.x).." y:"..flr(p.y))
    print("dx: "..p.dx.." dy:"..p.dy)
end