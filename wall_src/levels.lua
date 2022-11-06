levels={
    [1]={
        -- 0 = outside, 16 = underground
        bgtilex=0,
        -- y of start of level (0 or 32)
        tiley=0,
        music=nil,
        title="world 1-1"
    },
    [2]={
        -- 0 = outside, 16 = underground
        bgtilex=16,
        -- y of start of level (0 or 32)
        tiley=32,
        music=0,
        title="World 1-2"
    },
    [3]={
        -- 0 = outside, 16 = underground
        bgtilex=0,
        -- y of start of level (0 or 32)
        tiley=48,
        -- music=0
    },
}

saveMenuLevel=1

function saveMenuLevelCallback(B)
    -- if (B&1 > 0) then 
    --     print("LEFT WAS PRESSED") 
    -- end
    -- if (B&2 > 0) then 
    --     saveMenuLevel=(saveMenuLevel+1)%5
    --     menuitem(1, "Save level "..saveMenuLevel, saveMenuLevelCallback)
    --     return true
    -- end
    -- if (B&3>0) then
        
    -- end
end

-- ADD MENU ITEM TO SAVE LEVEL data
menuitem(1, "cart to p8l", function() 
    sfx(fx.land)
    compress(0, current_level)
    sfx(fx.coin)
    return false
end)

menuitem(2, "p8l to cart", saveMenuLevelCallback)


-- note that ord('0') is 48
function hex(v) 
    local s,l,r=tostr(v,true),3,11
    while(ord(s,l)==48) do l+=1 end
    while(ord(s,r)==48) do r-=1 end
    return sub(s,min(l,6),r>7 and r or 6)
end

function left_pad(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

function hex2(v) 
 return left_pad(hex(v),2,'0')
end

-- compress 128-wide 16-high with simple RLE encoding
function compress(ty,name) 
    local output = ''
    local last=nil
    local count=1
    local uncompressed = ''
    local t=nil

    for y=ty,ty+16 do
        last=mget(0,y)
        -- first tile
        for x=1,128 do
            uncompressed=uncompressed..numtohex(t)
            t=mget(x,y)
            if last==t then
                count+=1
            else
                output=output..numtohex(last)..numtohex(count)
                count=1
            end
            last=t
        end
    end
    -- printh(output)
    printh("compressed:"..#output.." uncompressed:"..#uncompressed)
    printh("levels["..name.."].data='"..output.."'", "wall_src/levels/level_"..name, true)
end

function decompress(ty,data)
    printh("decompress: "..ty.." "..data)
    local x=0
    local y=ty
    local i=1
    while i<=#data do
        local a=sub(data,i,i+1)
        local b=sub(data,i+2,i+3)
        local tile=hex2num(a)
        local count=hex2num(b)
        -- stop()
        -- printh('>'..tile.."->"..count.."a:"..a.." b:"..b)
        for t=0,count-1 do
            -- printh('mset('..tile..','..x..","..y..")")
            mset(x,y,tile)
            x+=1
        end
        if x>=128 then 
            x-=128
            y+=1
        end
        i+=4
    end
end

function hex2num(hex)
    return tonum('0x'..hex)
end

function numtohex(num)
    return sub(tostr(num,true),5,6)
end

-- printh("12->0x"..numtohex(12))
-- printh("0x0c->"..hex2num("0c"))

-- compress(32,"2")
