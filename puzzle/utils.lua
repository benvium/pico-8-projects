function clone(from)
    local to = {}
    for key, value in pairs(from) do
        to[key] = value
    end
    return to
end