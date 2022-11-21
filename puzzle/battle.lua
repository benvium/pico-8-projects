baddie_types={
    [1]={
        t=43,
        mode="hungry",
        update=function()
        end
    },
    [2]={
        t=38,
        mode="hungry",
        update=function()
        end
    },
    [3]={
        t=57,
        mode="hungry",
        update=function()
        end
    },
}


function baddie_update()
end

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
        end
    end

    if #ob.food.ingredients>0 then
        printh("baddie needs "..tostring(ob.food.ingredients))
        return false
    else
        printh("baddie defeated")
        del(baddies,ob)
        baddie_current=nil
        smoke_add(ob.x+4,ob.y+4,-0.25,col.white)
        sfx(2,0)
        battle_can_move=true
        return true
    end
end

function battle_update()
    frame=(frame+1)%60
    if battle_can_move then
        bx=(bx-0.25)%128
        item_interval-=1
        if item_interval==0 then
            item_interval=BADDIE_INTERVAL
            battle_add_person()
        end
        for ob in all(baddies) do
            ob.x-=0.25
            ob:update()
            if ob.x<-10 then
                del(baddies,ob)
            end

            local have_stopped=false

            if ob.x>10 and ob.x<48 then
                if battle_can_move then
                    battle_can_move=false

                    have_stopped=true
                end

                baddie_current=ob

                local defeated = battle_check_ingredients()
                if have_stopped and not defeated then
                    sfx(15,1)
                end
            end
        end
    end
end

function battle_add_person()
    local data=rnd(baddie_types)
    data = clone(data)
    data.x=128
    data.y=8
    data.food=clone(rnd(food_types))
    data.food.ingredients=clone(data.food.ingredients)
    add(baddies, data)
end

function battle_draw()
    local bY=13*8+4
    camera(0,-bY)
    map(0,14,bx-128,0,16,3)
    map(0,14,bx,0,16-abs(bx/8)+1,3)

    -- van smokes when out
    if flr(frame/10)==0 and battle_can_move then
        smoke_add(8,100,-0.25,col.white)
    end

    spr(44, 24, 0, 2,2)

    for b in all(baddies) do
        spr(b.t, b.x, b.y)
        spr(b.food.t, b.x, -3)
    end
    camera()
end