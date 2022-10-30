pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
#include newrace_src/collision.lua
#include newrace_src/utils.lua
#include newrace_src/particles.lua
#include newrace_src/pickups.lua
#include newrace_src/car.lua
#include newrace_src/hud.lua
#include newrace_src/main.lua
#include newrace_src/roadside.lua
#include newrace_src/track.lua
__gfx__
00000000000d70000000670000000000000000bb00000b3b0000000044444444444444444999999f77777777cccccccc77cc7cc7777777770000000000000000
0000000000d1c7000006700000000000000000bbb0000330000000004444444444444444444444497dddd777cccccccc777777c7777777770000000000000000
007007000d11cc70002228000000000000000000bb003300000000004466666666666666666666497deed777cccccccc77777777777777770000000000000000
00077000d11c7cc702288e80000000000bbbbbb3b3bb300bb00000004466966699966999669966497dddd777cccccccc77777777777777770000000000000000
000770005dd6c11102288f8000000000b33333333b3b3b7bbbb000004478877787877878788787447d99d777cccccccc77777777777777770000000000000000
0070070005dd111002288f8000000000b3033b0bb3b3bb0b00b000004478887888878887788787447dddd777cccccccc77777777777777770000000000000000
00000000005d110002288e8000000000b033007b3337b333330000004472227227272272722277447daad777cccccccc77777777777777770000000000000000
0000000000051000022888800000000000300bb33333bb37000000004477777777777777777777447dddd777cccccccc77777777777777770000000000000000
000000000000000000000000000000000b300b30499933bb000000004444444444444444444444447daad7777777765177777777000000000000000000000000
0000000005d6666666666d5000000000b330b334446a033b000000004444444444444444444444447dddd55777777551777777770000000004aaa40000000000
000000005d6dddddddddd6d500000000b300b30044a00033000000000011100000000000000111007d77d5577777765177777777000000004a4ffa0000000000
000066055dddddddddddddd550660000b300b3044f400003300000000041100000000000000411007dddd557777775517777777700000000a9f7f7f000000000
00006665d5d5555555555d5d56660000b300b3004490000b300000000044100000000000000441007d77d557755556557777777700000000a9f1f1f000000000
00000055dd111111111111dd55000000b000b0004f900000b30000000044400000000000000444007dddd5567555555577767777000000009a1f8f0000000000
0000005dd55555555555555dd5000000b000b00044900000030000000044400000000000000444006d77d5566565565577666777000000000041100f00000000
00000d5d1111111111111111d5d0000000000b004f900000bb0000000144411111111111111444006dddd556656555556666666600000000055555f000000000
000005d555555555555555555d50000000000000449000000000000008888880000000000044440077777777ccccccc677cccccc00000000ff15500000000000
000005dddddddddddddddddddd500000000000004f900000000000008866668804aaa400004ff44077ddddd7ccccccc6777ccccc00000000f115500000000000
00000d66666666666666666666d00000000000004490000000000000815651284a4ffa000f7f7f947e1111d7ccccc66777777ccc00000000ff56550500000000
00000d9181711dddddd1171819d00000000000004f9000000000000087171718a9f7f7f00f1f1f4076ddddd7ccc6667777777ccc000000000056555507650000
0000d5111111177777711111115d000000000000449000000000000081571718a9f1f1f000fff000761111d7ccc6776777777ccc000000000005500776500000
0000d1918171177777711718191d0000000000004f90000000000000881717189a1fff00004224007eddddd7cc6777777777777c00000000c001507765000000
0000d6666666666666666666666d0000000000004990000000000000815751280042240f00f68f0066d11dd6cc77777777777777000000000c05077650000000
0000777777777777777777777777000000000004f900000000000000088888800ff88fff0f166df066d11dd6677777777777777770000000c066666000000000
0000555551515555555515155555000000000004490000000000000000011000ff1280000f626d1f000000000000000000001111000000000000111100000000
0000155555555555555555555555000000000004f90000000000000000051000f11820000f6266ff00000000000000000001ccc7000011110001ccc700001111
0000155551111111111111155551000000000044490000000000000000055000ff82880000666d0000000000000000070017ccc10001ccc70017ccc10001ccc7
0000011111111111111111111110000000000044f90000000000000000055000008288000011110099aa7cc11117ccc1117cccc10017ccc1117cccc10017ccc1
000000000000000000000000000000000000004444000000000000000005500000888200001011009aaacc7cccccccc1dccccc7c117cccc1dccccc7c117cccc1
000000000000000000000000000000000000044f9000000000000000000550000011550000101100aaaaadccdccccc7cccccddccdccccc7cccccddccdccccc7c
00000000000000000000000000000000000044449000000000000000000550000005050006606600aaaaaa7cccccddccccccccccccccddccccccccccccccddcc
000000000000000000000000000000000000444490000000000000000005400000ff0ff00dd0dd0099a9aaa7ccccccccdcccccccccccccccdccccccccccccccc
00000000000000000000000000000000000000000000000000000000000000000000000008222222222222800000000000000000000000000000000000000000
00000000022888888888822000000000000000000000000000000000000000000000000022288888888882220000000000000000053bbbbbbbbbb33000000000
000000008287c7cccc7c78280000000000000000000000000000000000000000000000028287c7cccc7c78220000000000000000b3b3333333333b7b00000000
0008880824999c7cc7c44f4280888000000000000228888888888220000000000000000824cccc7cc7555542800000000000bb0bb333333333333b7bb0bb0000
000888822a99a9cccc9944f228888000000000008287c7cccc7c782800000000000888022499911115144f52208880000000bbbbbb3bbbbbbbbbbbbb3bbb0000
00000022eaa9a9e11ee444ee220000000008880824999c7cc7c44f4280888000000888822a99a9111e9944f228888000000000bbb3bccccc7ccccb3b33000000
000000221e99ae1111eeeee122000000000888822a99a9cccc9944f22888800000000022eaa9a9e11ee444ee82000000000000bb3bccccc7cccccc3363000000
0000022118888888888aa77112200000000000221e99ae1111eeeee122000000000002211e99ae1111eeeee11820000000000dbb3ccccc7cccccc7c363300000
00000221822222222228888712200000000002218888888888888897122000000000028118888888888aa7711880000000000b3b3cccc7cccccc7cc363300000
0000282298888888888888a72282000000002822922222222222222722820000000008228222222222888887228000000000bb3333337cccccc33333336d0000
0000828282222222222222282828000000008282822222222222222828280000000002828222222282282887288000000000bdbbbbbb3333333bbbbbbbdb0000
00008822222222222222222222880000000088888888888888888888888800000000282298888888888888a7228800000000bb9999bbbbbbbbbbbb9999bb0000
0000888888888888888888888888000000009aa788887676676788887aa90000000082828222222222222228282800000000bb9aa7bbbbbbbbbbbb7aa9bb0000
00009aa788887676676788887aa9000000009999888877777777888899990000000088222222222222222222228800000000bb8888bbb777777bbb8888bb0000
0000999988887777777788889999000000008888888888888888888888880000000088888888888888888888999900000000bbbbbbbbb777777bbbbbbbbb0000
000088888888888888888888888800000000888888888888888888888888000000009aa788887676676788887aa90000000033333bbbbbbbbbbbbbb333330000
00001128282822822822828282110000000011282828228228228282821100000000999988887777777788889999000000001133333333333333333333110000
00001511111111111111111111510000000015111111111111111111115100000000888888888888888888888888000000001511133333333333331111510000
00001555511111111111111555510000000015555111111111111115555100000000112828282282282282828211000000001555511111111111111555510000
00000111111111111111111111100000000015555111111111111115555100000000151111111111111111111151000000000111111111111111111111100000
00000000000000000000000000000000000001111100000000000001111000000000155551111111111111155551000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000011111111111111111111110000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000500600000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07707755665500000077005566550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07777777765000000777755776500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d77ddd776600000d77d777d66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dd00dd60000000ddd0d7dd06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d00000000000000000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbaaa000000000000000000
0000000005d6666666666d5000000000000000000022888888888822000000000000000000000022888888222222000000000000bbaaaabbbb00ab0000000000
000000005d6dddddddddd6d5000000000000000008287c7cccc7c7828000000000000000000008287c7ccc8888828000000000aabbbbbbbbb33baab000000000
0000166666666666666666666661000000008880824999c7cc74f44c28088800000000888824999c7ccccccccc88880000000babb3bbbbbb33bbbaa000000000
000077777777777777777777777700000000888822a99a9ccccf44992288880000000088822a99a9ccc7c44f42282200000aabbbb3bb99bb33bbbba000000000
00007055576655111155667555070000000000022eaa9a9e11ee444ee22000000000000022eaa9a9e11c9944f222888000aababbb3bb99bb3bbbbbb33bb00000
000000ddd76655555555667ddd0000000000002221e99ae1111eeeee1220000000000000221e99ae111ee444ee2288800aabbbbbb33bbbbb33bbbb33bbaab000
00000551d766d666666d667d15500000000002228888888888aa77121220000000000021188888888811eeeee12890000bbbbb555b33bbbbb3bbbb3bbbbbab00
00000611676d6dddddd6d6761160000000002228222222222288887212200000000002218222222222888aa7122891000a333344555bb55bb3bbb33bbbbbab00
0000566777d6666666666d7776650000000282298888888888888a72282000000000822298888888888888a7228881000aabbbb33455555bb33333b3bbbbab00
00006775277777777777777257760000000828282222222222222282828000000008282822222222288888828288100000aaaabbb334445553334443399bab00
0007752222711dddddd11722225770000008822222222222222222222880000008888888888888222222222288881000000aabbbbb3334555334455b399aa000
007a988282711777777117282889a700000888888888888888888888888000000888888888888888888888888888100000abbb4444bb3355455445bb3bbab000
007998866271177777711726688997000009aa788887676676788887aa90000009aa788887676666688888888881000000a3333aaa444444444455bbbbbbbbb0
00577222276666666666667222277500000999988887777777788889999000000999988887777777788887aa988100000033baaabaabbb554bbbbbbb33333bb0
00657777765d6d5dd5d6d56777775600000888888888888888888888888000000888888888888888888889999811000000bbbabbbb9abb554bbb3bb33ab33bb0
0056555555d116d55d611d5555556500000112828282282282282828211000000112828282282282282888888110000003babbbbbb99ab5b53aaabbabbbbbbb0
00156666665dd555555dd566666651000001511111111111111111111510000000151111111111112222222081100000b3bbbabbbbbbbbbb33bbaabbbbbba3b0
000155555111111111111115555510000001555511111111111111555510000000155551111111111111111151000000b3bbabb3bb3bbbbbbbbbbaabbbb33330
000011111111111111111111111100000000111111111111111111111100000000011111111111111111155550000000b3bbbb4444454bbb5bbbbaa333333333
000000000000000000000000000000000000000000000000000000000000000000000000000001111111111110000000b3b4444444455545b3bbbaa333553331
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003bbbbab33bbb4555bbbbbaabb3353333
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033b3bbb3333b333333b3bb4444353310
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000053bb33bb33333333333bb99bb4331100
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005333333bb3335553333bb99b00000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005333333533353553330000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000553355550000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005511100000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009555100000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099455500000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000994444555000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004944444445000000000000
0677777777877776d551515d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07666666668866676dddddd600000000000000002288888888882200000000000000222222888888220000000000000000000000000000000000000000000000
0767779888888767d515555d0000000000000008287c7cccc7c78280000000000008288888ccc7c7828000000000000000000000000000000000000000000000
0767788888888867d555555d00000000008880824999c7cc7c44f42808880000008888ccccccccc7c44f42888800000000000000000000000000000000000000
0767988888888667d555515d0000000000888822a99a9cccc9944f22888800000022822c99947ccc9944f2288800000000000000000000000000000000000000
07698886668867676dddddd6000000000000022eaa9a9e11ee444ee22000000008882229a99ac11ee444ee220000000000000000000000000000000000000000
0768886777867767d515555d0000000000000221e99ae1111eeeee1222000000088822e9a9aae111eeeee1220000000000000000000000000000000000000000
0768886777677767d555155d0000000000000221228888888888aa77122000000009821ea99e1188888889977200000000000000000000000000000000000000
0766666666666667d551515d00000000000002212822222222228888722200000019822188888822228888aaa220000000000000000000000000000000000000
05555555555555506dddddd60000000000000282298888888888888a722820000018882282222222888888892282000000000000000000000000000000000000
0651000000000000d515555d00000000000008282822222222222222828280000001882828888888222222228282800000000000000000000000000000000000
0c65000000000000d555555d00000000000008822222222222222222222880000001888822222222228888888888888000000000000000000000000000000000
0c66000000000000d555515d00000000000008888888888888888888888880000001888888888888888888888888888000000000000000000000000000000000
0c670000000000006dddddd600000000000009aa788887676676788887aa90000000188888888887676666688887aa9000000000000000000000000000000000
0c67000000000000d515555d000000000000099998888777777778888999900000001889aa788887777777788889999000000000000000000000000000000000
0c67000000000000d555155d00000000000008888888888888888888888880000000118999988888888888888888888000000000000000000000000000000000
0000000000000000d551515d00000000000001128282822822822828282110000000011888888282282282282828211000000000000000000000000000000000
00000055000000006dddddd600000000000001511111111111111111111510000000011802222222111111111111510000000000000000000000000000000000
0055555550000000d515555d00000000000001555511111111111111555510000000001511111111111111111555510000000000000000000000000000000000
5555555544000000d555555d00000000000000111111111111111111111100000000000555511111111111111111100000000000000000000000000000000000
d5555aa14f500000d555515d00000000000000000000000000000000000000000000000111111111111000000000000000000000000000000000000000000000
6d511af1dd9900006dddddd600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66d11a644dff0000d515555d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
656d566441bb0ff0d555155d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6dd6d14881b44ff0d551515d51111111111111115111111111111111111111111111111511111111111111150000000000000000000000000000000000000000
6ddd6d588aa44cc16dddddd615511111111111111511111111111111111111111111115111111111111115510000000000000000000000000000000000000000
666666d51ff22111d515555d11155111111111111151111111111111111111111111151111111111111551110000000000000000000000000000000000000000
6555556d5cc22155d555555d11111551111111111115111111111111111111111111511111111111155111110000000000000000000000000000000000000000
6dddddd6d51155ddd555515d11111115511111111111511111111111111111111115111111111115511111110000000000000000000000000000000000000000
666666666d55dd116dddddd611111111155111111111151111111111111111111151111111111551111111110000000000000000000000000000000000000000
5555555555dd1100d515555d11111111111551111999115111111111111111111511999111155111111111110000000000000000000000000000000000000000
1111111111110000d555155d111111111111155119aa111511111111111111115111aa9115511111111111110000000000000000000000000000000000000000
__map__
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b0b0b0b0b0b0b0b0b0b2b0c2c0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0b2b0d2c0b2b2c0b0b2b0d0d0d0c2c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2b0a0d0d0d0a0d0d0c0c0d0d0d0a0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1c1a1b1b1c1a1c2a1c0d1c2a1c1a1c1c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
3a0100082851000000275100000027510000002651000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000800080101000000010100000001010000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6603000013051100500b0500504000040000300001000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c20400000955009550095500955009550075500554002520005100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3602000028530285202852028550285502f1402f1402f1302f1302f1202f1102f1102f1102f110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3606000024130241201f1201f1501f15024140241403013030130301203c1103c1103c1103c110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7810001535620346203362031620306202f6202e6202d6202c6102a61029610276102661026610276102761028610296202a6202c6202e6100000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a1300040002000010000200001002020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a1000050205002040020500204002050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a1000050305003040030500304003050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a1000050405004040040500404004050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a1000050405004040040500404004050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a1000050505005040050500504005050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
