local gravity={x=0,y=0.01}

function _init()
    obs={}
    -- a ball
    add(obs, {
        pos={
            x=120,
            y=120,
        },
        r=5,
        speed=0,
        -- unit vector
        dir={x=0,y=0},
        fill=col.grey2,
        highlight=col.white,
        stroke=col.grey1,
    })

    add(obs, {
        pos={
            x=120,
            y=70,
        },
        dir={
            x=0,
            y=0,
        },
        r=5,
        speed=0,
        vec={x=0,y=0},
        fill=col.red2,
        highlight=col.orange,
        stroke=col.red1,
    })

    add(obs, {
        pos={
            x=64,
            y=94,
        },
        dir={
            x=0,
            y=0,
        },
        r=3,
        speed=0,
        vec={x=0,y=0},
        fill=col.grey1,
        highlight=col.blue2,
        stroke=col.blue1,
    })

    add(obs, {
        pos={
            x=48,
            y=40,
        },
        dir={
            x=0,
            y=0,
        },
        r=9,
        speed=0,
        vec={x=0,y=0},
        fill=col.grey1,
        highlight=col.blue2,
        stroke=col.blue1,
    })

    lines={}


    add(lines,{
        p1={x=0,y=48},
        p2={x=0,y=127},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=0,y=127},
        p2={x=127,y=127},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=0,y=48},
        p2={x=16,y=24},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=16,y=24},
        p2={x=36,y=12},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=36,y=12},
        p2={x=64,y=8},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=64,y=8},
        p2={x=84,y=12},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=64,y=8},
        p2={x=84,y=12},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=84,y=12},
        p2={x=104,y=24},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=124,y=60},
        p2={x=127,y=80},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=124,y=60},
        p2={x=110,y=30},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=127,y=80},
        p2={x=127,y=127},
        stroke=col.grey1,
    })


    add(lines,{
        p1={x=40,y=80},
        p2={x=60,y=80},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=60,y=80},
        p2={x=60,y=100},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=60,y=100},
        p2={x=40,y=100},
        stroke=col.grey1,
    })
    add(lines,{
        p1={x=40,y=100},
        p2={x=40,y=80},
        stroke=col.grey1,
    })
    -- add(lines,{
    --     p1={x=0,y=48},
    --     p2={x=16,y=32},
    --     stroke=col.grey1,
    -- })
    -- add(lines,{
    --     p1={x=64,y=0},
    --     p2={x=0,y=32},
    --     stroke=col.grey1,
    -- })
    -- add(lines,{
    --     p1={x=0,y=32},
    --     p2={x=0,y=127},
    --     stroke=col.grey1,
    -- })
    -- add(lines,{
    --     p1={x=0,y=127},
    --     p2={x=127,y=127},
    --     stroke=col.grey1,
    -- })
    -- add(lines,{
    --     p1={x=127,y=127},
    --     p2={x=127,y=32},
    --     stroke=col.grey1,
    -- })
    -- add(lines,{
    --     p1={x=80,y=20},
    --     p2={x=127,y=20},
    --     stroke=col.grey1,
    -- })
    -- add(lines,{
    --     p1={x=80,y=0},
    --     p2={x=80,y=20},
    --     stroke=col.grey1,
    -- })
end

function move_towards(ball,other,speed)

    local towards=v_normalize(v_subv(other.pos,ball.pos))
    ball.dir=towards
    ball.speed=speed
end

function ball_update()
    for ball in all(obs) do
        ball.collide=false

        if ball.speed<0.01 then
            ball.speed=0
        else
            local orig_pos={x=ball.pos.x,y=ball.pos.y}
            ball.pos.x=ball.pos.x+ball.dir.x*ball.speed
            ball.pos.y=ball.pos.y+ball.dir.y*ball.speed

            ball.speed = max(0,ball.speed-0.005)

            -- check for collision with all other balls
            for ball2 in all(obs) do
                -- only one collision at a time WIP
                if ball2.collide then break end

                -- don't collide with yourself!
                if ball2~=ball then 

                    if circle_collide_circle(ball,ball2) then
                        ball.collide=true

                        -- transfer speed to other ball
                        ball2.speed = ball.speed*0.8
                        ball.speed=ball.speed*0.2

                        -- direction is unitvec between balls
                        ball2.dir=v_normalize(v_subv(ball2.pos,ball.pos))
                    end
                end
            end

            -- check for collision with lines
            for line in all(lines) do
                if circle_collide_line_segment(ball,line.p1,line.p2) then
                    ball.collide=true
                    
                    -- find normal of line in the direction of the ball
                    local lineUnit = v_normalize(v_subv(line.p2,line.p1))                   
                    local normal1 = {x=lineUnit.y,y=-lineUnit.x}
                    local normal2= {x=-lineUnit.y,y=lineUnit.x}

                    -- if the ball is moving towards the normal, use the other normal
                    if v_dot(ball.dir,normal1)<0 then
                        normal1=normal2
                    end
                    
                    ball.dir=v_reflect(ball.dir,normal1)
                end
            end

            if ball.collide then
                sfx(1)

                -- put ball back where it was
                ball.pos=orig_pos
            end
        end
    end
