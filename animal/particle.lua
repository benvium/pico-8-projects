function particle_init()
    particles={}
end

function particle_update(self)
    if self.delay>0 then self.delay-=1 return end
    self.x+=self.dx
    self.y+=self.dy

    self.dy+=0.25

    if self.life~=nil then
        self.life-=1
    end

    if self.y>127 or self.x>127 or self.x<0 or self.y<0 or (self.life~=nil and self.life<0) then
        del(particles,self)
    end
end

function particle_draw(self)
    pset(self.x,self.y,self.col)
    if self.phase==0 then
        pset(self.x+1,self.y+1,self.col)
    else    
        pset(self.x-1,self.y,self.col)
    end    
end

function particle_add(x,y,dx,dy,col2,delay,life)
    if dx==nil then dx=0 end
    if dy==nil then dy=0 end
    if delay==nil then delay=0 end
    if col2==nil then col2=col.white end
    local ob = {
        x=x+rnd(4)-2,
        y=y+rnd(4)-2,
        h=1/8,
        w=1/8,
        dx=dx,
        dy=dy,
        col=col2,
        phase=0,
        delay=delay,
        life=life,
        draw=particle_draw,
        update=particle_update
    }
    add(particles,ob)
end

-- smoke = circles

function smoke_add(x,y,dy,cl,delay,size)
    if dy==nil then dy=0 end
    if delay==nil then delay=0 end
    if cl==nil then cl=col.white end
    if size==nil then size=2 end
    local ob = {
        x=x+rnd(4)-2,
        y=y+rnd(4)-2,
        type=type,
        dx=0,
        dy=dy,
        dr=-0.15,
        r=size+rnd(2),
        phase=0,
        col=cl,
        delay=delay,
        draw=smoke_draw,
        update=smoke_update
    }
    add(particles,ob)
end

function smoke_update(self)
    if self.delay~=nil and self.delay>0 then
        self.delay-=1
        return
    end
    self.x+=self.dx
    self.y+=self.dy
    -- self.phase=(self.phase+1)%2

    -- change size
    self.r+=self.dr

    -- if 0 remove
    if self.r<=0 then
        del(particles,self)
    end
end

function smoke_draw(self)
    circfill(self.x,self.y,self.r,self.col)
end