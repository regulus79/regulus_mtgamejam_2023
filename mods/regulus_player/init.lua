regulus_player={}

regulus_player.default_player_size=vector.new(1,1,1)
--should add custom sounds for damage and stuff


minetest.register_on_joinplayer(function(player,last_login)
    local props=player:get_properties()
    props.visual_size=vector.new(1,1,1)
    props.collisionbox={-0.3,0,-0.3,0.3,1.77,0.3}
    props.eye_height=1.625
    props.visual="mesh"
    props.visual_size=regulus_player.default_player_size
    props.mesh="regulus_player_model2.obj"
    props.textures={"regulus_character_new1.png"},
    minetest.after(0.5,function()
        player:set_properties(props)
    end)

    player:get_meta():set_string("powerup","fly")

    if player:get_meta():get_int("finished")~=1 then
        player:set_sky({
            base_color="#000000",
            type="plain",
            clouds=false,
        })
        player:set_sun({
            visible=false,
            sunrise_visible=false,
        })
        player:override_day_night_ratio(0.0)
    end
end)

minetest.register_on_newplayer(function(player)
    --regulus_mapgen.load_level(player,"main")
    player:set_look_horizontal(2*math.pi*3/4)
    if not minetest.is_creative_enabled() then
        regulus_mapgen.load_level(player,"room1")
    end
    --player:get_inventory():add_item("main",ItemStack("regulus_tools:test"))
end)