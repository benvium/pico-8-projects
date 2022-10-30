pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
#include newrace_src/utils.lua
#include pin_src/main.lua
__gfx__
00000000222222222888222222228882222222222222222228222222222222822000000000000002000000000000000000000000000000000000000000000000
00000000222222288222111111112228822222222222222212822222222228218200000000000028555555550000000000000000000000000000000000000000
00700700222222822111111111111112282222222222222211282222222282112820000000000282000000000000000000000000000000000000000000000000
00077000222228211111000000001111128222222222222201128222222821102282000000002822555555550000000000000000000000000000000000000000
00077000222282111000000000000001112822222222222200112822228211002228200000028222000000000000000000000000000000000000000000000000
00700700222821100000000000000000011282222222222200011282282110002222820000282222555555550000000000000000000000000000000000000000
00000000228211000000000000000000001128228888888800001128821100002222282002822222000000000000000000000000000000000000000000000000
00000000282110000000000000000000000112822222222200000112211000002222228228222222555555550000000000000000000000000000000000000000
0000000028210000cccccccccccccccc000012821111111128222222222222822000000000000002000000000000002200000000000000000000000000000000
0000000082100000cccccccccccccccc000001281111111128222222222222822000000000000002000000000000228855505550555055500000000000000000
0000000082100000cccccccccccccccc000001280000000012822222222228218200000000000028000000000022882258505850585078500000000000000000
0000000082000000cccccccccccccccc000000280000000012822222222228218200000000000028000000002288222277707750755055500000000000000000
0000000021000000cccccccccccccccc000000120000000001282222222282102820000000000282000000228822222200000000000000000000000000000000
0000000021000000cccccccccccccccc000000120000000001282222222282102820000000000282000022882222222200000000000000000000000000000000
0000000020000000cccccccccccccccc000000020000000000128222222821002282000000002822002288222222222275505550000000000000000000000000
0000000020000000cccccccccccccccc000000020000000000128222222821002282000000002822228822222222222258505850080008000000000000000000
00000000222222222222222222222222222222220022220000012822228210002228200000002822220000000000000055505550000000000000000000000000
00000000222222222222222222222222888888880288882000012822228210002228200000002822882200000000000000000000000000000000000000000000
00000000222222222222222222222222222222222822228200001282282100002222820000028222228822000000000000000000000000000000000000000000
00000000222222222222222222222222222222222222222200001282282100002222820000028222222288220000000000000000000000000000000000000000
00000000222222222222222222222222222222222222222200000128821000002222282000282222222222882200000000000000000000000000000000000000
00000000222222222222222222222222222222222222222200000128821000002222282000282222222222228822000000000000000000000000000000000000
00000000222222228222222222222228222222222222222200000012210000002222228202822222222222222288220000000000000000000000000000000000
00000000222222222822222222222282222222222222222200000012210000002222228202822222222222222222882200000000000000000000000000000000
__gff__
0010101010101010161200000000000000101010101010101e1113130000000000101010141010101e111515000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
212121212121210505050505052121210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
210000000000001515151515150304210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
210000000000000000000000000014210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
210000000000000000000000000000210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
210000000000000000000000000000210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
211800000000000000000000002500210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
212800000000000000000000002100210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
212118000000000000000000192100210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
212128000000000000000000292100210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
212121080000000000000019212100210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
212121210800000000000029212100210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21212121212a2b0000000021212100210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
212121212121212a2b000021212121210a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
212121212121212121242424240000000a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
