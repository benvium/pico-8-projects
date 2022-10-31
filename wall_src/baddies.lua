baddies={
    -- green
    [5]={
        killable=true,
        update=function(self)
            if self.dx==nil then
                self.dx=-0.5
            end
            -- this moves all the off-screen ones too
            if can_move(self,self.dx,0) then
                self.x+=self.dx
            else
                self.dx*=-0.5
            end
            -- fall
            if can_move(self,0,1) then
                self.y+=1
            end
        end
    },
    -- wolf/bat
    [7]={
        killable=true,
        update=function(self)
            if self.phase==nil then
                self.phase=rnd(60)
            end
            self.phase=(self.phase+1)%60
            local y=sin(self.phase/60)
            if can_move(self,0,y) then
                self.y+=y
            end
        end
    },
    -- thwomp
    [9]={
        killable=false,
        update=function(self)
            if self.phase==nil then
                self.phase=60
            end
            if self.mode==nil then
                self.mode="waitUp"
            end

            self.phase-=1
            if self.mode=="waitUp" then
                if self.phase<=0 then
                    self.mode="down"
                    self.dy=1
                end
            elseif self.mode=="down" then
                -- self.y+=1
                if can_move(self,0,self.dy) then
                    self.y+=self.dy
                    self.dy+=0.25
                else
                    if can_move(self,0,self.dy/2) then
                        self.y+=self.dy/2
                    end
                    sfx(fx.thump,1)
                    self.y=flr(self.y/8)*8
                    self.mode="waitDown"
                    self.phase=30
                end
            elseif self.mode=="waitDown" then
                if self.phase<=0 then
                    self.mode="up"
                end
            elseif self.mode=="up" then
                if can_move(self,0,-1) and self.y>0 then
                    self.y-=1
                else
                    self.mode="waitUp"
                    self.phase=60
                end
            end
            -- self.phase=(self.phase+1)%60
            -- local y=sin(self.phase/60)
            -- if can_move(self,0,y) then
            --     self.y+=y
            -- end
        end
    }
}