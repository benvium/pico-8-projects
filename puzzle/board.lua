block_types={
    [1]={
        -- diamond
        n=1,
        t=1,
        sfx=1,
        c=col.blue3
    },
    [2]={
        -- apple
        n=2,
        t=2,
        sfx=2,
        c=col.pink2
    },
    [3]={
        -- leaf
        n=3,
        t=3,
        sfx=3,
        c=col.green2,
    },
    [4]={
        -- heart
        n=4,
        t=4,
        sfx=4,
        c=col.pink2,
    },
    [5]={
        -- potion
        n=5,
        t=5,
        sfx=6,
        c=col.red2,
    },
    [6]={
        -- crate
        n=6,
        t=17,
        sfx=5,
        c=col.brown,
    },
    [7]={
        -- grapes
        n=7,
        t=18,
        sfx=3,
        c=col.blue2,
    },
    [8]={
        -- axe
        n=8,
        t=19,
        sfx=5,
        c=col.grey2
    },
    [9]={
        -- feather
        n=9,
        t=20,
        sfx=1,
        c=col.white
    },
}


function board_init()
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
                n=info.n, -- block type number (index into block_types)
                dx=0,
                dy=0
            }
        end
    end

    -- used to trigger checking for lines *after* falling has finished
    falling_cooldown=0
end

function check_lines_vertical(n,x,y,blocks)
    local r=1
    
    -- look left
    while(x+r>=0 and board[x+r] and board[x+r][y] and board[x+r][y].n==n) do
        add(blocks, {x=x+r,y=y})
        r+=1
    end
    -- look right
    r=-1
    while(x+r<8 and board[x+r] and board[x+r][y] and board[x+r][y].n==n) do
        add(blocks, {x=x+r,y=y})
        r-=1
    end
end

function check_lines_horizontal(n,x,y,blocks)
    -- look up
    local r=1
    while(y+r>=0 and board[x] and board[x][y+r] and board[x][y+r].n==n) do
        add(blocks, {x=x,y=y+r})
        r+=1
    end

    -- look down
    r=-1
    while(y+r<8 and board[x] and board[x][y+r] and board[x][y+r].n==n) do
        add(blocks, {x=x,y=y+r})
        r-=1
    end
end


function board_fall(x)
    local moved=false
    for y=-1,7 do
        local b=board[x][y]
        if b~=nil and y<7 then
            -- look below
            local ab=board[x][y+1]
            if ab==nil then
                -- otherwise..
                b.dy+=1
                if b.dy%block_size==0 then
                    board[x][y+1]=b
                    board[x][y]=nil
                    b.dy=0
                    moved=true
                end
            end
        end
    end

    -- check to see if we should drop new items at the topmost
    for x=0,7 do
        if board[x][0]==nil and board[x][-1]==nil then
            board[x][-1]={n=rnd(block_types).n, dx=0,dy=0}
            moved=true
        end
    end

    -- a bit after falling ends, trigger a check for lines
    if not moved then
        if falling_cooldown>0 then falling_cooldown-=1 end

        if falling_cooldown==0 then
            falling_cooldown=-1
            board_check_for_lines()
        end
    else
        falling_cooldown=10
    end
end


function block_kill(x,y)
    local item=board[x][y]
    board[x][y]=nil

    if item~=nil then
        local c=block_types[item.n].c
        smoke_add(x*block_size+block_size/2,y*block_size+block_size/2,0,c,0,2)
        smoke_add(x*block_size+block_size/2,y*block_size+block_size/2,0,c,2,2)
        smoke_add(x*block_size+block_size/2,y*block_size+block_size/2,0,c,5,2)
        score[item.n]=(score[item.n] or 0)+1
    end
end

function shift_row(y,dx)
    local isLeft=dx<0

    local shift=false
    -- all blocks on row p.y move left
    for x=0,7 do
        if board[x] and board[x][y] then
            board[x][y].dx+= isLeft and -1 or 1

            if (isLeft and board[x][y].dx==-block_size)
            or (not isLeft and board[x][y].dx==block_size) then
                board[x][y].dx=0
                shift=true
            end
        end
    end
    
    -- clone left-most block to right
    if isLeft then 
        local i=board[0][y]
        board[8][y]=i and {n=i.n, dx=i.dx, dy=i.dy} or nil
    else
        local i=board[7][y]
        board[-1][y]=i and {n=i.n, dx=i.dx, dy=i.dy} or nil
    end

    if shift then
        -- left-most block goes onto the right
        local copy={}
        for x=0,7 do
            copy[x]=board[x][y] or nil
        end

        if isLeft then
            for x=0,6 do
                board[x][y] = copy[x+1]
            end
            board[7][y]=copy[0]
        else
            for x=1,7 do
                board[x][y] = copy[x-1]
            end
            board[0][y]=copy[7]
        end
    end
end

function shift_col(x,dy)
    local isUp=dy<0

    local shift=false
    -- all blocks on col x move up
    for y=0,7 do
        if board[x] and board[x][y] then
            board[x][y].dy+= isUp and -1 or 1

            if (isUp and board[x][y].dy==-block_size)
            or (not isUp and board[x][y].dy==block_size) then
                board[x][y].dy=0
                shift=true
            end
        end
    end

    -- clone top-most block to bottom
    if isUp then 
        local i=board[x][0]
        board[x][8]=i and {n=i.n,dx=i.dx,dy=i.dy} or nil
    else
        local i=board[x][7]
        board[x][-1]=i and {n=i.n,dx=i.dx,dy=i.dy} or nil
    end

    if shift then
        -- top-most block goes onto the bottom
        local copy={}
        for y=0,7 do
            copy[y]=board[x][y] or nil
        end

        if isUp then
            for y=0,6 do
                board[x][y] = copy[y+1]
            end
            board[x][7]=copy[0]
        else
            for y=1,7 do
                board[x][y] = copy[y-1]
            end
            board[x][0]=copy[7]
        end
    end
end


function board_check_for_lines()
    local blockKillCount=0
    local allBlocksKilled={}
    -- see if we've made any lines
    for x=0,7 do
        for y=0,7 do
            
            local b=board[x][y]
            -- reset dx/dy just in case
            if b~=nil then
                b.dx=0
                b.dy=0
                local lineBlocks = {{x=x,y=y}}
                check_lines_horizontal(b.n,x,y,lineBlocks)

                if #lineBlocks>=3 then
                    for block in all(lineBlocks) do
                        local n = board[block.x][block.y].n
                        block_kill(block.x, block.y)
                        blockKillCount+=1
                        add(allBlocksKilled, {x=block.x, y=block.y, n=n})
                    end
                end

                local lineBlocksCol = {{x=x,y=y}}
                check_lines_vertical(b.n,x,y,lineBlocksCol)
                if #lineBlocksCol>=3 then
                    for block in all(lineBlocksCol) do
                        local n = board[block.x][block.y].n
                        block_kill(block.x, block.y)
                        blockKillCount+=1
                        add(allBlocksKilled, {x=block.x, y=block.y, n=n})
                    end
                end
            end
        end
    end
    if blockKillCount>0 then
        local block1 = allBlocksKilled[1]
        
        if block1 then
            local fx = block_types[block1.n] and block_types[block1.n].sfx
            -- stop(tostring(block1)..','..block1.n..''..tostring(block_types[block1.n]))
            -- stop()
            if fx~=nil then
                sfx(fx,0)
            end
        end
        -- fx = block
        -- local fx=allBlocksKilled[0] and block_types[allBlocksKilled[0].n].fx or 1
        -- 
    end
end