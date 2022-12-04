-- src: https://www.lexaloffle.com/bbs/?tid=29612
function bprint(str,x,y,c,scale)
    _str_to_sprite_sheet(str)
   
    local w = #str*4
    local h = 5
    pal(7,c)
    palt(0,true)
   
    sspr(0,0,w,h,x,y,w*scale,h*scale)
    pal()
       
    _restore_sprites_from_usermem()
end

function obprint(str,x,y,c,co,scale)
    _str_to_sprite_sheet(str)
   
    local w = #str*4
    local h = 5
    palt(0,true)
   
    pal(7,co)
    for xx=-1,1,1 do
        for yy=-1,1,1 do
            sspr(0,0,w,h,x+xx,y+yy,w*scale,h*scale)
        end
    end
   
    pal(7,c)
    sspr(0,0,w,h,x,y,w*scale,h*scale)
   
    pal()
   
    _restore_sprites_from_usermem()
end

function _str_to_sprite_sheet(str)
    _copy_sprites_to_usermem()
   
    _black_out_sprite_row()
    set_sprite_target()
    print(str,0,0,7)
    set_screen_target()
end

function set_sprite_target()
    poke(0x5f55,0x00)
end

function set_screen_target()
    poke(0x5f55,0x60)
end

function _copy_sprites_to_usermem()
    memcpy(0x4300,0x0,0x0200)
end

function _black_out_sprite_row()
    memset(0x0,0,0x0200)
end

function _restore_sprites_from_usermem()
    memcpy(0x0,0x4300,0x0200)
end

-- function _draw()
--     cls(2)
--     bprint("big print!",2,2,7,2)
--     obprint("outlined!",2,20,7,0,3)
--     brag = [[
-- big print is using the first
-- row of sprites as a buffer.
-- they are first copied to user
-- memory (0x4300). they get put
-- back at the end of the function.
-- you can still call those sprites
-- just fine!
-- ]]
--     print(brag,0,50,6)
--     spr(0,0,100,16,1)
-- end