-- @return true if NO tile with given flag on any 'compass' direction
-- is on the map of the given ob (needs ob.hitbox x,y,w,h)
function can_move(ob,dx,dy,flag)
    if flag==nil then flag=0 end
    local newx=ob.x+ob.hitbox.x+dx
    local newy=ob.y+ob.hitbox.y+dy
    local vx,vy
    vx=newx+ob.hitbox.w/2
    vy=newy+ob.hitbox.h
    local b=map_flag(vx,vy,flag)
    if b then return false,vx,vy end
    vx=newx
    vy=newy+ob.hitbox.h
    local bl=map_flag(vx,vy,flag)
    if bl then return false,vx,vy end
    vx=newx+ob.hitbox.w
    vy=newy+ob.hitbox.h
    local br=map_flag(vx,vy,flag)
    if br then return false,vx,vy end
    vx=newx+ob.hitbox.w/2
    vy=newy
    local t=map_flag(vx,vy,flag)
    if t then return false,vx,vy end
    vx=newx
    vy=newy
    local tl=map_flag(vx,vy,flag)
    if tl then return false,vx,vy end
    vx=newx+ob.hitbox.w
    vy=newy
    local tr=map_flag(vx,vy,flag)
    if tr then return false,vx,vy end
    vx=newx
    vy=newy+ob.hitbox.h/2
    local l=map_flag(vx,vy,flag)
    if l then return false,vx,vy end
    vx=newx+ob.hitbox.w
    vy=newy+ob.hitbox.h/2
    local r=map_flag(vx,vy,flag)
    if r then return false,vx,vy end
    
    return true
end

function collide(a, b)
    return intersects({
        x=a.x+a.hitbox.x,
        y=a.y+a.hitbox.y,
        w=a.hitbox.w,
        h=a.hitbox.h
    },{
        x=b.x+b.hitbox.x,
        y=b.y+b.hitbox.y,
        w=b.hitbox.w,
        h=b.hitbox.h
    })
end

function intersects(a, b)
    local rectA={
        left=a.x,
        right=a.x+a.w,
        top=a.y,
        bottom=a.y+a.h
    }
    local rectB={
        left=b.x,
        right=b.x+b.w,
        top=b.y,
        bottom=b.y+b.h
    }
    return max(rectA.left, rectB.left) < min(rectA.right, rectB.right)
    and max(rectA.top, rectB.top) < min(rectA.bottom, rectB.bottom);
end
