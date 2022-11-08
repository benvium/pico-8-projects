-- note: particles = {} defined in main

function particle_update(self)
    self.x+=self.dx
    self.y+=self.dy

    self.dy+=0.25

    if self.y>127 or self.x>127 or self.x<0 or self.y<0 then
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

function particle_add(x,y,dx,dy,col2)
    if dx==nil then dx=0 end
    if dy==nil then dy=0 end
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
        draw=particle_draw,
        update=particle_update
    }
    add(particles,ob)
end

function particle_add_at_ob(self,col2,type)
    if type==nil then type="shower" end
    local x =self.x+self.hitbox.x+self.hitbox.w/2
    local y= self.y+self.hitbox.y+self.hitbox.h/2
    local ob = {
        x=x+rnd(4)-2,
        y=y+rnd(4)-2,
        h=1/8,
        w=1/8,
        col=col2,
        type=type,
        phase=0,
        draw=particle_draw,
        update=particle_update
    }
    if type=="shower" then 
        ob.dx=rnd(5)-2.5
        ob.dy=rnd(3)-2.5
    elseif type=="fire" then
        ob.dx=0
        ob.dy=-1
    elseif type=="smoke" then
        ob.dx=0.5--rnd(5)-2.5
        ob.dy=rnd(0.25)
    end
    add(particles,ob)
end

-- smoke = circles

function smoke_add(x,y,dy,cl)
    if dy==nil then dy=0 end
    if cl==nil then cl=col.white end
    local ob = {
        x=x+rnd(4)-2,
        y=y+rnd(4)-2,
        type=type,
        dx=0,
        dy=dy,
        dr=-0.15,
        r=2+rnd(2),
        phase=0,
        col=cl,
        draw=smoke_draw,
        update=smoke_update
    }
    add(particles,ob)
end

function smoke_update(self)
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