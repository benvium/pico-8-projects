battle_items={
    -- ["fire"]={
    --     t=41,
    -- }
}



food_types={
    [1]={
        name="cheeseburger",
        t=26,
        ingredients={"bread","cheese","meat"},
    },
    [2]={
        name="saladburger",
        t=27,
        ingredients={"bread","cheese","meat","leaf"},
    },
    [3]={
        name="ketchupburger",
        t=28,
        ingredients={"bread","meat","ketchup"},
    },
    [4]={
        name="coke",
        t=17,
        ingredients={"coke"},
    },
    [5]={
        name="water",
        t=19,
        ingredients={"water"},
    },
}

function battle_init()
    bx=0
    battle_can_move=true
    baddies={}

    item_interval=BADDIE_INTERVAL
    frame=0

    baddie_current=nil
end

BADDIE_INTERVAL=100

function battle_check_ingredients()
    local ob=baddie_current
    if ob==nil then return end

    printh("baddie wants "..ob.food.name)
    for ing in all(ob.food.ingredients) do
        local n=block_name[ing]
        printh("...need "..ing.."("..n..")")
        -- stop(n)
        if score[n]~=nil and score[n]>0 then
            score[n]-=1
            del(ob.food.ingredients,ing)
            sfx(7,0)
            -- smoke_add(ob.x+4,ob.y+4,-0.25,block_types[n].c)
            -- break
        end
    end

    if #ob.food.ingredients>0 then
        printh("baddie needs "..tostring(ob.food.ingredients))
    else
        printh("baddie defeated")
        del(baddies,ob)
        baddie_current=nil
        smoke_add(ob.x+4,ob.y+4,-0.25,col.white)
        sfx(8,0)
        battle_can_move=true
    end
    -- end
end


function battle_update()
    frame=(frame+1)%60
    if battle_can_move then
        bx=(bx-0.25)%128
        item_interval-=1
        if item_interval==0 then
            item_interval=BADDIE_INTERVAL
            battle_add_item()
        end
        for ob in all(baddies) do
            ob.x-=0.25
            ob:update()
            if ob.x<-10 then
                del(baddies,ob)
            end

            if ob.x>10 and ob.x<48 then
                if battle_can_move then
                    battle_can_move=false
                    -- stopped moving - check to see if we can defeat this baddie

                    -- printh("baddie needs "..tostring(ob.food.ingredients))

                    




                    

                    -- ob.ingredients
                    -- if ob.health>0 then
                    --     -- we lost
                    --     sfx(7,0)
                    --     game_over()
                    -- else
                    --     -- we won
                    --     sfx(8,0)
                    --     battle_can_move=true
                    -- end
                    
                end

                baddie_current=ob

                battle_check_ingredients()
            end

            
        end
    end
end

baddie_types={
    [1]={
        name="zombie",
        t=43,
        health=1,
        weakness={2}, --fire
        update=function()
        end
    }
}

function battle_add_item()
    local data=rnd(baddie_types)
    data = clone(data)
    data.x=128
    data.y=8
    data.food=clone(rnd(food_types))
    data.food.ingredients=clone(data.food.ingredients)
    add(baddies, data)
end

-- when you win some items, check to see if you can defeat the first baddie
-- function battle_check_defeat()
--     -- you need to trigger a 

-- end

function battle_draw()
    camera(0,-13*8)
    map(0,14,bx-128,0,16,3)
    map(0,14,bx,0,16-abs(bx/8)+1,3)
    local playerFrame=38
    if battle_can_move then
        playerFrame=frame<30 and 38 or 39
    end
    spr(playerFrame, 32, 8)
    for b in all(baddies) do
        spr(b.t, b.x, b.y)
        -- spr(13, b.x-1, -4,2,2)
        spr(b.food.t, b.x, -3)
    end
    camera()
end