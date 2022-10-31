collectable={
    -- coin
    [64]={
        phase=0,
        frames={64,65,66,65},
        update=function(self)
            if self.mode==nil then self.mode="idle" end
            local frames=collectable[64].frames
            if self.phase==nil then self.phase=0 end
            self.phase = (self.phase+1)%(#frames*5)
            self.spr = frames[flr(self.phase/5)+1]


            if self.mode=="idle" then
                if collide(self,p) then
                    self.mode="collect"
                    sfx(fx.coin,1)
                    self.collect=20
                    -- self.dead=true
                    -- player.coins+=1
                end
            elseif self.mode=="collect" then
                self.collect-=1
                if self.collect>0 then
                    self.y-=1
                else
                    del(obs,self)
                end
            end
        end
    }
}