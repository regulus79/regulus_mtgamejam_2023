
minetest.register_node("regulus_portcullis:portcullis_generator",{
    description="portcullis generator",
    tiles={"regulus_portcullis.png"},
    groups={undiggable=1},
})

minetest.register_entity("regulus_portcullis:portcullis",{
    visual="mesh",
    mesh="regulus_portcullis.obj",
    visual_size=vector.new(10,10,10),
    textures={"regulus_stone1.png^[darken:#444444"}
})