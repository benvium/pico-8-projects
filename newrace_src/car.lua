

-- enemy cars
local cars={}

function add_car(distance, x, type)
    local car={
        d=distance,
        x=x,
        sprx=0*8, 
        spry=1*8,
        w=4,
        h=3,
        ax=0.5, -- anchor center
        scale=1.25,
        speed=0
    }
    if type=="green" then
        car.sprx=96
        car.spry=32
    elseif type=="lambo" then
        car.sprx=0
        car.spry=64
    end
    add(cars,car)
end

add_car(00, -0.55)
add_car(20, .55, "lambo")
add_car(150, .55)
add_car(300, .55,"green")
add_car(700, -.55,"lambo")
add_car(1300, -.55)
add_car(1500, -.55)
add_car(2000, -.55,"green")


function update_cars()
    -- some dupe here
  playerrect =  {
      x=64-16+turn*16+x+4,
      y=96+height/10+16,
      w=4*8-8,
      h=2*8
  }


  for car in all(cars) do
    local wasInFront = car.rect and car.rect.y < playerrect.y
    car.speed = min(car.speed+0.01, maxspeed*0.8)
    car.d += car.speed --max(0.5, maxspeed*.8) --speed<(maxspeed/2) and 0.5 or 2.5
    if (car.d>tracklength*100) then
        car.d=0
    end
    updateobject(car)

    -- check for collisions..
    if car.rect then
        local carhitbox = {
            x=car.rect.x+8,
            y=car.rect.y+20,
            w=car.rect.w-16,
            h=car.rect.h-20
        }
        if intersects(carhitbox, playerrect) then
            sfx(2,1)
            if carhitbox.y>playerrect.y then
                -- car is behind player
                car.speed=-0.5
                speed+=0.5 -- bump player forwards
            else
                car.speed+=1
                speed*=0.5 -- slow player down
            end
        end

        -- check for swooshes
        if wasInFront and car.rect.y>= playerrect.y then
            sfx(3,3)
        end
    end
end



end

local carsprite={
    center=64,
    l={196,200},
    r={132,136},
    up=48,
    down=44
}
carspriteanim=0


function update_player()
    carspriteanim=(carspriteanim+1)%4

    -- select car sprite
    carspr=64
    if height>20 then
        carspr=0x48
    elseif height<-10 then
        carspr=0x44
    elseif speed>0.1 then 

        if btn(0) then
            if skid>4 then carspr=carsprite.l[2] 
            else carspr=carsprite.l[1]
            end
            -- if carspr==carsprite.l[1] then
            --     carspr=carsprite.l[2]
            -- else
            --     carspr=carsprite.l[1]
            -- end
        elseif btn(1) then
            if skid>4 then carspr=carsprite.r[2] 
            else carspr=carsprite.r[1]
            end
        end
    end
end