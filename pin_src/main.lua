function _draw()
    cls(1)
    map(16,0,0,0,16,16)
    map(0,0,0,0,16,16)

    pset(x,y,col.blue3)

    print("undercol "..undercol,col.white)
    print("x "..x..",y "..y,col.white)

    local data = flagToAngle(x,y)
    if data~=nil then
        print("angle "..data[1],col.white)
    end

    for pt in all(colpts) do
        pset(pt.x,pt.y,col.blue3)
    end
    
    for ball in all(pxballs) do
        pset(ball.x,ball.y,col.white)
    end

   
end

x=64
y=64

undercol=0

-- debug -draw point when there's a collision
colpts={}

colnormals={}

pxballs={}

-- add(pxballs,{
--     x=10,
--     y=10,
--     dx=0,
--     dy=1
-- })

-- add(pxballs,{
--     x=32,
--     y=32,
--     dx=1,
--     dy=0
-- })

-- add(pxballs,{
--     x=20,
--     y=20,
--     dx=-2,
--     dy=0
-- })

-- add(pxballs,{
--     x=116,
--     y=95,
--     dx=0,
--     dy=-10
-- })

cnt=0

function _update()
    cnt=cnt-1
    if cnt<0 then
        cnt=90
        pxballs={}
        add(pxballs,{
            x=10,--+rnd(10)-5,
            y=30,
            dx=0,
            dy=0,--rnd(1)
        })
        -- add(pxballs,{
        --     x=99+rnd(10)-5,
        --     y=30,
        --     dx=0,
        --     dy=rnd(1)
        -- })
    end
    -- cnt=(cnt+1)%5
    -- if cnt~=0 then return end

    if btn(0) then
        x-=1
    end
    if btn(1) then
        x+=1
    end
    if btn(2) then
        y-=1
    end
    if btn(3) then
        y+=1
    end
    if btn(4) then
        add(pxballs,{
            x=x,
            y=y,
            dx=0,
            dy=0
        })
    end

    undercol=colFromMap(x,y)

    for ball in all(pxballs) do
        ball.dy+=0.1
        local newx=ball.x+ball.dx
        local newy=ball.y+ball.dy

        -- is there a collision where it's going?
        local col = colFromMap(newx,newy)

        -- find the first collision
        
        if col~=0 then
            local ddx=ball.dx/8
            local ddy=ball.dy/8

            local i = 1
            while true do
                newx=ball.x+ddx*i
                newy=ball.y+ddy*i
                local col = colFromMap(ball.x+ddx*i,ball.y+ddy*i)
                if col~=0 or i>=8 then
                    newx=ball.x+ddx*(i-1)
                    newy=ball.y+ddy*(i-1)
                    break
                end
                i+=1
            end
        end

        local a = flagToAngle(newx,newy)
        -- 360°=1
        if a~=nil and col~=0 then
            ball.x=newx
            ball.y=newy
            local dx,dy = bounce(ball.dx,ball.dy,a[1])
            ball.dx=dx
            ball.dy=dy

            -- local angle = a[1]
            -- local dx=a[2]
            -- local dy=a[3]
            -- -- printh("force "..angle)
            -- ball.dx+=dx
            -- ball.dy+=dy
            -- local flag = a[2]
            -- local dx = ball.dx
            -- local dy = ball.dy

            -- if flag==1 then
            --     dx = -dx
            -- elseif flag==2 then
            --     dy = -dy
            -- elseif flag==3 then
            --     dx = -dx
            --     dy = -dy
            -- end

            -- local newdx = dx*cos(angle)-dy*sin(angle)
            -- local newdy = dx*sin(angle)+dy*cos(angle)

            -- ball.dx = newdx
            -- ball.dy = newdy
        end

        if col~=0 then
            add(colpts, {x=newx,y=newy})
        end

        --     -- determine direction to bounce
        --     local t = colFromMap(newx,newy-1)
        --     local r = colFromMap(newx+1,newy)
        --     local b = colFromMap(newx,newy+1)
        --     local l = colFromMap(newx,newy+1)

        --     if t or b then
        --         if abs(ball.dy)>0.5 then
        --             ball.dy=-ball.dy*0.4
        --         else
        --             ball.dy=0
        --         end

        --         if r or l then
        --             if abs(ball.dx)>0.5 then
        --                 ball.dx=-ball.dx*0.4
        --             else
        --                 ball.dx=0
        --             end
        --         end
        --     end
        -- end

        -- if col==0 then 
        ball.x+=ball.dx
        ball.y+=ball.dy
        -- end

        -- gravity
        -- local t = colFromMap(ball.x,ball.y-1)
        -- local br = colFromMap(ball.x+1,ball.y+2)
        -- local bbr = colFromMap(ball.x+1,ball.y+2)
        -- local b = colFromMap(ball.x,ball.y+1)
        -- local bl = colFromMap(ball.x-1,ball.y+1)
        -- local bbl = colFromMap(ball.x-1,ball.y+2)
        -- if b==0 then
        --     ball.dy+=0.1
        -- end
        -- -- if b and not br then
        -- --     ball.dx+=0.25
        -- --     ball.dy+=0.25
        -- -- end
        -- if b~=0 and bl==0 then
        --     ball.dx=min(0.5, ball.dx+0.25)
        --     -- ball.dy+=0.5
        -- end
        -- if b~=0 and bbl==0 then
        --     ball.dx=min(0.25, ball.dx+0.25)
        --     -- ball.dy+=0.5
        -- end
        -- if b~=0 and br==0 then
        --     ball.dx=min(0.5, ball.dx+0.5)
        --     -- ball.dy+=0.5
        -- end
        -- if b~=0 and bbr==0 then
        --     ball.dx+=0.25
        --     -- ball.dy+=0.5
        -- end
    end
end

-- tiles encode the 'rebound' direction
-- as flags 16-31 (clockwise from right)
-- return {angle,dx,dy}
function flagToAngle(x,y)
    local flag = fget(mget(x/8,y/8))
    if flag>=16 and flag<32 then
        local angle=(1/16)*((flag-16))
        print("flag "..flag.." num "..flag-16)
        
        -- pico8 uses 1=360°
        return {angle,cos(angle),sin(angle)}
    end
end

function toDegrees(rot)
    return flr(rot*360)
end

-- returns dx,dy
function bounce(dx, dy, wallNormal)
    local inAngle=vecToAngle(dx,dy)
    local outAngle=(inAngle-0.5)-wallNormal
    printh("wallNormal: "..toDegrees(wallNormal).." inAngle:"..toDegrees(inAngle).." outAngle:"..toDegrees(outAngle))
    local dx2, dy2 = angleToVec(outAngle, vecLength(dx,dy))
    return dx2, dy2
    -- return (dx*0.4)+(dx2*0.6),(dy*.4)+(dy2*0.6)
end

function angleToVec(angle,length)
    return cos(angle)*length,sin(angle)*length
end

function vecLength(dx,dy)
    return sqrt(dx*dx+dy*dy)
end

function vecToAngle(dx,dy)
    local angle = atan2(dx,-dy)
    -- see docs for -dy
    return angle
end