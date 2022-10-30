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
    red2=8
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