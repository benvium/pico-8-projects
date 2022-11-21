

block_size=10

function _init()
    board={}

    board_init()

    -- tile coords of 'player'
    p={x=4,y=4}

    particles={}

    mode="move" -- or "slide"
    slide_cooldown=nil

    frame=0

    slide_target=nil
    -- or {dir="x", d=1}

    score={}
    for i=1,#block_types do
        score[i]=0
    end

    battle_init()

    board_check_for_lines()

    -- other objects to draw/update each frame
    obs={}
end

function _draw()
    cls(0)
    camera(0,0)
    map(0,0,-4,-4,17,14)

    camera(-2*8-1+4, -2*8-1+4)

    rect(-2,-2,8*block_size-1,8*block_size-1,col.black)
    rect(-2-8,-2-8,9*block_size-3,9*block_size-3,col.black)

    -- CLIP TO GAME AREA
    clip(2*8-4,2*8-4,8*block_size,8*block_size)

    if mode=="slide" then
        -- draw selection rows
        if frame%12<6 then
            fillp(0b0101101001011010)
        else
            fillp(0b1010010110100101)        
        end
        -- checkedboard pattern - animated ^ 
        rectfill(p.x*block_size-1,-1,(p.x+1)*(block_size)-2,8*block_size-2,col.blue1)
        
        rectfill(-1,p.y*block_size-1,8*block_size-2, (p.y+1)*(block_size)-2,col.blue1)

    
        -- rect(p.x*block_size-1,-1,(p.x+1)*(block_size)-2,8*block_size-2,col.white)
        -- rect(-1,p.y*block_size-1,8*block_size-2, (p.y+1)*(block_size)-2,col.white)
    end
    fillp()

    for x=-1,8 do
        for y=-1,8 do
            local b=board[x][y]
            if b~=nil then
                local jiggle=(b.animate or 0)>0 and 1 or 0
                spr(block_types[b.n].t,x*block_size+b.dx,y*block_size+b.dy+jiggle)
                -- print(b.dx,x*block_size+b.dx-1,y*block_size+b.dy,col.white)
                -- print(b.dy,x*block_size+b.dx-1,y*block_size+b.dy+6,col.white)
                -- print(b.dx..","..b.dy,x*block_size+b.dx,y*block_size+b.dy,col.white)
            end
        end
    end
    clip()
    
    -- draw selection
    local selCol= mode=="move" and {col.gray1,col.white} or {col.red1,col.red2}
    rect(p.x*block_size-1,p.y*block_size-1,p.x*block_size+8,p.y*block_size+8,selCol[1])
    rect(p.x*block_size-2,p.y*block_size-2,p.x*block_size+9,p.y*block_size+9,selCol[2])

    -- draw particles
    for part in all(particles) do
        part:draw()
    end

    -- draw scores
    for i=1,#block_types do
        local b=block_types[i]
        spr(b.t, 90, i*8+1-20)
        print(score[i], 100, 2+i*8-20, col.white)
    end
    camera(0,0)

    -- draw order
    print("order", 103,61,col.grey1)
    if baddie_current~=nil then
        -- stop(tostring(baddie_current.food))
        local food_n = baddie_current.food.n

        local origFood = food_types[food_n]

        local y = 69
        for ing in all(origFood.ingredients) do
            local n = block_name[ing]
            local block = block_types[n]
            spr(block.t, 103, y)
            -- todo work out if we've done this

            local isDone=true
            for ingLeft in all(baddie_current.food.ingredients) do
                if ingLeft==ing then
                    isDone=false
                end
            end
            if isDone then
                spr(36,103+10,y)
            else
                spr(35,103+10,y)
            end

            -- stop(tostring(ing))
            -- spr(food_types[n].t, 103, y, 1, 1, false, false)
            -- print(origFood.ingredients[ing], 110, y, col.white)
            y+=8
        end
        -- if origFood~=nil then
        --     spr(b.t, 90, i*8+1-20)
        --     print(score[i], 100, 2+i*8-20, col.white)
        -- end



        -- get original list of ingredients for given food



        -- for ing in baddie_current.food.ingredients do
        --     local n=block_name[ing]
        -- end
    end

    battle_draw()

    camera(0,0)

    -- all other objects
    for ob in all(obs) do
        ob:draw()
    end
end

function _update60()
    frame=(frame+1)%60

    if flr(rnd(120))==0 then
        -- make a random item animate
        local x=flr(rnd(8))
        local y=flr(rnd(8))
        local b=board[x][y]
        if b~=nil then
            b.animate=10
        end
    end

    -- update item animations
    for x=0,7 do
        for y=0,7 do
            local b=board[x][y]
            if b~=nil then
                if (b.animate or 0)>0 then
                    b.animate-=1
                    -- b.dx=rnd(2)-1
                    -- b.dy=rnd(2)-1
                end
                --     b.dx=0
                --     b.dy=0
                -- end
            end
        end
    end

    if mode=="move" then
        -- move mode is moving the 'cursor' around 
        if btnp(0) then p.x-=1 end
        if btnp(1) then p.x+=1 end
        if btnp(2) then p.y-=1 end
        if btnp(3) then p.y+=1 end

        p.x=max(0,min(7,p.x))
        p.y=max(0,min(7,p.y))
    elseif mode=="slide" then
        if btnp(0) or btnp(1) then
            local isLeft=btnp(0)
            if slide_target==nil then
                slide_target={dir="x", d=isLeft and -1 or 1,off=0}
            elseif slide_target.dir=="x"  then
                -- add an extra tile to the target
                slide_target.d+=isLeft and -1 or 1
            end
            slide_cooldown=15
        end

        if btnp(2) or btnp(3) then
            local isUp=btnp(2)
            if slide_target==nil then
                slide_target={dir="y", d=isUp and -1 or 1,off=0}
            elseif slide_target.dir=="y"  then
                -- add an extra tile to the target
                slide_target.d+=isUp and -1 or 1
            end
            slide_cooldown=15
        end

        if slide_target~=nil then
            -- animate sliding a row left and right
            if (slide_target.d<0 and slide_target.off>slide_target.d*block_size) or
                (slide_target.d>0 and slide_target.off<slide_target.d*block_size)
            then
                if slide_target.dir=="x" then
                    local dx=slide_target.d/abs(slide_target.d)
                    shift_row(p.y,dx) -- to get 1 or -1
                    slide_target.off+=dx
                else
                    local dy=slide_target.d/abs(slide_target.d)
                    shift_col(p.x,dy) -- to get 1 or -1
                    slide_target.off+=dy
                end
            else
                -- we're at the target
                slide_target=nil
            end
            
        else 
            -- exit move mode after a delay
            slide_cooldown-=1
            if slide_cooldown<=0 and not btn(4) and not btn(5) then
                mode="move"

                -- clear all blocks off the sides of the board
                for x=-1,8 do
                    board[x][-1]=nil
                    board[x][8]=nil
                end
                for y=-1,8 do
                    board[-1][y]=nil
                    board[8][y]=nil
                end

                -- hack - reset dx,dy for whole board
                for x=0,7 do
                    for y=0,7 do
                        if board[x][y]~=nil then
                            board[x][y].dx=0
                            board[x][y].dy=0
                        end
                    end
                end

                board_check_for_lines()
            end
        end
    end

    -- enter slide mode
    if btn(4) or btn(5) then 
        if mode=="move" then
            mode="slide"
            slide_cooldown=60
            sfx(0)
        end
    end

    for col=0,7 do
        board_fall(col)
    end

    for part in all(particles) do
        part:update()
    end

    battle_update()

    -- all other objects
    for ob in all(obs) do
        ob:update()
    end
end
