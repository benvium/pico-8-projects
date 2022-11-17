function _init()
    for x=0,16 do
        for y=0,16 do
            mset(x,y+48,1)
        end
    end
    obs={}
    cam={0,0}

    player_init()
    dtb_init()

    baddie_init()
    collectable_init()
    particle_init()

    offset=0

    -- make btnp repeat time really long
    poke(0x5f5c,500) 
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
    -- green
    map(0,48,0,0,16,16)

    -- holes
    map(16,48,0,0,16,16)

    -- trees (lower)
    map(0,0,0,0,16,16)

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
end

function _update60()
    for ob in all(obs) do
        ob:update()
    end
    for particle in all(particles) do
        particle:update()
    end
    dtb_update()
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