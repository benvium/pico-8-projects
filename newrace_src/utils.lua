col={
    green1=3,
    green2=11,
    blue1=1,
    blue2=13,
    blue3=12,
    grey1=5,
    grey2=6,
    white=7,
    red1=2,
    red2=8,
    brown=4,
    black=0,
    orange=9,
    yellow=10,
    pink1=14,
    pint2=15
}

function clone(from)
    local to = {}
    for key, value in pairs(from) do
        to[key] = value
    end
    return to
end

-- returns color at a point on the map
-- mx/my top-left of map
function colFromMap(x,y)
    local spriteunder=mget(x/8,y/8)
    if spriteunder==0 then return 0 end

    -- convert spritenumber to x/y on sprite sheet
    local spritex=(spriteunder%16)*8+(x%8)
    local spritey=flr(spriteunder/16)*8+(y%8)
    return sget(spritex,spritey)
end

function map_flag(x,y,flag)
    local fx = fget(mget(flr(flr(x)/8),flr(flr(y)/8)),flag)
    return fx
end

function tostring(any)
    if type(any)=="function" then 
        return "fn" 
    end
    if any==nil then 
        return "nil" 
    end
    if type(any)=="string" then
        return any
    end
    if type(any)=="boolean" then
        if any then return "true" end
        return "false"
    end
    if type(any)=="table" then
        local str = "{"
        for k,v in pairs(any) do
            str=str..tostring(k).."="..tostring(v)..",\n"
        end
        return str.."}"
    end
    if type(any)=="number" then
        return ""..any
    end
    return "unkown" -- should never show
end