end

function _update60()
    ball_update()

    if btn(0) then
        obs[1].pos.x-=1
        obs[1].speed=0
    end
    if btn(1) then
        obs[1].pos.x+=1
        obs[1].speed=0
    end
    if btn(2) then
        obs[1].pos.y-=1
        obs[1].speed=0
    end
    if btn(3) then
        obs[1].pos.y+=1
        obs[1].speed=0
    end

    if btn(4) then

        local ball=obs[1]
        local canMove=true
        -- only move if not INSIDE another ball
        for ball2 in all(obs) do
            -- don't collide with yourself!
            if ball2~=ball then 
                if circle_collide_circle(ball,ball2) then
                    canMove=false
                    break
                end
            end
        end

        if not canMove then return end
        -- make first ball go towards second
        move_towards(ball,obs[4] ,7)
    end
end

function _draw()
    cls()
    for ln in all(lines) do
        line(ln.p1.x,ln.p1.y,ln.p2.x,ln.p2.y,ln.stroke)
    end
    for ob in all(obs) do
        circfill(ob.pos.x,ob.pos.y,ob.r,ob.fill)
        circ(ob.pos.x,ob.pos.y,ob.r,ob.collide and col.pink or ob.stroke)
        circfill(ob.pos.x+ob.r/3,ob.pos.y+ob.r/3,ob.r/4,ob.highlight)
    end
    print(tostring(newDir))
    print(tostring(foo))
end

function circle_collide_circle(b1,b2)
    local sub = v_subv(b2.pos,b1.pos)
    local distBetween = v_mag(sub)
    return distBetween <= (b2.r+b1.r)
end

function circle_collide_line_segment(ob, pt1, pt2)
    local sub = v_subv(pt2,pt1)
    local distBetween = v_mag(sub)
    local unitvec = v_normalize(sub)
    local closest = v_addv(pt1,v_mults(unitvec,v_dot(v_subv(ob.pos,pt1),unitvec)))
    local distToClosest = v_mag(v_subv(closest,ob.pos))
    if distToClosest<=ob.r and v_dot(v_subv(closest,pt1),unitvec)>=0 and v_dot(v_subv(closest,pt2),unitvec)<=0 then
        return true,'line'
    end
    -- impale cases
    if v_mag(v_subv(pt1,ob.pos))<=ob.r then
        return true,'end'
    end
    if v_mag(v_subv(pt2,ob.pos))<=ob.r then
        return true,'end'
    end
    return false,nil
end


    -- -- https://stackoverflow.com/questions/1073336/circle-line-collision-detection
    -- local dx = pt2.x - pt1.x
    -- local dy = pt2.y - pt1.y
    -- local dr = sqrt(dx*dx + dy*dy)
    -- local D = pt1.x*pt2.y - pt2.x*pt1.y
    -- local disc = ob.r*ob.r*dr*dr - D*D
    -- if disc < 0 then
    --     return false
    -- end
    -- -- optimize?
    -- local sgn = dy < 0 and -1 or 1
    -- local x1 = (D*dy + sgn*dx*sqrt(disc)) / (dr*dr)
    -- local x2 = (D*dy - sgn*dx*sqrt(disc)) / (dr*dr)
    -- local y1 = (-D*dx + abs(dy)*sqrt(disc)) / (dr*dr)
    -- local y2 = (-D*dx - abs(dy)*sqrt(disc)) / (dr*dr)
    -- return true
-- end