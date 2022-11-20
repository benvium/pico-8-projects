block_types={
    [1]={
        -- diamond
        n=1,
        t=1,
        sfx=0,
    },
    [2]={
        -- apple
        n=2,
        t=2,
        sfx=2,
    },
    [3]={
        -- leaf
        n=3,
        t=3,
        sfx=3,
    },
    [4]={
        -- heart
        n=4,
        t=4,
        sfx=4,
    },
    [5]={
        -- potion
        n=5,
        t=5,
        sfx=5,
    },
    [6]={
        -- crate
        n=6,
        t=17,
        sfx=4,
    },
    [7]={
        -- grapes
        n=7,
        t=18,
        sfx=6,
    },
}

block_size=10

function _init()
    board={}

    -- board is 8x8 but we have a row around the edge
    -- for dropping tiles in or rotating around
    for x=-1,8 do
        for y=-1,8 do
            if board[x]==nil then board[x]={} end
            board[x][y]=nil
        end
    end
    
    for x=0,7 do
        for y=0,7 do
            local info = rnd(block_types)
            board[x][y]={
                item=info, 
                dx=0,
                dy=0
            }
        end
    end

    
    -- todo run until no matches
    for x=0,7 do
        board_fall(x)
    end

    -- tile coords
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
end

function _draw()
    cls(0)
    camera(0,0)
    map(0,0,0,0,16,16)

    camera(-2*8-1, -2*8-1)

    rect(-2,-2,8*block_size-1,8*block_size-1,col.brown)
    rect(-2-8,-2-8,9*block_size-3,9*block_size-3,col.black)

    -- CLIP TO GAME AREA
    -- clip(2*8,2*8,8*block_size,8*block_size)
    -- todo put back

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
                spr(b.item.t,x*block_size+b.dx,y*block_size+b.dy)
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
        spr(b.t, 90, i*8+1)
        print(score[i], 100, 2+i*8, col.white)
    end

    -- for t,s in pairs(score) do
    --     print(t..":"..s,0,0,col.white)
    -- end
end

function _update60()
    frame=(frame+1)%60

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
            if slide_cooldown<=0 then
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

                local blockKillCount=0
                -- see if we've made any lines
                for x=0,7 do
                    for y=0,7 do
                        
                        local b=board[x][y]
                        -- reset dx/dy just in case
                        if b~=nil then
                            b.dx=0
                            b.dy=0
                            local lineBlocks = {{item=b,x=x,y=y}}
                            check_lines(b.t,x,y,lineBlocks)

                            -- todo put back 
                            -- if #lineBlocks>=3 then
                            --     for block in all(lineBlocks) do
                            --         block_kill(block)
                            --         blockKillCount+=1
                            --         -- todo dupe
                            --     end
                            -- end

                            -- local lineBlocksCol = {{item=b,x=x,y=y}}
                            -- check_lines_col(b.t,x,y,lineBlocksCol)
                            -- if #lineBlocksCol>=3 then
                            --     for block in all(lineBlocksCol) do
                            --         block_kill(block)
                            --         blockKillCount+=1
                            --     end
                            -- end
                        end
                    end
                end
                if blockKillCount>0 then
                    sfx(1)
                end
            end
        end
    end

    -- enter slide mode
    if btnp(4) then 
        if mode=="move" then
            mode="slide"
            slide_cooldown=60
            sfx(0)
        end
    end

    if btnp(5) then 
        -- temp pop a block
        board[p.x][p.y]=nil
    end

    -- todo put back fall mode
    -- if mode=="move" then
    --     for col=0,7 do
    --         board_fall(col)
    --     end
    -- end

    for part in all(particles) do
        part:update()
    end
end
