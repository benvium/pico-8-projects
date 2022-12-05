
-- adds a banner with the icon and number of items collected
-- floats up for a while then disappears
function board_collect_popover(n,itemScore,x)
    local t = (block_types[n] or {}).t
    local starty=15
    local endy=5
    local startx=x
    add(obs,{
        x=startx,
        y=starty,
        draw=function(self)
            rectfill(self.x-1,self.y-1,self.x+31,self.y+10,col.black)
            rectfill(self.x-2,self.y,self.x+32,self.y+9,col.black)
            rectfill(self.x,self.y,self.x+30,self.y+8,col.grey1)
            rectfill(self.x-1,self.y+1,self.x+30+1,self.y+7,col.grey1)
            spr(t,self.x+2,self.y,1,1)
            print("x "..itemScore,self.x+12,self.y+2,col.black)
            print("x "..itemScore,self.x+13,self.y+2,col.white)
        end,
        update=function (self) 
            self.y-=0.25
            if self.y<endy then
                del(obs,self)
            end
            smoke_add(self.x+rnd(30)-15, self.y-2, -0.3, col.white, rnd(4), 1)
        end
    })        
end