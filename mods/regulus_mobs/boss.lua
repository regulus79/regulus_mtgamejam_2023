minetest.register_entity("regulus_mobs:boss",{
    visual="mesh",
    mesh="regulus_player_model1.obj",
    physical=true,
    collide_with_objects=false,
    collisionbox={-0.3,0,-0.3,0.3,1.77,0.3},
    hp_max=100,
    _state="",
    _timer=0,
    _crystal_pos=nil,
    _shoot_interval=3,
    on_activate=function(self)
        self._crystal_pos=minetest.find_node_near(self.object:get_pos(),15,"group:crystal")
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
                obj:set_velocity(self.object:get_pos():direction(player:get_pos())*5)
            end

            --local movedir=self.object:get_pos():direction(player:get_pos())
            local crystal_dir=self.object:get_pos():direction(self._crystal_pos)
            local player_dir=self.object:get_pos():direction(player:get_pos())
            local movedir=crystal_dir:cross(vector.new(0,1,0)):normalize()+player_dir
            self.object:set_velocity(movedir)
        end
    end,
    on_punch=function(self,puncher)
        if self.object:get_hp()<30 then
            self._state="final"
            self._shoot_interval=0.7
            minetest.chat_send_all("FINAL STAGE")
        elseif self.object:get_hp()<70 then
            self._state="secondary"
            self._shoot_interval=1.5
            minetest.chat_send_all("SECONDARY STAGE")
        end
    end,


})

minetest.register_entity("regulus_mobs:boss_projectile1",{
    visual="sprite",
    textures={"regulus_boss_projectile1.png"},
    physical=true,
    _timer=0,
    _lifetime=5,
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