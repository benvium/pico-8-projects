function particle_update(self)
    self.x+=self.dx
    self.y+=self.dy
    self.phase=(self.phase+1)%2
    
    if self.type=="shower" then
        self.dy+=0.25
    elseif self.type=="fire" then
        self.dy+=0.25
        -- self.col=self.cols[self.colidx+1]
        -- self.colidx=(self.colidx+1)%#self.cols
    elseif self.type=="smoke" then
        self.dy+=0.01
    end

    if self.y>127+level.tiley*8 then
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