fx={
    split=0,
    fall=1,
    dig=2,
}

function _init()

    -- force reload map
    reload(0x1000, 0x1000, 0x2000)

    particles={}
    
    p={
        x=16,
        y=16,
        spr=16,
        w=1,
        h=1,
        hitbox={
            x=1,
            y=1,
            w=6,
            h=6
        },
        update=function(self)
            local p2x=flr((self.x+4)/8)*8
            local p2y=flr((self.y+4)/8)*8
            -- local tx=flr((self.x+4)/8)
            -- local ty=flr((self.y+4)/8)
            -- local dty=(self.y+4)-((p2.y*8)+4)
            -- local dtx=(self.x+4)-((p2.x*8)+4)
            if (btn(0)) then 
                --left
                self.x-=1
                self.y+=(p2y-self.y)/4
            elseif (btn(1)) then 
                self.x+=1
                self.y+=(p2y-self.y)/4

            elseif (btn(2)) then 
                self.y-=1
                self.x+=(p2x-self.x)/4
            elseif (btn(3)) then 
                self.y+=1
                self.x+=(p2x-self.x)/4
            end

            local tx=flr(flr(self.x+4)/8)
            local ty=flr(flr(self.y+4)/8)
            local t = mget(tx,ty)
            -- if t~=0 then
                -- dig!!
                addHole(tx,ty)
                updateEdges(tx,ty)
                updateEdges(tx-1,ty)
                updateEdges(tx+1,ty)
                updateEdges(tx,ty-1)
                updateEdges(tx,ty+1)
            -- end
        end
    }
    obs={}
    add(obs,p)
add(obs,p2)

    for x=0,16 do
        for y=0,16 do
            mset(x,y,1)
        end
    end

    -- background
    -- for x=16,32 do
    --     for y=0,16 do
    --         mset(x,y,18+flr(rnd(2)))
    --     end
    -- end

    ------ TEMPORARY DEFAULT LEVEL DESIGN
    for x=4,12 do
        addHole(x,4,true)      
    end
    for y=4,12 do
        addHole(12,y,true)      
    end
    for x=8,14 do
        addHole(x,10,true)      
    end

    apple_add(5,1)
    apple_add(5,4)
    apple_add(9,1)
    apple_add(12,6)
    apple_add(4,7)

    -- END

    for x=0,16 do
        for y=0,16 do
            updateEdges(x,y)
        end
    end
    printh("reset")
end


function addHole(tx,ty,skipSmoke)
    if tx<0 or tx>15 or ty<0 or ty>15 then return end
    if mget(tx,ty)==0 then return end
    mset(tx,ty,0)
    if not skipSmoke then
        smoke_add(tx*8+4,ty*8+4,0,col.green1)
        smoke_add(tx*8+4,ty*8+4,0,col.green2)

        particle_add(tx*8+4,ty*8+4,-1,-1,col.green1)
        particle_add(tx*8+4,ty*8+4,1,-1,col.green2)
        particle_add(tx*8+4,ty*8+4,1,1,col.green1)
        particle_add(tx*8+4,ty*8+4,-1,1,col.green2)

        sfx(fx.dig,0)
    end
end

edgeMap={
    top=0,
    right=16,
    bottom=32,
    left=48
}

function updateEdges(tx,ty)
    if tx<0 or tx>15 or ty<0 or ty>15 then return end
    if mget(tx,ty)~=0 then
        return
    end

    local above=mget(tx,ty-1)~=0
    local below=mget(tx,ty+1)~=0
    local left=mget(tx-1,ty)~=0
    local right=mget(tx+1,ty)~=0

    ty=ty+16

    -- clear
    mset(tx+edgeMap.top,ty,0)
    mset(tx+edgeMap.right,ty,0)
    mset(tx+edgeMap.bottom,ty,0)
    mset(tx+edgeMap.left,ty,0)

    if above then
        mset(tx+edgeMap.top,ty,2)
    end
    if right then
        mset(tx+edgeMap.right,ty,3)
    end
    if below then
        mset(tx+edgeMap.bottom,ty,4)
    end
    if left then
        mset(tx+edgeMap.left,ty,5)
    end
end

function _draw()
    cls(0)
    -- map(16,0,0,0,16,16)
    map(0,0,0,0,16,16)
    map(edgeMap.top,16,0,0,16,16)
    map(edgeMap.right,16,0,0,16,16)
    map(edgeMap.bottom,16,0,0,16,16)
    map(edgeMap.left,16,0,0,16,16)
    for p in all(particles) do
        p:draw()
    end
    for o in all(obs) do
        spr(o.spr,o.x,o.y,o.w,o.h)
    end
end

function _update60()
    for p in all(particles) do
        p:update()
    end
    for o in all(obs) do
        o:update()
    end
end