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