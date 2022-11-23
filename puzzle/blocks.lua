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
