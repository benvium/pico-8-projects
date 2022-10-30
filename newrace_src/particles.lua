pts={}
-- x,y,dx,dy

function pts_add(x,y,spr)
 add(pts, {
  x=x+rnd(16)-2.5,
  y=y+rnd(16)-2.5,
  dx=rnd(10)-5,
  dy=rnd(10)-6,
  spr=spr
 })
end

function pts_add2(x,y)
 add(pts, {
  x=x,
  y=y,
  dx=0,
  dy=0,
  spr=43
 })
end

function pts_update()

 local i=1
 while i<=#pts do
  local p=pts[i];
  
  p.dy+=0.25
  p.x=p.x+p.dx
  p.y=p.y+p.dy
  if p.y>128 or p.y<0 
  or p.x>128 or p.x<0 then
   	-- kill
   	del(pts,p)
  end
  i+=1
 end
end

function pts_draw()
 for p in all(pts) do
  spr(p.spr,p.x,p.y)
 end
end