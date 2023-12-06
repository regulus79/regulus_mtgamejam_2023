regulus_mapgen={}


local storage=minetest.get_mod_storage()

minetest.register_node("regulus_mapgen:spawnpoint",{
    description="node for setting the spawnpoint in a map",
    tiles={"regulus_transparent_white.png^[multiply:#101010"},
    drawtype="nodebox",
    node_box={
        type="fixed",
        fixed={-0.5,-0.5,-0.5,0.5,-0.4,0.5},
    },
    paramtype="light",
    use_texture_alpha=true,
    after_place_node=function(pos,placer,itemstack,pointed_thing)
        placer:get_meta():set_string("spawnpoint",minetest.serialize(pos))
        minetest.chat_send_all("spawnpoint set to "..dump(pos))
    end,
    on_punch=function(pos,node,puncher,pointed_thing)
        puncher:get_meta():set_string("spawnpoint",minetest.serialize(pos))
        minetest.chat_send_all("spawnpoint set to "..dump(pos))
    end,
    groups={undiggable=1}
})

minetest.register_node("regulus_mapgen:pos1",{
    description="node for setting the pos1 for a map schematic",
    tiles={"regulus_transparent_white.png^[multiply:#10ffff"},
    use_texture_alpha=true,
    after_place_node=function(pos,placer,itemstack,pointed_thing)
        placer:get_meta():set_string("pos1",minetest.serialize(pos))
        minetest.chat_send_all("pos1 set to "..dump(pos))
    end,
    on_punch=function(pos,node,puncher,pointed_thing)
        puncher:get_meta():set_string("pos1",minetest.serialize(pos))
        minetest.chat_send_all("pos1 set to "..dump(pos))
    end,
    groups={undiggable=1}
})

minetest.register_node("regulus_mapgen:pos2",{
    description="node for setting the pos2 for a map schematic",
    tiles={"regulus_transparent_white.png^[multiply:#ffff10"},
    use_texture_alpha=true,
    after_place_node=function(pos,placer,itemstack,pointed_thing)
        placer:get_meta():set_string("pos2",minetest.serialize(pos))
        minetest.chat_send_all("pos2 set to "..dump(pos))
    end,
    on_punch=function(pos,node,puncher,pointed_thing)
        puncher:get_meta():set_string("pos2",minetest.serialize(pos))
        minetest.chat_send_all("pos2 set to "..dump(pos))
    end,
    groups={undiggable=1}
})


minetest.register_chatcommand("save_level",{
    description="save the area between the two pos1 and pos2 nodes as a schematic with the level name as the param",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        local meta=player:get_meta()
        local pos1=minetest.deserialize(meta:get_string("pos1"))
        local pos2=minetest.deserialize(meta:get_string("pos2"))
        local spawnpoint=minetest.deserialize(meta:get_string("spawnpoint"))
        local minpos=vector.new(math.min(pos1.x,pos2.x),math.min(pos1.y,pos2.y),math.min(pos1.z,pos2.z))
        local maxpos=vector.new(math.max(pos1.x,pos2.x),math.max(pos1.y,pos2.y),math.max(pos1.z,pos2.z))
        minetest.create_schematic(pos1,pos2,{},minetest.get_modpath("regulus_mapgen").."/schems/"..param..".mts")

        local level_settings={
            relative_spawnpoint=spawnpoint-minpos
        }
        local file=io.open(minetest.get_modpath("regulus_mapgen").."/level_settings/"..param..".lua","w")
        if file then
            file:write(minetest.serialize(level_settings))
            file:close()
        else
            minetest.chat_send_all("Error "..dump(err).."while saving level to file")
        end
        storage:set_string(param.."relative_spawnpoint",minetest.serialize(spawnpoint-minpos))
    end

})

regulus_mapgen.load_level=function(player,levelname)
    minetest.place_schematic(
        vector.new(0,0,0),
        minetest.get_modpath("regulus_mapgen").."/schems/"..levelname..".mts"
    )
    local level_settings=dofile(minetest.get_modpath("regulus_mapgen").."/level_settings/"..levelname..".lua")--minetest.deserialize(storage:get_string(levelname.."_relative_spawnpoint"))
    --minetest.chat_send_all("hello"..dump(level_settings))
    player:set_pos(level_settings.relative_spawnpoint)
end


minetest.register_chatcommand("load_level",{
    description="load the area of the given name",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        regulus_mapgen.load_level(player,param)
    end
})

minetest.register_on_newplayer(function(player)
    regulus_mapgen.load_level(player,"main")
    player:get_inventory():add_item("main",ItemStack("regulus_tools:test"))
end)