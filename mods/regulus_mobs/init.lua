--todo

dofile(minetest.get_modpath("regulus_mobs").."/guide.lua")
dofile(minetest.get_modpath("regulus_mobs").."/enemy1.lua")
dofile(minetest.get_modpath("regulus_mobs").."/boss.lua")

minetest.register_node("regulus_mobs:spawn_guide1",{
    description="spawn guide1",
    tiles={"regulus_stone1.png"},
    groups={undiggable=1},
    after_place_node=function(pos,placer,itemstack,pointed_thing)
        placer:get_meta():set_string("spawn_guide1",minetest.serialize(pos))
    end
})


minetest.register_node("regulus_mobs:spawn_guide2",{
    description="spawn guide2",
    tiles={"regulus_stone1.png"},
    groups={undiggable=1},
})


minetest.register_lbm({
    label="spawn guide",
    name="regulus_mobs:spawn_guide",
    nodenames={"regulus_mobs:spawn_guide1"},
    --run_at_every_load=true,
    action=function(pos,node,dtime_s)
        minetest.chat_send_all("help me spawn mob")
        minetest.after(0.1,function()
            minetest.add_entity(pos+vector.new(0,1,0),"regulus_mobs:guide")
        end)
    end
})


minetest.register_lbm({
    label="spawn guide2",
    name="regulus_mobs:spawn_guide2",
    nodenames={"regulus_mobs:spawn_guide2"},
    --run_at_every_load=true,
    action=function(pos,node,dtime_s)
        minetest.chat_send_all("help me spawn mob2")
        minetest.after(0.1,function()
            minetest.add_entity(pos+vector.new(0,1,0),"regulus_mobs:guide2")
        end)
    end
})