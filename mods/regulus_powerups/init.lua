--todo
regulus_powerups={}

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
    local physics=player:get_physics_override()
    physics.speed=0
    physics.gravity=0
    player:set_physics_override(physics)
    local ids=regulus_gui.enable_powerup_effect(player,"Fly, you fools!",true)
    minetest.after(1.5,function()
        regulus_gui.disable_powerup_effect(player,ids)
        player:set_physics_override(default_physics_override)
    end)
end


regulus_powerups.tiny=function(player)
    local ids=regulus_gui.enable_powerup_effect(player,"you are tiny",true)
    
    minetest.after(1.5,function()
        regulus_gui.disable_powerup_effect(player,ids)
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
