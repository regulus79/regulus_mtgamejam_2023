--todo
regulus_powerups={}

regulus_powerups.list_of_powerups={
    fly={color="#ff4500",motto="Fly, you fools!"},
    tiny={color="#45ff00",motto="Man of Ants"},
    shoot={color="#0045ff",motto="Fire at Will"},
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
    local is_already_flying=physics.gravity==0
    physics.speed=0
    physics.gravity=0
    player:set_physics_override(physics)
    if not is_already_flying then
        player:add_velocity(vector.new(0,1.5,0))
    end
    minetest.after(1.5,function()
        player:set_physics_override(default_physics_override)
    end)
end

local return_to_normal_size
return_to_normal_size=function(player)
    if not minetest.registered_nodes[minetest.get_node(player:get_pos()+vector.new(0,1.625,0)).name].walkable then
        local props=player:get_properties()
        props.visual_size=regulus_player.default_player_size
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

minetest.register_entity("regulus_powerups:player_projectile",{
    visual="sprite",
    textures={"regulus_player_projectile1.png"},
    physical=true,
    _timer=0,
    _lifetime=5,
    collisionbox={-0.2,-0.2,-0.2,0.2,0.2,0.2},
    on_activate=function(self)
        minetest.add_particlespawner({
            amount=10,
            time=0,
            attached=self.object,
            texture={
                name="regulus_player_projectile1.png",
                scale=10,
                scale_tween={
                    10,0
                }
            },
        })
    end,
    on_step=function(self,dtime,moveresult)
        self._timer=self._timer+dtime
        if self._timer>self._lifetime then
            self.object:remove()
        end
        if moveresult.collides then
            for _,collision in pairs(moveresult.collisions) do
                if collision.type=="object" and collision.object and collision.object:get_luaentity() and (collision.object:get_luaentity().name=="regulus_mobs:boss" or collision.object:get_luaentity().name=="regulus_mobs:enemy1") and self.object and self.object:get_velocity() then
                    collision.object:punch(
                        self.object,
                        nil,
                        {
                            damage_groups={
                                fleshy=5,
                            }
                        },
                        self.object:get_velocity():normalize()
                    )
                    self.object:remove()
                elseif collision.type=="node" then
                    self.object:remove()
                end
            end
        end
    end
})

local prev_shoot_time=0
regulus_powerups.shoot=function(player)
    if minetest.get_us_time()-prev_shoot_time>1.0*10^6 then
        local obj=minetest.add_entity(player:get_pos()+vector.new(0,1.625,0),"regulus_powerups:player_projectile")
        obj:set_velocity(player:get_look_dir()*5)
        prev_shoot_time=minetest.get_us_time()
    end
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
