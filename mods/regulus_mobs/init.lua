--todo

dofile(minetest.get_modpath("regulus_mobs").."/guide.lua")
dofile(minetest.get_modpath("regulus_mobs").."/enemy1.lua")
dofile(minetest.get_modpath("regulus_mobs").."/boss.lua")

minetest.register_node("regulus_mobs:spawn_guide1",{
    description="spawn guide1",
    tiles={"regulus_stone1.png"},
    after_place_node=function(pos,placer)
        minetest.add_entity(pos+vector.new(0,1,0),"regulus_mobs:guide")
    end,
    groups={undiggable=1},
})