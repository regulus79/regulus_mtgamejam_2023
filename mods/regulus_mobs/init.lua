local mod_storage=minetest.get_mod_storage()

dofile(minetest.get_modpath("regulus_mobs").."/guide.lua")
dofile(minetest.get_modpath("regulus_mobs").."/enemy1.lua")
dofile(minetest.get_modpath("regulus_mobs").."/boss.lua")

for _,spawner in pairs({
    {name="guide_room1",texture="regulus_stone5.png",newnode="regulus_nodes:stone5",yaw=-math.pi/2,spawn_every_time=true},
    --{name="random_npc_room1",texture="regulus_stone1.png",newnode="regulus_nodes:stone1"},
    {name="guide_library",texture="regulus_stone1.png",newnode="regulus_nodes:stone1"},
    {name="guide_room5",texture="regulus_v_panel.png",newnode="regulus_nodes:v_panel"},
    {name="guide_bossfight",texture="regulus_hex_panel1.png",newnode="regulus_nodes:hex_panel1"},
}) do
    minetest.register_node("regulus_mobs:spawn_"..spawner.name,{
        description="spawn "..spawner.name,
        tiles={spawner.texture},
        groups={undiggable=1},
    })
    if not minetest.is_creative_enabled() then
        minetest.register_abm({
            label="spawn "..spawner.name,
            --name="regulus_mobs:spawn_guide1",
            interval=0.5,
            chance=1,
            nodenames={"regulus_mobs:spawn_"..spawner.name},
            --run_at_every_load=true,
            action=function(pos,node)
                for _,player in pairs(minetest.get_connected_players()) do
                    if mod_storage:get_int(spawner.name.."_has_spawned")~=1 or spawner.spawn_every_time then
                        --minetest.chat_send_all("help me spawn mob")
                        --minetest.after(0.1,function()
                        local obj=minetest.add_entity(pos+vector.new(0,1,0),"regulus_mobs:"..spawner.name)
                        obj:set_yaw(spawner.yaw or 0)
                        --end)
                        minetest.set_node(pos,{name=spawner.newnode})
                        mod_storage:set_int(spawner.name.."_has_spawned",1)
                    end
                end
            end
        })
    end
end

minetest.register_abm({
    label="spawn guide2",
    name="regulus_mobs:spawn_guide2",
    nodenames={"regulus_mobs:spawn_guide2"},
    --run_at_every_load=true,
    action=function(pos,node)
        minetest.chat_send_all("help me spawn mob2")
        --minetest.after(0.1,function()
        minetest.add_entity(pos+vector.new(0,1,0),"regulus_mobs:guide2")
        --end)
    end
})