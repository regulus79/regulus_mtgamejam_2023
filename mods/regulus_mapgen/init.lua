

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
})

minetest.register_node("regulus_mapgen:pos1",{
    description="node for setting the pos1 for a map schematic",
    tiles={"regulus_transparent_white.png^[multiply:#10ffff"},
    use_texture_alpha=true,
})

minetest.register_node("regulus_mapgen:pos2",{
    description="node for setting the pos2 for a map schematic",
    tiles={"regulus_transparent_white.png^[multiply:#ffff10"},
    use_texture_alpha=true,
})