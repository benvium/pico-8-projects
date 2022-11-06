local trophy={
    update=function(self) 

        if collide(self,p) then
            mode="end"
            end_init()
        end
    end
}

collectable={
    -- spike
    [81]={
        update=function(self)
            if collide(self,p) then
                player_kill()
            end
        end
    },
    -- trampoline
    [82]={
        update=function(self)
            if self.orig_y==nil then
                self.orig_y=self.y
            end
            if collide(self,p) and p.y<self.y then
                sfx(fx.jump)
                p.mode="jump"
                p.jump=-7
                self.y=self.orig_y+4
            end
            if self.y>self.orig_y then
                self.y-=0.25
            end
        end
    },
    [98]=trophy,
    -- ultra meat
    [16]={
        update=function(self)
            if self.mode=="collect" then return end
            if self.phase==nil then
                self.phase=rnd(60)
            end
            self.phase=(self.phase+1)%60
            local y=sin(self.phase/60)*0.5
            self.y+=y


            if collide(self,p) then
                self.mode="collect"
                sfx(fx.fanfare,1)
                self.collect=100
                for i=1,2 do
                    particle_add_at_ob(
                        self,
                        col.white)
                end
            end
        end,
        draw=function(self)
            if self.mode=="collect" then
                self.collect-=1
                self.y-=1
                if self.collect<=0 then
                    del(obs,self)
                end

                local cx,cy=camera(0,0)
                local by=32
                local bx=64-self.collect/2
                rectfill(0, by-2, 128, by+10, col.blue1)
                print("ultra meat!", bx, by, col.black)
                print("ultra meat!", bx+1, by+1, col.grey1)
                print("ultra meat!", bx+2, by+2, col.white)
                camera(cx,cy)
                p.powerup="ultrameat"
                p.poweruptime=300
            else
                spr(16,self.x,self.y)
            end
        end
    },
    -- coin
    [64]={
        phase=0,
        frames={64,65,66,65},
        update=function(self)
            if self.mode==nil then self.mode="idle" end
            local frames=self.frames
            if self.phase==nil then self.phase=0 end
            self.phase = (self.phase+1)%(#frames*5)
            self.spr = frames[flr(self.phase/5)+1]


            if self.mode=="idle" then
                if collide(self,p) then
                    self.mode="collect"
                    sfx(fx.coin,1)
                    self.collect=20
                    for i=1,2 do
                        particle_add_at_ob(
                            self,
                            col.white)
                    end
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