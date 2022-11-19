dtb_init(3)

cartdata("benvium_exploding_chickens_v1")

function _init()
    for x=0,16 do
        for y=0,16 do
            mset(x,y+48,1)
        end
    end
    obs={}
    cam={0,0}
    mode="intro"
    high_score=dget(0) or 0

    -- force reload map
    reload(0x1000, 0x1000, 0x2000)

    player_init()

    baddie_init()
    collectable_init()
    particle_init()

    offset=0

    -- make btnp repeat time really long
    poke(0x5f5c,500) 

    -- frames until another apple appears
    apple_counter=300

    -- 10pts per munch
    score=0

    exploded=0
    

    dtb_disp("feed chickens, but watch out if they get too hungry! pick up and drop apples with ❎ ", function()
        mode="game"
    end)
end

-- http://gamedev.docrobs.co.uk/screen-shake-in-pico-8#
function screen_shake()
    local fade = 0.95
    local offset_x=16-rnd(32)
    local offset_y=16-rnd(32)
    offset_x*=offset
    offset_y*=offset
    
    camera(offset_x,offset_y)
    offset*=fade
    if offset<0.05 then
      offset=0
    end
  end

function _draw()
    screen_shake()
    cls(col.green1)

    -- holes
    map(16,48,0,0,16,16)

    -- trees (lower)
    map(0,0,0,0,16,16)

    -- hud
    rectfill(0,0,127,6,col.blue1)
    rectfill(0,0,127,1,col.blue2)
    rectfill(0,5,127,6,col.black)
    spr(34,1,-1,1,1)
    print(#baddies,10,1,0)
    print(#baddies,11,1,7)

    spr(2,1+32,-1,1,1)

    print(exploded,10+32,1,0)
    print(exploded,11+32,1,7)

    
    print("score",64+8,1,col.black)
    print("score",65+8,1,col.grey2)
    print(score,64+32,1,0)
    print(score,65+32,1,7)

    -- draw obs
    sort(obs, function(a,b) return (a.y+a.h*8)>(b.y+b.h*8) end)
    for ob in all(obs) do
        ob:draw()
    end

    -- trees (upper)
    map(0,0,0,0,16,16,128)

    for particle in all(particles) do
        particle:draw()
    end

    -- text
    dtb_draw()

    if mode=="intro" then
        local px=32
        local py=32
        rectfill(px,py,96,66,col.black)
        rectfill(px+2,py+2,94,64,col.blue1)
        print("exploding",px+8,py+8,col.black)
        print("exploding",px+8,py+8+1,col.red1)
        print("exploding",px+8,py+8+2,col.red2)
        print("chickens",px+20-1,py+20,col.brown)
        print("chickens",px+20,py+20,col.yellow)
    end
end

function _update60()
    dtb_update()

    for particle in all(particles) do
        particle:update()
    end

    if mode=="intro" then
        
    elseif mode=="game" then
        for ob in all(obs) do
            ob:update()
        end 

        apple_counter-=1
        -- add apples occasionally
        if apple_counter<1 then

            while true do
                local x=rnd(128-16+8)
                local y=rnd(128-16+8)
                if not map_flag(x+4,y+4,0) then
                    sfx(1,0)
                    collectable_add(x,y,52,collectable_types[52])
                    smoke_add(x+4,y+4,-0.25,col.white)
                    smoke_add(x-3+4,y-2+4,-0.25,col.white)
                    smoke_add(x+3+4,y-2+4,-0.25,col.white)
                    break
                end
            end

            if #baddies<5 then
                apple_counter=300
            elseif #baddies<10 then
                apple_counter=200
            elseif #baddies<15 then
                apple_counter=100
            else
                apple_counter=60
            end 

            -- increase difficulty by making timer longer the longer the game goes on
            apple_counter+=flr(score/15)
        end
    end
end

-- https://www.lexaloffle.com/bbs/?pid=50453
-- e.g.
-- sort(actors, function(a, b)
--   return a.x > b.x
-- end)
function sort(a,cmp)
    for i=1,#a do
      local j = i
      while j > 1 and cmp(a[j-1],a[j]) do
          a[j],a[j-1] = a[j-1],a[j]
      j = j - 1
      end
    end
  end