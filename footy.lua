p = {
    x=64,
    y=20,
    w=16,
    h=16
}

p2 = {
    x=64,
    y=110,
}

b = {
    x=64,
    y=130,
    dx=0,
    dy=-3,
    starty=130,
    h=8,
    w=8
}

g = {
    x=40,
    y=0,
    h=16,
    w=48
}

score={
    h=0,
    a=0
}

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

function _draw() 
    cls()

    map(0,0,0,0,16,16)
    
    -- player
    spr(2,p.x,p.y,2,2)

    -- ball
    spr(1,b.x,b.y)

    -- p2
    spr(34,p2.x,p2.y,2,2)

    print("home: "..score.h.." away:"..score.a, 0,120,7)
end

function _update60()
    if btn(0) then
        p.x=max(16,p.x-1)
    end
    if btn(1) then
        p.x=min(112,p.x+1)
    end

    --ball
    

    b.y+=b.dy
    b.x+=b.dx

    if b.y<0 or b.y>128 then
        b.y=b.starty
        b.dx=(rnd(3)-1.5)/3
        b.x=64
        b.dy=-2
        sfx(0)
    end
    local pcol={
        x=p.x+3,
        y=p.y,
        w=p.w-6,
        h=p.h
    }
    local bcol={
        x=b.x+2,
        y=b.y+2,
        w=4,
        h=4
    }

    -- save
    if intersects(bcol,pcol) then
        b.dy=3
        b.dx=-b.dx
        sfx(0)
        score.h+=1
    end

    -- goal
    if intersects(g,b) then
        sfx(1)
        score.a+=1
        b.y=-100
    end
end