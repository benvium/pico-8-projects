pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
#include animal/particle.lua
#include newrace_src/utils.lua
#include puzzle/board.lua
#include puzzle/main.lua
__gfx__
0000000005c666500044441b0555555b01100110000770000011dd11050505050000000000000000000000000000000000000000000000000000000000000000
000000005c7cc765049aa7b155bbbbbb1e711e71000aa000011dd110505050500000000000000000000000000000000000000000000000000000000000000000
00700700c7c77c76499999745bbbabb12eeeeee70099990011dd1100050505050000000000000000000000000000000000000000000000000000000000000000
000770005c7ccc65499999a4bba3bba12eeeeee7028888201dd11001505050500000000000000000000000000000000000000000000000000000000000000000
0007700051c7cc6549999994bb3bbb1512eeee7128888882dd110011050505050000000000000000000000000000000000000000000000000000000000000000
0070070055c7cc554999999453bbba15012ee71028888882d110011d505050500000000000000000000000000000000000000000000000000000000000000000
000000005517c655549999453bbba1550012710002888820110011dd050505050000000000000000000000000000000000000000000000000000000000000000
00000000055165500544445031111550000110000022220010011dd1505050500000000000000000000000000000000000000000000000000000000000000000
00000000544444450040040000000000000000000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000495555940111011000000000000000000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000459444941ddf15d100000000000000000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
000000004549449411dd151100000000000000000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000454494941111151000000000000000000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
0000000045444a940111555000000000000000000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000499999a400551d1000000000000000000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000544444450001110000000000000000000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000444544440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009444449a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000994449990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009a949a9f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000994449990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009444449a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0606060606060606060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621212121212121212121212106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621101010101010100010102106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621000000000000000000002106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621100000000000000000002106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621100000000000000000002106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621100000000000000000002106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621100000000000000000002106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621100000000000000000002106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621100000000000000000002106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621100000000000000000002106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621000000000000000000002106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621212121212121212121212106060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000d05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000003105500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b00002f150291502f1102911000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000181571c1571f15722157181171c1171f10022100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b0000185571d557215552855526555245550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00000f65500000236550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001a35016330123200f3100f310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
