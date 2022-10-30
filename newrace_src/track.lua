track2={
    -- length, turn, items, itemMode, hill
    {100,0,{"stand"},"both"},
    {200,0,{"person","tree"},"both"},
    {150,-.5,{"postLeft","postRight"},"all"},
    {250,0,{"right","thirty"},"alt"},
    {100,0,{"lard","thirty"}},
    {100,0,{"left"}},
}

-- add some gems
addGems(300,20, 0.3, 0, 10)
addGems(1800,20, -0.3, 0, 10)

-- add up track lengths
trackLength2=0
for i=1,#track2 do
    trackLength2+=track2[i][1]
end
printh("trackLength2:"..trackLength2)

function getTrack2(distance_) 
    local distance=distance_%trackLength2
    local i=1
    local total=0
    while i<=#track2 do
        total+=track2[i][1]
        if distance<total then
            return track2[i]
        end
        i+=1
    end
    return track2[#track2]
end


track={
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    -- 0.3,0.7,0.7,0.7,0.7,0.3,
    0,
    -- -0.3,-1,-1,-1,-0.3,
    0,
    0,
    0,
    0,
    0,
    0,
    -- -0.5,-0.5,0.5,0.5,-0.5,-0.5,0.5,0.5
}
hills={
    -- 0,
    -- 0,
    -- 0,
    -- 0,
    -- 0,
    -- 0,
    -- 0,
    -- 0,
    -- 1,
    -- 1,
    -- 1,
    -- 0,
    -- -1,
    -- -1,
    -- -1,
}
tracklength=count(track)

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