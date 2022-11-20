pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
#include animal/particle.lua
#include newrace_src/utils.lua
#include puzzle/board.lua
#include puzzle/main.lua
__gfx__
00000000000dc000080008000555555b0110011000dddddcdddd6ddd050505050000000000000000000000000000000000000000000000000000000000000000
00000000000cd0000880088055bbbbbb1ef11ef10ddddd7dddddd6dd505050500000000000000000000000000000000000000000000000000000000000000000
0070070000dccd0008a808a85bbbabb12eeeeeefccc77cdcdddddd6d050505050000000000000000000000000000000000000000000000000000000000000000
0007700000cccc0088558558bba3bba12eeeeeefccccc7cdddddd6d6505050500000000000000000000000000000000000000000000000000000000000000000
000770000dcc7cd088670708bb3bbb1512eeeef1ccccc7dc6ddd6ddd050505050000000000000000000000000000000000000000000000000000000000000000
007007000cccc7c02867677253bbba15012eef107cccc7cdd6d6dddd505050500000000000000000000000000000000000000000000000000000000000000000
000000000dccccd0028888203bbba1550012f1007cccc7d0dd6ddddd050505050000000000000000000000000000000000000000000000000000000000000000
0000000000dccd0000288200311115500001100077cccc00ddd6dddd505050500000000000000000000000000000000000000000000000000000000000000000
0000000054444445004004000d9266d0000000060000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
000000004955559401110110d622dd7d006666660000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000459444941ddf15d1dd22d6d6066676610000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
000000004549449411dd1511dd22dddd667566710000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
0000000045449494111115101d22ddd1665666100000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
0000000045444a940111555001941110656667100000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000499999a400551d1000440000566671000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000544444450001110000940000511110000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111dd1110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111551110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
010b000031055000003d055000003d015000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
910b00001f350243501f3102431000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000181571c1571f12724115181001c1001f10022100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b0000185571d557215552151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00000f65500000236550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001a35016330123200f3100f310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
