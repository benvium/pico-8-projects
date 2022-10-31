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
        draw=function(self)
            pset(self.x,self.y,self.col)
        end,
        update=function(self)
            self.x+=self.dx
            self.y+=self.dy
            
            if self.type=="shower" then
                self.dy+=0.25
            elseif self.type=="fire" then
                -- self.dx+=rnd(0.1)-0.05
                self.dy+=0.25
                self.col=self.cols[self.colidx+1]
                self.colidx=(self.colidx+1)%#self.cols
            end

            if self.y>127 or self.x<0 or self.y>127 then
                del(obs,self)
            end
        end
    }
    if type=="shower" then 
        ob.dx=rnd(5)-2.5
        ob.dy=rnd(3)-2.5
    elseif type=="fire" then
        ob.dx=rnd(1)-0.5
        ob.dy=-2
        ob.cols={col.red,col.orange,col.yellow}
        ob.colidx=flr(rnd(#ob.cols))
        ob.col=col.red
    end
    add(obs,ob)
end

-- function particle_add(x,y,col)
--     add(obs,{
--         x=x+rnd(4)-2,
--         y=y+rnd(4)-2,
--         dx=rnd(5)-2.5,
--         dy=rnd(5)-2,5,
--         col=col,
--         draw=function(self)
--             pset(self.x,self.y,self.col)
--         end,
--         update=function(self)
--             self.x+=self.dx
--             self.y+=self.dy
--             self.dy+=0.25
--             if self.y>127 then
--                 del(obs,self)
--             end
--         end
--     })
-- end