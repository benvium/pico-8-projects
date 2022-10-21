col={
    green1=3,
    green2=11,
    blue1=1,
    blue2=13,
    blue3=12,
    grey1=5,
    grey2=6,
    white=7
}

distance=0

function _update()
    distance=distance+1
end

function _draw()
    cls()
    --print("Hello World!", 0, 0, 7)

    --
    -- local yg=64
    -- local g1=24
    -- local l1=26
    -- local l2=128-l1
    -- local g2=128-g1
    local screensize=128
    local roadh=78

    local lines = {}
    for y1=0,roadh do
        local y=y1+screensize-roadh
        local perspective = 0.85*(y1/roadh)+0.15
        local l = sin(10*((1-perspective)^3)+(distance*0.1)%3.14)>0
        lines[y] = l
    end

    local idx = 0x6000

    for x=0,screensize do
        for y1=0,roadh do
            local y=y1+screensize-roadh
            local perspective = 0.85*(y1/roadh)+0.15
            -- local perspective = 0.3*(y1/roadh)+0.

            local roadw=0.8
            roadw=roadw*0.5*perspective
            local midw=0.5
            local edgew=roadw*0.2

            local lgrassw = (midw-roadw-edgew)*screensize
            local ledge = (midw-roadw)*screensize
            local redge = (midw+roadw)*screensize
            local rgrass = (midw+roadw+edgew)*screensize

            local lines = lines[y] --sin(10*((1-perspective)^3)+(distance*0.1)%3.14)>0
            local grasscolor=lines and col.green1 or col.green2
            local roadcolor = col.grey1 //lines and col.grey1 or col.grey2
            if lines and (x%2==0 or (y%2==1 and (x-1)%2==0)) then
             roadcolor = col.grey2
            end
            
            local c
            if x<lgrassw then c = grasscolor 
            elseif x<ledge then c = col.white
            elseif x<redge then c = roadcolor
            elseif x<rgrass then c = col.white
            else 
                c=grasscolor
            end
            -- if x<g1 then
            --     c = col.green1
            -- elseif x<l1 then
            --     c = col.white
            -- elseif x<l2 then
            --     c = col.grey1
            -- elseif x<g2 then
            --     c = col.white
            -- else
            --     c=col.green1
            -- end
            if c ~= nil then
                -- pset(x,y,c)
                poke(idx, (x+1)16+x+y17+ncolor)
            end
        end
    end


    print(stat(7))


end

