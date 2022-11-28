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
        c=col.green2
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
        condition=function()
            return (customer_count or 0)>3
        end,
        n=9,
        t=21,
        sfx=4,
        c=col.white,
        get=function(self, score)
            timer=min(timer+300*score,max_timer)
        end,
        hide=true,
    },
    [10]={
        -- bomb
        -- only add bombs after 10 customers
        condition=function()
          return (customer_count or 0)>10 and rnd(4)<1
        end,
        n=10,
        t=1,
        c=col.white,
        sfx=1,
        hide=true,
        get=function(self)
            -- if you match bombs, explode whole board..
            for x=0,7 do
                for y=0,7 do
                    block_kill(x,y)
                end
            end

            -- four explosions
            self:touch(2,2)
            self:touch(5,5)
            self:touch(2,5)
            self:touch(5,2)
        end,
        touch=function(self,x,y)
            -- explode
            sfx(17,0)
            -- double channel for loud!
            sfx(17,2)

            local toKill={
                {x=x,y=y},
                {x=x+1,y=y},
                {x=x-1,y=y},
                {x=x,y=y+1},
                {x=x,y=y-1},
                {x=x+2,y=y},
                {x=x-2,y=y},
                {x=x,y=y+2},
                {x=x,y=y-2},
                {x=x+1,y=y+1},
                {x=x-1,y=y-1},
                {x=x+1,y=y-1},
                {x=x-1,y=y+1},
                {x=x+2,y=y+1},
                {x=x-2,y=y-1},
                {x=x+2,y=y-1},
                {x=x-2,y=y+1},
            }

            screen_shake_size=0.2

            for o in all(toKill) do
                block_kill(o.x,o.y)
            end

            for i=0,20 do
                particle_add(
                    (x+0.5)*block_size, 
                    (y+0.5)*block_size, 
                    rnd(4)-2,
                    rnd(4)-2-1,
                    37,
                    i/2,
                    50)

                smoke_add(
                    x*block_size+rnd(block_size), 
                    y*block_size+rnd(block_size),
                    rnd(2)-1,
                    rnd({col.red1,col.red2,col.yellow,col.orange}),
                    i/2,
                    5)
            end
        end,
    }
}

function get_next_block_n(x,y)
    local n=rnd(block_types).n

    while block_types[n].condition~=nil and not block_types[n]:condition(x,y) do
        n=rnd(block_types).n
    end

    return n
end


-- play the sfx for a block - can be different for lines of 3,4,5 
function block_fx(n,toAdd)
    -- map toAdd back to 1,2,3
    local i
    if toAdd==1 then i=1 end
    if toAdd==2 then i=2 end
    if toAdd>=4 then i=3 end

    local fx1 = block_types[n] and block_types[n].sfx or nil
    if fx1==nil then return end
    local fx2=block_sfx[fx1]
    if fx2==nil then return end
    local fx3=fx2[i]
    printh("block FX: "..fx3.." for n="..n)
    sfx(fx3,0)
end
