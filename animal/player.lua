function player_draw(self)

    local head
    if self.dir == "r" then
        head={10,false}
    elseif self.dir == "l" then
        head={10,true}
    elseif self.dir == "u" then
        head={12,false}
    elseif self.dir == "d" then
        head={11,false}
    end

    spr(head[1], self.x, self.y, 1, 1, head[2], false)

    -- draw body
    local body
    if self.dir == "r" then
        body={26,false}
    elseif self.dir == "l" then
        body={26,true}
    elseif self.dir == "u" then
        body={28,false}
    elseif self.dir == "d" then
        body={27,false}
    end

    spr(body[1], self.x, self.y+8, 1, 1, body[2], false)

    -- draw hints
    if self.can_carry~=nil then
        print("❎ pick up", self.x-1, self.y-8, col.black)
        print("❎ pick up", self.x+1, self.y-8, col.black)
        print("❎ pick up", self.x, self.y-8, col.white)
    elseif self.carry_item~=nil then
        print("❎ drop", self.x-1, self.y-8, col.black)
        print("❎ drop", self.x+1, self.y-8, col.black)
        print("❎ drop", self.x, self.y-8, col.white)
    end

    -- print(tostring(self.carry_item))
end

function player_update(self)
    -- movement
    if btn(0) then
        self.dx=-1
        self.dir="l"
    end
    if btn(1) then
        self.dx=1
        self.dir="r"
    end
    if btn(2) then
        self.dy=-1
        self.dir="u"
    end
    if btn(3) then
        self.dy=1
        self.dir="d"
    end
    if btnp(❎) then
        if self.can_carry then
            self.carry_item = self.can_carry
            self.can_carry = nil
            -- collectable_del(self.carry_item)
            sfx(0,0)
        elseif self.carry_item then
            self.carry_item = nil
            -- collectable_re_add(self.carry_item)
            sfx(0,0)
        end
    end

    if self.carry_item then
        self.carry_item.x=self.x
        self.carry_item.y=self.y+9
    end

    if can_move(self,self.dx or 0, 0, 0) then
        self.x+=self.dx or 0
    end
    if can_move(self,0, self.dy or 0, 0) then
        self.y+=self.dy or 0
    end
    self.dx=0
    self.dy=0

    -- see if we can pick things up
    self.can_carry=nil
    if self.carry_item==nil then
        for c in all(collectables) do
            if collide(self,c) then
                if c.carry then
                    self.can_carry=c
                end
                -- todo 'pickups?'
                break
            end
        end
    end
end

function player_init()
    player={
        x=64,
        y=64,
        w=1,
        h=2,
        dir="r", -- direction
        hitbox={
            x=0,
            y=9,
            w=7,
            h=6
        },
        draw=player_draw,
        update=player_update,
    }
    add(obs, player)
end