regulus_player={}

regulus_player.default_player_size=vector.new(1,1,1)
--should add custom sounds for damage and stuff
local mod_storage=minetest.get_mod_storage()


minetest.hud_replace_builtin("health",{
    hud_elem_type="statbar",
    text="regulus_heart.png",
    text2="regulus_heart_bg.png",
    number=20,
    direction=0,
    position={x=0.5,y=1},
    offset={x=-24*5,y=-86},
    size={x=24,y=24}
})

minetest.register_on_joinplayer(function(player,last_login)
    local props=player:get_properties()
    props.visual_size=vector.new(1,1,1)
    props.collisionbox={-0.3,0,-0.3,0.3,1.77,0.3}
    props.eye_height=1.625
    props.visual="mesh"
    props.visual_size=regulus_player.default_player_size
    props.mesh="regulus_player_model2.obj"
    props.textures={"regulus_character_new4.png"},
    minetest.after(0.5,function()
        player:set_properties(props)
        if mod_storage:get_int("bossfight_in_progress")==1 then
            regulus_story.play_music("mtgj_boss3")
        else
            regulus_story.play_music("mtgj_song2")
        end

        --show the intro if they are a newplayer
        if not last_login and not minetest.is_creative_enabled()then
            regulus_story.show_intro(player)
        end
    end)

    player:get_meta():set_string("powerup","fly")

    if player:get_meta():get_int("finished")~=1 and not minetest.is_creative_enabled() then
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
        player:hud_set_hotbar_itemcount(0)
    end
    if player:get_meta():get_int("has_wand")~=1 then
        player:hud_set_flags({
            hotbar=false,
        })
    else
        player:hud_set_flags({
            hotbar=true,
        })
    end
    regulus_gui.add_vignette(player)
    player:set_inventory_formspec("")
    player:hud_set_hotbar_itemcount(1)
end)

minetest.register_on_newplayer(function(player)
    --regulus_mapgen.load_level(player,"main")
    --player:set_look_horizontal(math.pi*1/4)
    minetest.after(1,function()
        player:set_look_horizontal(2*math.pi*3/4)
    end)
    if not minetest.is_creative_enabled() or true then
        regulus_mapgen.load_level(player,"room1")
    end
    --player:get_inventory():add_item("main",ItemStack("regulus_tools:test"))
end)