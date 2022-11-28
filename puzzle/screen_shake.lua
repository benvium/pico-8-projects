-- http://gamedev.docrobs.co.uk/screen-shake-in-pico-8#
-- set screen_shake_size to e.g. 0.5 to start a shake
-- call in _draw()
function screen_shake(camX,camY)
    if camX==nil then camX=0 end
    if camY==nil then camY=0 end
    local fade = 0.95
    local offset_x=16-rnd(32)
    local offset_y=16-rnd(32)
    offset_x*=screen_shake_size
    offset_y*=screen_shake_size
    
    camera(offset_x+camX,offset_y+camY)
    screen_shake_size*=fade
    if screen_shake_size<0.05 then
        screen_shake_size=0
    end
end