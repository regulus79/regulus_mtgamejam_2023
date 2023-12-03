regulus_player={}

minetest.register_on_joinplayer(function(player,last_login)
    local props=player:get_properties()
    props.visual_size=vector.new(1,1,1)
    props.collisionbox={-0.3,0,-0.3,0.3,1.77,0.3}
    props.eye_height=1.625
    props.visual="mesh"
    props.mesh="regulus_player_model1.obj"
    props.texture="regulus_character.png",
    player:set_properties(props)
    minetest.chat_send_all(dump(player:get_properties()))
end)