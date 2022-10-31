track2={
    -- length, turn, items, itemMode, hill,sfx
    {25,0,{"person"},"both",0,8},
    {100,0,{"stand"},"both",0,8},
    {200,0,{"person","tree"},"both"},
    {50,0,{"right"}},
    {300,0.8,{"tree","sea"},"leftright",0,6},
    {100,0,{"tunnel"}},
    {100,0,{"tree","tree2","lard"}},
    {50,0,{"right"}},
    {200,1,{"tree","tree2","lard"},"random",0.5},
    {100,0,{"","thirty"}},
    {50,0,{"left"}},
    {200,-1,{"left"},-0.5},
    {200,-1,{"tunnel"}},
    {200,-1,{"tunnel"}},
}

-- add up track lengths
trackLength2=0
for i=1,#track2 do
    trackLength2+=track2[i][1]
end
printh("trackLength2:"..trackLength2)

-- add some gems
addGems(300,20, 0.3, 0, 10)
addGems(1800,20, -0.3, 0, 10)
printh("gems:"..gems)

-- returns track info:
-- {length, turn, items, itemMode, hill}, how far through
function getTrack2(distance_) 
    local distance=distance_%trackLength2
    local i=1
    local total=0
    while i<=#track2 do
        total+=track2[i][1]
        if distance<total then
            return track2[i],distance-(total-track2[i][1])
        end
        i+=1
    end
    return track2[#track2]
end


-------------------

-- 'sand'
-- shadinggrs = {
--     {col.brown,col.orange},
--     {col.yellow,col.orange},
--     {col.yellow,col.orange},
--     {col.yellow,col.orange},
--     {col.yellow,col.orange},
--     {col.yellow,col.orange},
--     {col.yellow,col.orange},
--     {col.yellow,col.orange},
--     {col.yellow,col.orange},
--     {col.yellow,col.orange},
--     {col.yellow,col.orange},
-- }

shadinggrs = {
    {col.green1,col.grey1},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
    {col.green1,col.green2},
}

shadingroad = {
    col.blue2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
    col.grey2,
}

shadinglns = {
    {col.grey2,col.red1},
    {col.white,col.red1},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
    {col.white,col.red2},
}