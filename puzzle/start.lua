dtb_init(5)

function start_init()
    start_title_dx=0
    start_instructions=false

    searchlight_colors={col.yellow, col.orange, col.red, col.pink, col.purple, col.blue, col.cyan, col.green, col.white}

    -- Set the starting position of the searchlights
    searchlights = {
        {angle = 0, direction = 1, col=flr(rnd(#searchlight_colors))},
        {angle = 1.57, direction = -1, col = flr(rnd(#searchlight_colors))},
        {angle = 3.14, direction = 1, col= flr(rnd(#searchlight_colors))},
        {angle = 4.71, direction = -1, col= flr(rnd(#searchlight_colors))},
        {angle = 6.28, direction = 1, col= flr(rnd(#searchlight_colors))},
    }

    music(19,2000)

    mode="start" -- or "move", "slide", or "end"
end

function start_update()
    start_title_dx=sin(frame/60)*6

    if btnp(4) then
        if not start_instructions then
            start_instructions=true

            dtb_disp("hungry people need food from your mobile burger bus! in this block-matching game, you'll need to match lines of three or more to get ingredients for your customers' meals. slide rows or columns on the grid by holding the (x) button and pressing up/down/left/right. happy customers pay coins!", function()
                start_instructions=false
            end)
        end
    elseif btnp(5) then
        game_init()
    end

    if flr(frame/10)%2==0 then
        smoke_add(47,73,-.4,col.white,0,2)
    end

    -- update particles
    for part in all(particles) do
        part:update()
    end

    dtb_update()
end

function draw_searchlights()
    -- Set the color of the searchlights to white
  
    -- Loop through each searchlight in the array
    for i, searchlight in pairs(searchlights) do
      color(searchlight.col)

      -- Calculate the x and y coordinates of the searchlight
      local searchlight_x = 64 + cos(searchlight.angle/3.14/4) * 96
      local searchlight_y = 64 + sin(searchlight.angle/3.14/4) * 96
  
      -- Draw the searchlight starting at the center of the screen
      line(64, 64, searchlight_x, searchlight_y)
      line(64, 64, searchlight_x + 1, searchlight_y)
  
      -- Move the searchlight in the specified direction
      searchlight.angle = searchlight.angle + (0.05 * searchlight.direction)
  
      -- If the searchlight reaches the edge of the screen, reverse its direction
      if searchlight.angle > 6.28 or searchlight.angle < 0 then
        searchlight.direction = -searchlight.direction
      end

      -- color cycle
      if flr(frame/30)%2==0 then
        searchlight.col=(searchlight.col+1)%15+1
      end
    end
  end

function start_draw()
    cls(col.blue1)

    draw_searchlights()

    -- draw particles
    for part in all(particles) do
        part:draw()
    end

    map(0, 48, 0, 0, 16, 16)
    local tx=24
    local ty=32
    local dx=start_title_dx
    obprint("burger bus", tx, ty+4, col.blue1, col.black, 2)
    obprint("burger bus", tx+dx/4, ty+2, col.grey1, col.black, 2)
    obprint("burger bus", tx+dx/2, ty, col.white, col.black, 2)
    tx=18
    ty=100
    line(0,88,127,88, col.black)
    rectfill(tx-4,ty-4,tx+90,ty+18, col.gray1)
    rect(tx-4,ty-4,tx+90,ty+18, col.grey2)
    print("press ❎ to start", tx, ty-1, col.black)
    print("or 🅾️ for instructions", tx, ty+10-1, col.black)
    print("press ❎ to start", tx, ty, col.white)
    print("or 🅾️ for instructions", tx, ty+10, col.white)

    print("BENVIUM AND DEMON88 '22", 16, 121, col.grey2)

    dtb_draw()

    -- camera(0,0)
    -- smoke_add(64, 64, 0, col.white)
end