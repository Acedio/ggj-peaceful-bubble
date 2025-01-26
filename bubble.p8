pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- putting this before the includes so editor palette is changed for artists
-- (who may not have the .lua includes).
function altpal()
  pal()
  pal({[0]=130,14,7,137,9,136,2,141,132,5,129,12,1,131,13,6},1)
end

altpal()
poke(0x5f2e,1)

#include _init.lua
#include utils.lua
#include flow.lua
#include scene_transition.lua
#include bcirc.lua
#include vector2.lua
#include collision.lua
#include bullets.lua
#include items.lua
#include emitters.lua
#include player.lua
#include floating_bubble.lua
#include texteffects.lua
#include wrapping_bg.lua
#include death_animation.lua

-- scenes
#include scenes/title_scene.lua
#include scenes/intro.lua
#include scenes/level.lua
#include scenes/death_scene.lua
#include scenes/clear_scene.lua
#include scenes/credits_scene.lua
#include scenes/thanks_scene.lua

-- music
-- 0-6  : liftoff
-- 7-20 : zero-g

-- sfx
-- 0 : custom instrument
-- 1 : bubble grow
-- 2 : bubble shrink
-- 3 : bubble pop
-- 4 : explosion 1
-- 5 : explosion 2
-- 6 : alarm

__gfx__
0000000000222f000000022222200000005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00200200021000200002f100000f2000054444500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00022000212b00020021000000000200544444450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002200020b000020210000000000020544224450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00200200200000020f000100000000f0544224450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000f00000bf2100122200000002544444450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002000b202000022b00000002054444500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000f22200200002b000000002005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001000020000000000000b2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000012b0000f000000000000f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b00000200000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000002000000000b200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000002f00000bf2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000022222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000f0200000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000202000000000002000200f000002000000000000000000000000000000000000000000000000000000000000000000000000
00000200000000000000000000000000000000000f00000b00010000000000000000000000000000000000000000000000000000000000000000000000000000
000022200000f0220f0000000000f0002f00000000000000000000f2000000000000000000000000000000000000000000000000000000000000000000000000
00000200000012100b20000000000210002000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000012b0002000000000000000200000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000f020200000000000002020000000000000000bf00000000000000000000000000000000000000000000000000000000000000000000000000
000000000002200000020000000000000ff202000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000f00000bf00000200f00000bf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000022f0000000000200200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000f2b200000000000002b20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000f000000000000222f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000b00000000000000020000000000000000b000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000020020000000000f000e00000b0000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000002000000000f000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000ccc000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccfccc0cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccffccccfccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccccccceeeccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cceecccceeeeccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccceecccceefecc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccceefc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccccccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cccccc0ccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000fcc000ccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000066666666000000000000000006666660000000000008800000000000000000000000000000000000000000000000000000000000000000000000
00000000066666666666666000000000000666666666600000000085510000000000000000000000000000000000000000000000000000000000000000000000
00000006666666666666666660000000006666666666660000000085510000000000000000000000000000000000000000000000000000000000000000000000
00000066666666666666666666000000066666666666666000000885515000000000000000000000000000000000000000000000000000000000000000000000
00000666666666666666666666600000066666666666666000008885515500000000000000000000000000000000000000000000000000000000000000000000
00006666666666666666666666660000666666666666666600008885515100000000000000000000000000000000000000000000000000000000000000000000
0006666666666666666666666666600066666666666666660000888ef15100000000000000000000000000000000000000000000000000000000000000000000
006666666666666666666666666666006666666666666666000088ccbf5100000000000000000000000000000000000000000000000000000000000000000000
006666666666666600666600666666006666666666666666000088ccbf5100000000000000000000000000000000000000000000000000000000000000000000
066666666666666606666660666666606666666666666666000888ccbf5510000000000000000000000000000000000000000000000000000000000000000000
066666666666666666666666666666606666666666666666008888ccbf5551000000000000000000000000000000000000000000000000000000000000000000
06666666666666666666666666666660066666666666666008888555511555100000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666066666666666666088858888881555510000000000000000000000000000000000000000000000000000000000000000
666666666666666666666666666666660066666666666600888885555118888b0000000000000000000000000000000000000000000000000000000000000000
66666666666666660666666066666666000666666666600088558888888555110000000000000000000000000000000000000000000000000000000000000000
666666666666666600666600666666660000066666600000b5550cccecc05b1b0000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666666000000000000000066666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666666000000000000000066666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666666000000000000000066666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666666000000000000000066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666666666666666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00066666666666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006666666666666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000666666666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000066666666666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000006666666666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000066666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
000000000000000000000000d200000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d200000000c0c1c2c3000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c2c3c4c500000000d0d1d1d3d20000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d1d3d4d500000000e0d1d1e3000000000000000000000000000000000000000000000000100010000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0d1d1e3c4c5000000c0c1d1d1f3000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f0f1f2d2d4d500c4c5d0d1d1d300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000d200000000d4d5e0d1d1e300000000000000000000000000000000000000000000100000000000000000000000000010000000001000000010000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000d2f0f1f2f300000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c0c1c2c3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d0d1d1d30000000000c4c5d200000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d2c4c5e0d2d1e30000000000d4d50000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000d4d5f0f1f2f3000000000000000000000000000000000000000000000000000010000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000d2c4c5000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d4d5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000010000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000001000100000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000100000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000001000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
6d1000010c25000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200
0002000000050060500e050130501705018050170501505015040160401c0402004021030210301f0301f0302303027030290302903029020270202502025020270202a0202e0203001033010360103701037010
00020000300503705036050300502b0502a0502c0502b05028040230401e0401d0401e0301f0301d03019030190301b0301b030190301402013020130201302013020100200e0200b01008010040100201000010
040600001d6541d6151507021051210631d6231d60300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49040000316700c6702b670116702966017660256601d650206501e6501b65019640176301663014620116200f6200e6200b62009620076200662005620046200362003610016100161000610006100061000610
480300002d670126702d6701c6602e6602965024640206401e64018640156300f6300e6200e6200e6200e6200d6200c6200c6200b6100b6100b6100b6100a6100861008610076100861007610066100661003610
0510000c131701f1511f1501f1501f150131511314113135001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d1200000c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500c0500b0500b0500b0500b0500b0500b0500905009050
0d1200000705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050070500705007050
0d1200000905009050090500905009050090500905009050090500905009050090500905009050090500905009050090500905009050090500905009050090500705007050070500705007050070500c0500c050
0d1200000005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050
0d1200000905009050090500905009050090500905009050090500905009050090500905009050090500905009050090500905009050090500905009050090500705007050070500705007050070500505005050
0d1200000505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0112000005800058500c8501185015850188501d850248502985005850098500c8501185015850188501d85005800058500c8501185015850188501d850248502985005850098500c8501185015850188501d850
011200000c8000c85013850188501c8501f850248502b850308500c8501085013850188501c8501f850248500c8000c85013850188501c8501f850248502b850308500c8501085013850188501c8501f85024850
0112000007800078500e85013850178501a8501f850268502b850078500b8500e85013850178501a8501f85007800078500e85013850178501a8501f850268502b850078500b8500e85013850178501a8501f850
0112000009800098501085015850188501c85021850288502d85009850188501085015850188501c8502185009800098501085015850188501c85021850288502d85009850188501085015850188501c85021850
011200000c8000c85013850188501c8501f850248502b850308500c8501085013850188501c8501f850248500c8000c85013850188501c8501f850248502b850308500c8501085013850188501c8501f85024850
011200000c8000c85013850188501c8501f850248502b850308500c8501085013850188501c8501f850248500c8000c85013850188501c8501f850248502b850308500c8501085013850188501c8501f85024850
0112000009800098501085015850188501c85021850288502d85009850188501085015850188501c8502185009800098501085015850188501c85021850288502d85009850188501085015850188501c85021850
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2f0908100022000220002200021000210002100021000210002100021000210002100021000210002100021000200002000020000200002000020000200002000020000200002000020000200002000020000200
2f0900101121411210112151122011215112101122111200112141122011215112201121511210112210000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2f0908100222002220022200221002210022100221002210022100221002210022100221002210022100221002200022000220002200022000220002200022000220002200022000220002200022000220002200
2f0908100522005220052200521005210052100521005210052100521005210052100521005210052100521000200002000020000200002000020000200002000020000200002000020000200002000020000200
2f0908100922009220092200921009210092100921009210092100921009210092100921009210092100921009200092000920009200092000920009200092000920009200092000920009200092000920009200
2f1200000522005220052110521005210052100521005210052100521005210052100521005210052100521007220072200721107210072100721007210072100721007210072100721007210072100721007210
2f0908100722007220072200721007210072100721007210072100721007210072100721007210072100721002200022000220002200022000220002200022000220002200022000220002200022000220002200
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
051200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000026330
050900002630000000263202631526310263152632026315263202632526330263352632026325263202631526320263252632026325263202632524320243250000000000243202432524320243252632026320
050900002630000000263202631526310263152632026315263202632526330263352632026325263202631526320263252632026325283202832524320243250000000000243202432524320243252b3202b320
050900002630000000283202831528310283152632026315263202632526330263352632026325263202631526320263252632026325263202632524320243250000000000243202432524320243252632026320
050900002630000000263202631526310263152632026315263202632526330263352632026325283202832028320283202832028311283150000000000000002632026320263202632026320263112631500000
4d0900200c1430060000000000000000000000000001863018613000000000000000000000000000000186201861300000000000000000000000000000024623180030000000000180030c600180000000018620
4d0900200c13318003000000000000000000000000000000000000000000000000000c62500000000000000018625000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
201200003455034521345111800018000180001800000000325403252132511000000000000000000000000034550345213451100000000000000000000000002f5402f5212f5110000000000000000000000000
211200003455034521345111800018000180001800000000325403252132511000000000000000000000000034550345213451100000000000000000000000003954039521395110000037530375213751100000
2012000018000180002b5502b5112f5302f51130540305112f5502f5112b5302b5112853028511265302651118000180002b5502b5112f5302f51130540305112f5502f5112b5302b51128530285112653026511
211200003452034520345203452035530355203552035520355203552035520355203552035520355203552035520355203552035520355203552035520355202d5202d5202d5202d52030520305203052030520
211200003452034520345203452032530325203252032520325203252032520325203252032520325203252032520325203252032520325203252032520325203052030520305203052030520305203052030520
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 08114a53
00 0a134a53
00 08144a53
00 0c164a53
00 0d104a53
00 09124a53
02 0b154a53
01 2a261858
00 28251968
00 2a261858
00 29251968
00 2b1a265e
00 2c1d2620
00 21186153
00 221c4a53
00 231b4a53
00 241e4a53
00 21186153
00 221c4a53
00 231b4a53
02 241e4a53
00 41464445
00 46464445
00 44464445
00 45464445
00 43464445
00 42464445
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
00 48514a53
