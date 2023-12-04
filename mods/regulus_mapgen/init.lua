

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
    on_construct=function(pos)
        player:get_meta():set_string("spawnpoint",minetest.serialize(pos))
        minetest.chat_send_all("spawnpoint set to "..dump(pos))
    end
})

minetest.register_node("regulus_mapgen:pos1",{
    description="node for setting the pos1 for a map schematic",
    tiles={"regulus_transparent_white.png^[multiply:#10ffff"},
    use_texture_alpha=true,
    on_construct=function(pos)
        player:get_meta():set_string("pos1",minetest.serialize(pos))
        minetest.chat_send_all("pos1 set to "..dump(pos))
    end
})

minetest.register_node("regulus_mapgen:pos2",{
    description="node for setting the pos2 for a map schematic",
    tiles={"regulus_transparent_white.png^[multiply:#ffff10"},
    use_texture_alpha=true,
    on_construct=function(pos)
        player:get_meta():set_string("pos2",minetest.serialize(pos))
        minetest.chat_send_all("pos2 set to "..dump(pos))
    end
})


minetest.register_chatcommand("save_area",{
    description="save the area between the two pos1 and pos2 nodes as a schematic with the level name as the param",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
    end

})