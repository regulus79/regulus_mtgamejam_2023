--todo
regulus_powerups={}

regulus_powerups.list_of_powerups={
    fly={color="#ff4500",motto="Fly, you fools!"},
    tiny={color="#45ff00",motto="Man of Ants"},
    huge={color="#0045ff",motto=""},
}

regulus_powerups.random_teleport=function(player)
    local vec=vector.new(math.random(-10,10),math.random(-10,10),math.random(-10,10))
    local ray=minetest.raycast(player:get_pos(),player:get_pos()+vec,false)
    local hit_something,hit_pos=minetest.line_of_sight(player:get_pos(),player:get_pos()+vec)
    local dir=vector.normalize(vec)
    if hit_something~=true then
        --minetest.chat_send_all(dump(ray:next()))
        local the_pos=ray:next().above
        minetest.chat_send_all(dump(the_pos))
        player:set_pos(the_pos)
    end
end

local default_physics_override={
    speed=1,
    gravity=1,
    jump=1,
    speed_climb=1,
    speed_crouch=1,
    liquid_fluidity=1,
    liquid_fluidity_smooth=1,
    liquid_sink=1,
    acceleration_default=1,
    acceleration_air=1,
    sneak=true,
    sneak_glitch=false,
    new_move=true,
}

regulus_powerups.fly=function(player)
    --achievement triggering
    regulus_achievements.trigger_achieve(player,"achievements_fly")
    --
    local physics=player:get_physics_override()
    physics.speed=0
    physics.gravity=0
    player:set_physics_override(physics)
    player:add_velocity(vector.new(0,1.5,0))
    minetest.after(1.5,function()
        player:set_physics_override(default_physics_override)
    end)
end

local return_to_normal_size
return_to_normal_size=function(player)
    if not minetest.registered_nodes[minetest.get_node(player:get_pos()+vector.new(0,1.625,0)).name].walkable then
        local props=player:get_properties()
        props.visual_size={x=1,y=1,z=1}
        props.collisionbox={-0.3,0,-0.3,0.3,1.77,0.3}
        props.eye_height=1.625
        player:set_properties(props)
    else
        minetest.after(1,function()return_to_normal_size(player)end)
    end
end

local tiny_scalar=0.25
regulus_powerups.tiny=function(player)
    --achievement triggering
    regulus_achievements.trigger_achieve(player,"achievements_tiny")
    --
    local props=player:get_properties()
    props.visual_size=vector.new(tiny_scalar,tiny_scalar,tiny_scalar)
    props.collisionbox={-0.3*tiny_scalar,0,-0.3*tiny_scalar,0.3*tiny_scalar,1.77*tiny_scalar,0.3*tiny_scalar}
    props.eye_height=1.625*tiny_scalar
    player:set_properties(props)
    minetest.after(1.5,function()
        return_to_normal_size(player)
    end)
end



minetest.register_chatcommand("powerup",{
    description="test powerup",
    func=function(name,param)
        minetest.chat_send_all(minetest.get_player_by_name(name):get_meta():get_string("powerup"))
        --regulus_powerups.fly(minetest.get_player_by_name(name))
    end
})

regulus_powerups.apply_current_powerup=function(player)
    local powerup=player:get_meta():get_string("powerup")
    if regulus_powerups[powerup] then
        regulus_powerups[powerup](player)
    end
end
