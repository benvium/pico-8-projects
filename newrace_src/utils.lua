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
  