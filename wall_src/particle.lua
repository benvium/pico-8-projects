function particle_add_at_ob(self,col)
    local x =self.x+self.hitbox.x+self.hitbox.w/2
    local y= self.y+self.hitbox.y+self.hitbox.h/2
    add(obs,{
        x=x+rnd(4)-2,
        y=y+rnd(4)-2,
        h=1/8,
        w=1/8,
        dx=rnd(5)-2.5,
        dy=rnd(5)-2,5,
        col=col,
        draw=function(self)
            pset(self.x,self.y,self.col)
        end,
        update=function(self)
            self.x+=self.dx
            self.y+=self.dy
            self.dy+=0.25
            if self.y>127 then
                del(obs,self)
            end
        end
    })
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