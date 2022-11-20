pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
#include animal/particle.lua
#include newrace_src/utils.lua
#include puzzle/board.lua
#include puzzle/main.lua
__gfx__
00000000000d7000080008000000000b0110011000dddddc5555d555050505053333b3bb11111111111111110000000000000000000000000000000000000000
00000000000c70000880088000bbbbbb1ef11ef10ddddd7d55555d5550505050b3bb3b3311111111115151110000000000000000000000000000000000000000
0070070000dc7d0008a808a80bbbabb12eeeeeefccc77cdc555555d5050505053333333311111111151515110000000000000000000000000000000000000000
0007700000cc7c0088558558bba3bba12eeeeeefccccc7cd55555d5d505050503123312311111111115151110000000000000000000000000000000000000000
000770000dc777d088670708bb3bbb1012eeeef1ccccc7dcd555d555050505052242222211111111151515110000000000000000000000000000000000000000
007007000ccc7cc028676772b3bbba10012eef107cccc7cd5d5d5555505050504424424411111111115151110000000000000000000000000000000000000000
000000000dccccd0028888203bbba1000012f1007cccc7d055d55555050505054244444211111111111511110000000000000000000000000000000000000000
0000000000dccd0000288200311110000001100077cccc00555d5555505050504444424411111111115151110000000000000000000000000000000000000000
0000000054444445004004000d9266d0000000060000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
000000004955559401110110d622dd7d006666660000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000459444941ddf15d1dd22d6d6066676610000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
000000004549449411dd1511dd22dddd667566710000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
0000000045449494111115101d22ddd1665666100000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
0000000045444a940111555001941110656667100000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000499999a400551d1000440000566671000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000544444450001110000940000511110000000000055555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000dddddddd000000000000000000000000000000000000000000004400003b3b000000000000055500000b220000000000000000000000000000000000
00000000dddddddd00000000000000000000000000000000000000000004f7000333b3b008008080000225000008b22000000000000000000000000000000000
00000000dddddddd00000000000000000000000000000000000000000004ff0033333bb3080088800005550000bbbb2000000000000000000000000000000000
00000000ddd66ddd0000000000000000000000000000000000000000000d5dd0533333bb0880890000052200000b302000000000000000000000000000000000
00000000ddd55ddd0000000000000000000000000000000000000000000d5d000533333000989800000555000bb3300000000000000000000000000000000000
00000000dddddddd00000000000000000000000000000000000000000000dd0000533b0000899000000225000002300000000000000000000000000000000000
00000000dddddddd00000000000000000000000000000000000000000000550000049000008aa800000555000003300000000000000000000000000000000000
00000000dddddddd00000000000000000000000000000000000000000000880000044000000c9000000522000088800000000000000000000000000000000000
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
0909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090a090a090a09090909090a0909090a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000d05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b000031055000003d055000003d015000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
910b00001f350243501f3102431000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000181571c1571f12724115181001c1001f10022100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b0000185571d557215552151500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00000f65500000236550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001a35016330123200f3100f310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
