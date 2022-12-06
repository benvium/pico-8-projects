function get_money_text(score)
     -- tell the user how they did
     local moneyText = ""
     if score<10 then
         moneyText = "a little bit of money"
     elseif score<20 then
         moneyText = "some money"
     elseif score<30 then
         moneyText = "money"
     elseif score<40 then
         moneyText = "a fair bit of money"
     elseif score<50 then
         moneyText = "a lot of money"
     elseif score<60 then
         moneyText = "a ton of money"
     elseif score<70 then
         moneyText = "a huge amount of money"
     elseif score<80 then
         moneyText = "a ridiculous amount of money"
     elseif score<90 then
         moneyText = "a ludicrous amount of money"
     elseif score<100 then
         moneyText = "a mind-boggling amount of money"
     elseif score<200 then
        moneyText = "a flabbergasting amount of ching-ching"
     elseif score<200 then
        moneyText = "nearly all the money in the world"
     end
     return moneyText
end

function end_init()
    mode="end"
    music(0)

    local high_score_coins=dget(0)

    local money=score[block_name["coin"]]
    local isHighScore=false
    if money>high_score_coins then
        isHighScore=true
        dset(0,money)
    end

    local isHighCount=false
    local high_customer_count=dget(1)
    if customer_count>high_customer_count then
        isHighCount=true
        dset(1,customer_count)
    end
 
    local scoreText=isHighScore and " a new high score!" or "the most money made so far is "..high_score_coins
    local customersText=isHighCount and "you served the most customers yet!" or "the most customers served so far is "..high_customer_count
    dtb_disp("you made "..get_money_text(money)..". "..scoreText..". ")

    dtb_disp(customersText..". have another go anyway!",
    function() _init() end)
end

function end_draw()
    cls(col.blue1)
    camera(0,0)
    clip()
    map(32,0,0,0,16,16)

    local timeY=9
    local timeX=51

    rectfill(32,timeY-3,127-32,timeY+8, col.blue1)
    rect(32,timeY-3,127-32,timeY+8, col.black)
    -- line(0,timeY-3,127,timeY-3, col.blue2)
    -- line(0,timeY+4,127,timeY+18, col.black)        
    print("time up!", timeX,timeY, col.white)
    spr(21, timeX-10, timeY-1, 1, 1)


    local bannerY=20
    -- rectfill(0,bannerY-3,127,bannerY+18, col.blue1)
    -- line(0,bannerY-3,127,bannerY-3, col.blue2)
    -- line(0,bannerY+18,127,bannerY+18, col.black)        

    local line1Y=bannerY
    local line1X=31
    spr(50, line1X-10, line1Y-2)
    print(customer_count, line1X-1, line1Y, col.black)
    print(customer_count, line1X+1, line1Y, col.black)
    print(customer_count.." customers served", line1X, line1Y, col.white)

    line1Y=bannerY+10
    line1X=31
    local money=score[block_name["coin"]]
    spr(54, line1X-10, line1Y-2)
    print(money, line1X-1, line1Y, col.black)
    print(money, line1X+1, line1Y, col.black)
    print(money.." earned", line1X, line1Y, col.white)

    dtb_draw()
end

function end_update()
    dtb_update()
    -- if btnp(4) then
    --     _init()
    -- end
end

