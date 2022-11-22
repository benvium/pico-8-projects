

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
    cls(col.blue1)
    camera(0,0)

    clip(0,0,128,128-28)
    map(0,0,-8,-6,17,14.5)
    clip()

    -- camera
    camera(-8, -11)

    -- inner border
    rect(-2,-2,8*block_size-1,8*block_size-1,col.blue1)

    -- outer border
    rect(-9,-10,9*block_size-3,9*block_size-3,col.black)

    -- CLIP TO GAME AREA
    clip(7,10,8*block_size,8*block_size)
    rectfill(-2,-2,8*block_size,8*block_size,col.black)
    -- cls(col.black)

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
    end
    fillp()

    for x=-1,8 do
        for y=-1,8 do
            local b=board[x][y]
            if b~=nil then
                local jiggle=(b.animate or 0)>0 and 1 or 0
                spr(block_types[b.n].t,x*block_size+b.dx,y*block_size+b.dy+jiggle)
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
    local scoreX=90
    local scoreY=-5
    local row=0
    for i=1,#block_types,3 do
        local b=block_types[i]
        local y=flr(i/3)*2
        -- local y=flr(row)*3
        -- cls(0)
        -- stop(tostring(b),0,0,col.pink2)
        if b.hide~=true then 
            spr(b.t, scoreX, y*8+scoreY)
            print(score[i], scoreX+1, y*8+scoreY+9, col.black)
            print(score[i], scoreX+2, y*8+scoreY+9, col.white)
        end
        
        local b2=block_types[i+1]
        if b2~=nil and b2.hide~=true then
            spr(b2.t, scoreX+10, y*8+scoreY)
            print(score[i+1], scoreX+11, y*8+scoreY+9, col.black)
            print(score[i+1], scoreX+12, y*8+scoreY+9, col.white)
        end
        local b3=block_types[i+2]
        if b3~=nil and b3.hide~=true then
            spr(b3.t, scoreX+20, y*8+scoreY)
            print(score[i+2], scoreX+21, y*8+scoreY+9, col.black)
            print(score[i+2], scoreX+22, y*8+scoreY+9, col.white)
        end
    end
    camera(0,0)

    -- draw order
    print("order", 103,59,col.grey1)
    if baddie_current~=nil then
        -- stop(tostring(baddie_current.food))
        local food_n = baddie_current.food.n

        local origFood = food_types[food_n]

        local y = 66
        local x = 104
        for ing in all(origFood.ingredients) do
            local n = block_name[ing]
            local block = block_types[n]
            -- background
            -- spr(55, x, y)
            spr(block.t, x, y)

            local isDone=true
            for ingLeft in all(baddie_current.food.ingredients) do
                if ingLeft==ing then
                    isDone=false
                end
            end
            if isDone then
                spr(36,x+10,y)
            else
                spr(35,x+10,y)
            end

            y+=8
        end
    end

    battle_draw()

    camera(0,0)

    -- all other objects
    for ob in all(obs) do
        ob:draw()
    end

    -- timer
    rectfill(0,128-28,128,128-28+3,col.black)
    -- fill red based on timer / max_timer
    local timerFill = flr(timer/max_timer*128)
    rectfill(0,128-28,timerFill,128-28+3,col.red1)
    rectfill(0,128-28,timerFill,128-28+2,col.red2)
    rectfill(0,128-28,timerFill,128-28,col.pink1)

    -- draw money
    local coin=block_types[block_name["coin"]]
    local coinX=24
    spr(coin.t, coinX, 98)
    print(score[block_name["coin"]], coinX+10, 100, col.black)
    print(score[block_name["coin"]], coinX+11, 100, col.white)
    
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
                end
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
            sfx(0,1)
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

    timer-=1
    if timer<=0 then
        game_end()
    end
end

function game_end()
    -- print("game over please finish this")
    _init()
end
