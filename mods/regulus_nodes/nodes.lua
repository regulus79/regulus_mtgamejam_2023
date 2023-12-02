


minetest.register_node("regulus_nodes:testnode",{
    description="testnode",
    tiles={"regulus_wood1.png"},
    groups={undiggable=1},
})

minetest.register_node("regulus_nodes:wood",{
    description="wood",
    tiles={"regulus_wood1.png"},
    groups={undiggable=1},
})

minetest.register_node("regulus_nodes:stone",{
    description="stone",
    tiles={"regulus_stone1.png"},
    groups={undiggable=1},
})

minetest.register_node("regulus_nodes:x_panel",{
    description="x panel",
    tiles={"regulus_x_panel.png"},
    groups={undiggable=1},
})

minetest.register_node("regulus_nodes:square_window",{
    description="square_window",
    tiles={"regulus_square_window.png"},
    drawtype="glasslike",
    paramtype="light",
    groups={undiggable=1},
    use_texture_alpha=true,
})

minetest.register_node("regulus_nodes:v_panel",{
    description="v panel",
    tiles={"regulus_v_panel.png"},
    groups={undiggable=1},
})