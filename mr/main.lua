-- todo fix can go up through an apple
-- todo can push apple in earth left, but not right
-- todo can push an apple THROUGH a baddie

-- todo make apple shift to 8x8 grid when falling
fx={
    split=0,
    fall=1,
    dig=2,
    die=3,
}

-- tile that a 1x1 sprite is mostly occupying
function tile_for(ob)
    local x=flr(ob.x+4/8)*8
    local y=flr(ob.y+4/8)*8
    return {x, y}
end

function _init()

    -- force reload map
    reload(0x1000, 0x1000, 0x2000)

    particles={}
    baddies={}
    apples={}
    
    p=player_init()
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

    baddie_add(9*8,4*8)
    baddie_add(12*8,4*8)

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
        if o.debug_label~=nil then 
            print(o:debug_label(), o.x-1, o.y, col.black)
            print(o:debug_label(), o.x+1, o.y, col.black)
            print(o:debug_label(), o.x, o.y, col.white)
        end
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