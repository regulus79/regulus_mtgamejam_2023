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
    mesh="regulus_boss.obj",
    physical=true,
    collide_with_objects=true,
    collisionbox={-1,-1.5,-1,1,1.5,1},
    textures={"regulus_boss.png"},
    hp_max=100,
    _state="primary",
    _timer=0,
    _crystal_pos=nil,
    _shoot_interval=1.5,
    _projectile_speed=5,
    on_activate=function(self)
        regulus_story.play_music("mtgj_boss3")
        mod_storage:set_int("bossfight_in_progress",1)
        self._crystal_pos=minetest.find_node_near(self.object:get_pos(),30,"group:crystal") or self.object:get_pos()
        --minetest.chat_send_all(dump(minetest.find_node_near(self.object:get_pos(),30,"group:crystal")))
        for _,player in pairs(minetest.get_connected_players()) do
            regulus_story.trigger_dialogue(player, "bossfight2")
        end
        minetest.add_particlespawner({
            amount=20,
            time=0,
            attached=self.object,
            texture={
                name="regulus_boss_sparkle1.png",
                scale_tween={5,0},
            },
            vel={
                min=vector.new(-1,-1,-1),
                max=vector.new(1,1,1),
            },
            pos={
                min=vector.new(-1,-1,-1),
                max=vector.new(1,1,1),
            },
            scale=10,
        })
        local band1=minetest.add_entity(self.object:get_pos(),"regulus_mobs:boss_orbiting_band")
        band1:get_luaentity()._parent=self.object
        band1:get_luaentity()._offset=vector.new(0,0.5,0)
        band1:get_luaentity().automatic_rotate=1
        local band2=minetest.add_entity(self.object:get_pos(),"regulus_mobs:boss_orbiting_band")
        band2:get_luaentity()._parent=self.object
        band2:get_luaentity()._offset=vector.new(0,1.5,0)
        local props=band2:get_properties()
        props.automatic_rotate=-1
        band2:set_properties(props)
        local band3=minetest.add_entity(self.object:get_pos(),"regulus_mobs:boss_orbiting_band")
        band3:get_luaentity()._parent=self.object
        band3:get_luaentity()._offset=vector.new(0,1,0)
        local props=band3:get_properties()
        props.automatic_rotate=0.5
        props.visual_size=vector.new(2,2,2)*2
        band3:set_properties(props)
    end,
    on_step=function(self,dtime)
        self._timer=self._timer+dtime
        for _,player in pairs(minetest.get_connected_players()) do
            local dist=self.object:get_pos():distance(player:get_pos())
            self.object:set_yaw(self.object:get_pos():direction(player:get_pos()):dir_to_rotation().y)

            if self._timer>self._shoot_interval then
                self._timer=0
                local obj=minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:boss_projectile1")
                obj:get_luaentity()._parent=self.object
                if self._state=="primary" then
                    obj:set_velocity(self.object:get_pos():direction(player:get_pos())*self._projectile_speed)
                else
                    obj:set_velocity(aim(self.object:get_pos(), player, self._projectile_speed))
                    for i=1,5 do
                        minetest.after(self._shoot_interval*i/6, function()
                            if self and self.object and self.object:get_pos() then
                                local obj2=minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:boss_projectile2")
                                obj2:set_velocity((self.object:get_pos():direction(player:get_pos())+0.5*vector.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))):normalize()*self._projectile_speed)
                            end
                        end)
                    end
                end
            end

            --local movedir=self.object:get_pos():direction(player:get_pos())
            local crystal_dir=self.object:get_pos():direction(self._crystal_pos)
            local crystal_dist=self.object:get_pos():distance(self._crystal_pos)
            local player_dir=self.object:get_pos():direction(player:get_pos()+vector.new(0,5,0))
            local player_dist=self.object:get_pos():distance(player:get_pos()+vector.new(0,5,0))
            local movedir=crystal_dir:cross(vector.new(0,1,0)):normalize()+player_dir*player_dist*0.2+(crystal_dir-vector.new(0,crystal_dir.y,0))*(crystal_dist-12)
            self.object:set_velocity(movedir)
        end
    end,
    on_punch=function(self,puncher)
        if self.object:get_hp()<30 and self._state=="secondary" then
            self._state="final"
            self._shoot_interval=0.5
            self._projectile_speed=20
            minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:light_ball")
            minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:light_ball_backwards")
            --minetest.chat_send_all("FINAL STAGE")
        elseif self.object:get_hp()<70 and self._state=="primary" then
            self._state="secondary"
            self._shoot_interval=1.0
            self._projectile_speed=10
            minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:light_ball")
            minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:light_ball_backwards")
            --minetest.chat_send_all("SECONDARY STAGE")
        end
    end,
    on_death=function(self,killer)
        minetest.set_node(self._crystal_pos, {name="regulus_story:crystal"})
        mod_storage:set_int("bossfight_in_progress",0)
        minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:light_ball")
        minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:light_ball_backwards")
        for _, player in pairs(minetest.get_connected_players()) do
            local meta=player:get_meta()
            meta:set_string("exit","room1")
            meta:set_int("exit_spawnpoint_num",3)
        end
        minetest.sound_play("regulus_boss_die",{gain=1.0})
        regulus_story.play_music("mtgj_song2")
        for _, player in pairs(minetest.get_connected_players()) do
            regulus_gui.remove_cinematic_bars(player)
        end
    end,


})

minetest.register_entity("regulus_mobs:boss_projectile1",{
    visual="sprite",
    textures={"regulus_boss_projectile1.png"},
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
        if moveresult.collides and self and self.object and self.object:get_velocity() then
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


minetest.register_entity("regulus_mobs:boss_projectile2",{
    visual="sprite",
    textures={"regulus_boss_projectile2.png"},
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
                name="regulus_boss_projectile2.png",
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
        if moveresult.collides and self and self.object and self.object:get_velocity() then
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


minetest.register_entity("regulus_mobs:boss_orbiting_band",{
    visual="mesh",
    mesh="regulus_boss_orbiting_band.obj",
    textures={"regulus_boss_orbiting_band.png"},
    use_texture_alpha=true,
    --backface_culling=false,
    automatic_rotate=1,
    visual_size=vector.new(1,3,1)*2,
    --shaded=false,
    static_save=false,
    pointable=false,
    on_step=function(self,dtime)
        if self._parent and self._parent:get_pos() and self._offset then
            self.object:set_pos(self._parent:get_pos()+self._offset)
        else
            self.object:remove()
        end
    end,
})

minetest.register_entity("regulus_mobs:light_ball",{
    visual="mesh",
    mesh="regulus_light_ball.obj",
    textures={"regulus_light_ball.png"},
    use_texture_alpha=true,
    backface_culling=false,
    automatic_rotate=1,
    visual_size=vector.new(20,20,20),
    pointable=false,
    shaded=false,
    on_activate=function(self)
        minetest.after(1,function()
            self.object:remove()
        end)
    end,
})
minetest.register_entity("regulus_mobs:light_ball_backwards",{
    visual="mesh",
    mesh="regulus_light_ball.obj",
    textures={"regulus_light_ball.png"},
    use_texture_alpha=true,
    backface_culling=false,
    automatic_rotate=1,
    visual_size=vector.new(20,20,20),
    pointable=false,
    shaded=false,
    on_activate=function(self)
        minetest.after(1,function()
            self.object:remove()
        end)
    end,
})