-- collision detection with map
function map_flag(x,y,flag)
  local fx = fget(mget(flr(flr(x)/8),flr(flr(y)/8)),flag)
  return fx
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

function intersectsMap(a)
    local rectA={
        left=a.x,
        right=a.x+a.w,
        top=a.y,
        bottom=a.y+a.h
    }
    local corners = {
        {rectA.x,}
    }

    -- local rectB={
    --     left=b.x,
    --     right=b.x+b.w,
    --     top=b.y,
    --     bottom=b.y+b.h
    -- }
    -- return max(rectA.left, rectB.left) < min(rectA.right, rectB.right)
    -- and max(rectA.top, rectB.top) < min(rectA.bottom, rectB.bottom);
end
