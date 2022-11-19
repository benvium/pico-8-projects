block_types={[1]={t=1},[2]={t=2},[3]={t=3},[4]={t=4},[5]={t=5}}

board={}

block_size=10

function _init()
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
            board[x][y]={t=rnd(block_types).t, dx=0,dy=0}
        end
    end

    
    -- todo run until no matches
    for x=0,7 do
        board_fall(x)
    end

    -- tile coords
    p={x=4,y=4}

    particles={}

    mode="move"

    frame=0
end

function _draw()
    cls(0)
    camera(0,0)
    map(0,0,0,0,16,16)

    camera(-2*8-1, -2*8-1)

    rect(-2,-2,8*block_size-1,8*block_size-1,col.brown)
    rect(-2-8,-2-8,9*block_size-3,9*block_size-3,col.black)

    -- CLIP TO GAME AREA
    clip(2*8,2*8,8*block_size,8*block_size)

    -- draw selection rows
    if frame%12<6 then
        fillp(0b0101101001011010)
    else
        fillp(0b1010010110100101)        
    end
    -- checkedboard pattern - animated ^ 
    rectfill(p.x*block_size-1,-1,(p.x+1)*(block_size)-2,8*block_size-2,col.blue1)
    
    rectfill(-1,p.y*block_size-1,8*block_size-2, (p.y+1)*(block_size)-2,col.blue1)

    if mode=="slide" then
        rect(p.x*block_size-1,-1,(p.x+1)*(block_size)-2,8*block_size-2,col.white)
        rect(-1,p.y*block_size-1,8*block_size-2, (p.y+1)*(block_size)-2,col.white)
    end
    fillp()

    for x=-1,8 do
        for y=-1,8 do
            local b=board[x][y]
            if b~=nil then
                spr(b.t,x*block_size+b.dx,y*block_size+b.dy)
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
end

-- 0 1 2 3 4 5 6 7
-- a b c d e f g h

-- 0 1 2 3 4 5 6 7
-- b c d e f g h a

function _update60()
    frame=(frame+1)%60

    if mode=="move" then
        if btnp(0) then p.x-=1 end
        if btnp(1) then p.x+=1 end
        if btnp(2) then p.y-=1 end
        if btnp(3) then p.y+=1 end

        p.x=max(0,min(7,p.x))
        p.y=max(0,min(7,p.y))
    elseif mode=="slide" then
        -- todo
        if btn(0) then 
            local shift=false
            -- all blocks on row p.y move left
            for x=0,7 do
                if board[x] and board[x][p.y] then
                    board[x][p.y].dx-=1
                    if board[x][p.y].dx%block_size==0 then
                        board[x][p.y].dx=0
                        shift=true
                    end
                end
            end
            -- clone left-most block to right
            board[8][p.y]=board[0][p.y]

            if shift then
                -- left-most block goes onto the right
                -- copy array
                local copy={}
                for x=0,7 do
                    copy[x]=board[x][p.y] or nil
                end
                
                for x=0,6 do
                    board[x][p.y] = copy[x+1]
                end
                board[7][p.y]=copy[0]
            end
            -- p.x-=1 
        end
        -- if btnp(1) then p.x+=1 end
        
    end

    -- temp 'pop' a block
    if btnp(4) or btnp(5)  then 

        if mode=="move" then
            mode="slide"
        elseif mode=="slide" then
            mode="move"
        end
        -- local t=board[p.x][p.y]
        -- board[p.x][p.y]=nil
        sfx(0)
        -- mode="move"
        -- wait(10)
        -- board[p.x][p.y]=t
    end

    if mode=="move" then
        for col=0,7 do
            board_fall(col)
        end
    end

    for part in all(particles) do
        part:update()
    end
end

function board_fall(x)
    local toDelete={}
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

                    -- see if we've made any lines
                    local lineBlocks = {{item=b,x=x,y=y+1}}
                    check_lines(b.t,x,y+1,lineBlocks)

                    if #lineBlocks>=3 then
                        foreach(lineBlocks, function (item)
                            add(toDelete, item)
                        end)
                    end
                end
            end
        end
    end

    -- check to see if we should drop new items at the topmost
    for x=0,7 do
        if board[x][0]==nil and board[x][-1]==nil then
            board[x][-1]={t=rnd(block_types).t, dx=0,dy=0}
        end
    end

    --
    if #toDelete>0 then
        sfx(1)
    end
    for i=1,#toDelete do
        local item=toDelete[i]
        board[item.x][item.y]=nil--{t=7,dx=0,dy=0}
        -- tmp
        smoke_add(item.x*block_size+block_size/2,item.y*block_size+block_size/2,0,col.white,0)
    end

    return #toDelete
end

function check_lines(t,x,y,blocks)
    local r=1
    
    -- look left
    while(x+r>=0 and board[x+r] and board[x+r][y] and board[x+r][y].t==t) do
        add(blocks, {x=x+r,y=y,item=board[x+r][y]})
        r+=1
    end
    -- look right
    r=-1
    while(x+r<8 and board[x+r] and board[x+r][y] and board[x+r][y].t==t) do
        add(blocks, {x=x+r,y=y,item=board[x+r][y]})
        r-=1
    end
    -- return blocks
end