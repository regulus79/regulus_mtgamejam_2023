local mod_storage=minetest.get_mod_storage()


local aim=function(selfpos,target_object,max_speed)
    local dir=selfpos:direction(target_object:get_pos())
    local perp_up=dir:cross(target_object:get_velocity()):normalize()
    local perp_side=perp_up:cross(dir):normalize()
    local vel=perp_side*perp_side:dot(target_object:get_velocity())
    vel=vel+dir*math.sqrt(max_speed^2-vel:length()^2)
    return vel
end


minetest.register_entity("regulus_mobs:boss",{
    visual="mesh",
    mesh="regulus_player_model1.obj",
    physical=true,
    collide_with_objects=false,
    collisionbox={-0.3,0,-0.3,0.3,1.77,0.3},
    hp_max=100,
    _state="primary",
    _timer=0,
    _crystal_pos=nil,
    _shoot_interval=3,
    _projectile_speed=5,
    on_activate=function(self)
        mod_storage:set_int("bossfight_in_progress",1)
        self._crystal_pos=minetest.find_node_near(self.object:get_pos(),20,"group:crystal") or self.object:get_pos()
        for _,player in pairs(minetest.get_connected_players()) do
            regulus_story.trigger_dialogue(player, "bossfight2")
        end
        minetest.add_particlespawner({
            amount=10,
            time=0,
            attached=self.object,
            texture={
                name="regulus_boss_sparkle1.png",
                scale_tween={5,0},
            },
            vel={
                min=vector.new(-1,-1,-1),
                max=vector.new(1,1,1),
            }
        })
    end,
    on_step=function(self,dtime)
        self._timer=self._timer+dtime
        for _,player in pairs(minetest.get_connected_players()) do
            local dist=self.object:get_pos():distance(player:get_pos())
            self.object:set_yaw(player:get_pos():direction(self.object:get_pos()):dir_to_rotation().y)

            if self._timer>1.5 then
                self._timer=0
                local obj=minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:boss_projectile1")
                obj:get_luaentity()._parent=self.object
                if self._state=="primary" then
                    obj:set_velocity(self.object:get_pos():direction(player:get_pos())*self._projectile_speed)
                else
                    obj:set_velocity(aim(self.object:get_pos(), player, self._projectile_speed))
                end
            end

            --local movedir=self.object:get_pos():direction(player:get_pos())
            local crystal_dir=self.object:get_pos():direction(self._crystal_pos)
            local player_dir=self.object:get_pos():direction(player:get_pos()+vector.new(0,3,0))
            local movedir=crystal_dir:cross(vector.new(0,1,0)):normalize()+player_dir
            self.object:set_velocity(movedir)
        end
    end,
    on_punch=function(self,puncher)
        if self.object:get_hp()<30 and self._state=="secondary" then
            self._state="final"
            self._shoot_interval=0.5
            self._projectile_speed=20,
            minetest.chat_send_all("FINAL STAGE")
        elseif self.object:get_hp()<70 and self._state=="primary" then
            self._state="secondary"
            self._shoot_interval=1.0
            self._projectile_speed=10,
            minetest.chat_send_all("SECONDARY STAGE")
        end
    end,
    on_death=function(self,killer)
        minetest.set_node(self._crystal_pos, {name="regulus_story:crystal"})
        mod_storage:set_int("bossfight_in_progress",0)
    end,


})

minetest.register_entity("regulus_mobs:boss_projectile1",{
    visual="sprite",
    textures={"regulus_boss_projectile1.png"},
    physical=true,
    _timer=0,
    _lifetime=5,
    on_activate=function(self)
        minetest.add_particlespawner({
            amount=10,
            time=0,
            attached=self.object,
            texture={
                name="regulus_boss_projectile1.png",
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
                if collision.type=="object" and collision.object:is_player() then
                    collision.object:punch(
                        self.object,
                        nil,
                        {
                            damage_groups={
                                fleshy=1,
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