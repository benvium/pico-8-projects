pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
#include physics-demo/math2d.p8
#include physics-demo/physics.p8
#include physics-demo/broadphase.p8
#include physics-demo/geometry.p8
#include physics-demo/constraints.p8

#include phy/main.lua
__gfx__
00000000cccccccc0067550000000666555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc0677555000066666555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700cccccccc6777555500666666555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000cccccccc7777555506666666555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000ccccccccdddd666606666666555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700cccccccc5ddd666d66666666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc05dd66d066666666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc005d6d0066666666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000dddddddd777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000dddddddd777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000dddddddd777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000ddddddd777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000ddddddd777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000dddddd777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000ddddd777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000ddd777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000