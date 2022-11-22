max_timer=4800

block_name={
    ["cheese"]=1,
    ["leaf"]=2,
    ["bread"]=3,
    ["water"]=4,
    ["ketchup"]=5,
    ["fries"]=6,
    ["coin"]=7,
    ["meat"]=8,
}

block_sfx={
    [1]={3,7,8},
    [2]={10,11,12},
    [3]={1,1,1},
    [4]={16,16,16} --clock
}

block_types={
    [1]={
        -- cheese
        n=1,
        t=2,
        sfx=1,
        c=col.yellow
    },
    [2]={
        -- leaf
        n=2,
        t=3,
        sfx=2,
        c=col.green1
    },
    [3]={
        -- bread
        n=3,
        t=4,
        sfx=1,
        c=col.brown
    },
    [4]={
        -- water
        n=4,
        t=17,
        sfx=2,
        c=col.blue3
    },
    [5]={
        -- ketchup
        n=5,
        t=18,
        sfx=2,
        c=col.red2,
    },
    [6]={
        -- chips
        n=6,
        t=19,
        sfx=1,
        c=col.yellow
    },
    [7]={
        -- coin
        n=7,
        t=54,
        sfx=3,
        c=col.orange,
        hide=true,
    },
    [8]={
        -- meat
        n=8,
        t=5,
        sfx=2,
        c=col.pink2
    },
    [9]={
        -- clock
        n=9,
        t=21,
        sfx=4,
        c=col.white,
        get=function(self, score)
            timer=min(timer+300*score,max_timer)
        end,
        hide=true,
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

    -- 
    timer=max_timer
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

    -- calculate score
    if #blocks==3 then 
        return 1
    elseif #blocks==4 then
        return 2
    elseif #blocks==5 then
        return 4
    end
    return 0
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

    -- calculate score
    if #blocks==3 then 
        return 1
    elseif #blocks==4 then
        return 2
    elseif #blocks==5 then
        return 4
    end
    return 0
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

function block_fx(n,toAdd)
    local fx1 = block_types[n] and block_types[n].sfx or nil
    if fx1==nil then return end
    local fx2=block_sfx[fx1]
    if fx2==nil then return end
    local fx3=fx2[toAdd]
    sfx(fx3,0)
end


function board_check_for_lines()
    local blockKillCount=0
    local fx
    -- see if we've made any lines
    for x=0,7 do
        for y=0,7 do
            local b=board[x][y]
            if b~=nil then
                local lineBlocks = {{x=x,y=y}}
                local toAdd = check_lines_horizontal(b.n,x,y,lineBlocks)

                if toAdd>0 then
                    blockKillCount = battle_add_scores(x,y,b,toAdd, lineBlocks, blockKillCount)
                end

                local lineBlocksCol = {{x=x,y=y}}
                toAdd = check_lines_vertical(b.n,x,y,lineBlocksCol)
                if toAdd>0 then
                    blockKillCount = battle_add_scores(x,y,b,toAdd, lineBlocksCol, blockKillCount)
                end
            end
        end
    end
    if blockKillCount>0 then
       battle_check_ingredients()
    end
end

function battle_add_scores(x,y,b,toAdd, lineBlocks, blockKillCount)
    for block in all(lineBlocks) do
        if board[block.x][block.y]~=nil then
            local n = board[block.x][block.y].n
            block_kill(block.x, block.y)
            blockKillCount+=1
        end
    end
    score[b.n]=min(99, (score[b.n] or 0)+toAdd)

    board_collect_popover(b.n,toAdd,x*block_size+12)

    block_fx(b.n,toAdd)

    -- run custom get function (e.g. add time, add coins)
    local bt = block_types[b.n]
    if bt and bt.get then
        bt:get(toAdd)
    end

    return blockKillCount
end