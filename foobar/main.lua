function _draw()
    -- draw baddies
    for i = 1, #baddies do
        baddies[i]:draw()
    end

    items={}
    

end

function collide(a, b)
    return a.x < b.x + b.w and
           a.x + a.w > b.x and
           a.y < b.y + b.h and
           a.y + a.h > b.y
end

function _update()
    -- update baddies
    for i = 1, #baddies do
        baddies[i]:update()
    end

    -- update player
    player:update()

    -- check for collisions
    for i = 1, #baddies do
        if collide(player, baddies[i]) then
            print("collision!")
        end
    end
end

function _init()
    -- initialize baddies
    for i = 1, 10 do
        baddies[i] = Baddie()
    end

    -- initialize player
    player = Player()
end

function _draw()
    cls()
    -- draw baddies
    for i = 1, #baddies do
        baddies[i]:draw()
    end

    -- draw player
    player:draw()
end

function _update()
    -- update baddies
    for i = 1, #baddies do
        baddies[i]:update()
    end

    -- update player
    player:update()

    -- check for collisions
    for i = 1, #baddies do
        if collide(player, baddies[i]) then
            print("collision!")
        end
    end
end

function _init()
    -- initialize baddies
    for i = 1, 10 do
        baddies[i] = Baddie()
    end

    -- initialize player
    player = Player()
end

function _draw()
    cls()
    -- draw baddies
    for i = 1, #baddies do
        baddies[i]:draw()
    end

    -- draw player
    player:draw()
end

function _update()
    -- update baddies
    for i = 1, #baddies do
        baddies[i]:update()
    end

    -- update player
    player:update()

    -- check for collisions
    for i = 1, #baddies do
        if collide(player, baddies[i]) then
            print("collision!")
end

function _update()
    -- update baddies
    for i = 1, #baddies do
        baddies[i]:update()
    end
end