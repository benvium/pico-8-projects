pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
#include ../newrace_src/utils.lua
#include ../wall_src/collide.lua
#include particle.lua
#include apple.lua
#include player.lua
#include main.lua
__gfx__
000000003bbb33333303303000000003000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333330000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000333333330000000000000003000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770003333bbb30000000000000003000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333330000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333330000000000000003330330033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1016610100222b330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
71666617022883200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17666671128888820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01766710228888820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01777710228888820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01666610122888220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
16666661012222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66111166001221000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a00a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a00a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001000000000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
090700000b0600b060180601906019010190100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
190800003e0303c0303b0303a030370303403031030300302d0302a0302603024030210301e0301c0301a03017030160301303012030100300f0300c0300a0300803007030050300403001030000300000000000
031000000c63500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000