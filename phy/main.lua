

function _init()
    vp = viewport{ scale=16 }
    s = scene{}

    -- vlist = { [0]=ngon(0.5, 3) }
    
    --, ngon(0.5, 4), ngon(0.5, 5), ngon(0.5, 6), ngon(0.5, 7), ngon(0.5, 8), ngon(0.5, 9), ngon(0.5, 10) }

    -- s.add_body{ x=-1.6, y=3.1, mass=0, moi=5, rest=0.2, verts=rectangle(3, 1) }
    -- s.add_body{ x=1.8, y=0.7, mass=0, moi=5, rest=0.6, verts=rectangle(3, 1) }
    -- s.add_body{ x=-1.8, y=-0.7, mass=0, moi=5, rest=0.6, verts=rectangle(3, 1) }
    -- s.add_body{ x=1.6, y=-3.1, mass=0, moi=5, rest=0.6, verts=rectangle(3, 1) }

    s.add_body{ x=0, y=-3, a=0.2, mass=0, moi=0, rest=0.0, verts=rectangle(8, .5) }
    s.add_body{ x=0, y=4, mass=0, moi=0, rest=0.0, verts=rectangle(8, .5) }
    s.add_body{ x=-4, y=0, mass=0, moi=0, rest=0.0, verts=rectangle(.5, 8) }
    s.add_body{ x=4, y=0, mass=0, moi=0, rest=0.0, verts=rectangle(.5, 8) }

    -- flipper
    local fly=-3.1
    local holder = s.add_body{ x=-4, y=fly, mass=0, moi=0, rest=0.0, verts=rectangle(1, 1) }
    flipper = s.add_body{ x=-2, y=fly, verts=rectangle(3, 0.5) }
    s.add_constraint(joint(s, holder, 1, 0.5, flipper, -1, 0.5, 0.8))

    recentId = s.add_body{ x=3, y=3, verts=ngon(0.55, 8) }
end

-- local recentId = 0

function _update60()
--   if (rnd(1)>0.99) then 
--     recentId = s.add_body{ x=rnd(4)-2, y=5+rnd(2), verts=vlist[flr(rnd()*6)] 
-- --   , listener=listener 
-- } end
  s.update()

  if btnp(4) then
    s.apply_impulse(recentId, 0, 20, -2)
  end

  if btnp(5) then
    s.apply_impulse(flipper, 0, 50, -0.5)
  end
end

function _draw()
  cls()
  s.draw(vp)

--   if recentId~=0 then
    local bx,by,ang = s.position(recentId)
    local x,y = vp.to_screen(bx,by)
    if x~=nil and y~=nil then
        -- rspr(16, 0,x-4,y-4,ang,1)
        rspr(24, 0,x-8,y-8,ang,2)
    end
--   end

  

--   print(flr(stat(0)) .. ' kib', 5, 5, 0x7)
--   print(flr(stat(1)*100) .. '% ' .. stat(7) .. 'fps', 5, 15, 0x7)
--   rect(0, 0, 127, 127, 0x7)
end

-- draw a rotated sprite
function rspr(sx,sy,x,y,a,w)
    local ca,sa=cos_sin(a)
    local srcx,srcy,addr,pixel_pair
    local ddx0,ddy0=ca,sa
    local mask=shl(0xfff8,(w-1))
    w*=4
    ca*=w-0.5
    sa*=w-0.5
    local dx0,dy0=sa-ca+w,-ca-sa+w
    w=2*w-1
    for ix=0,w do
        srcx,srcy=dx0,dy0
        for iy=0,w do
            if band(bor(srcx,srcy),mask)==0 then
                local c=sget(sx+srcx,sy+srcy)
                if (c>0) pset(x+ix,y+iy,c)
            end
            srcx-=ddy0
            srcy+=ddx0
        end
        dx0+=ddx0
        dy0+=ddy0
    end
end