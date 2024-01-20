local mod_storage=minetest.get_mod_storage()


minetest.register_entity("regulus_mobs:enemy1",{
    initial_properties={
        visual="mesh",
        mesh="regulus_enemy1.obj",
        physical=true,
        collide_with_objects=true,
        collisionbox={-0.2,-0.2,-0.2,0.2,0.2,0.2},
        textures={"regulus_enemy1.png"},
        hp_max=1,
        automatic_face_movement_dir=90,
    },
    _notice_dist=10,
    _attack_dist=1,
    _timer=0,
    _attack_interval=0.5,
    on_activate=function(self)
        self.object:set_acceleration(vector.new(0,-10,0))
    end,
    on_step=function(self,dtime)
        self._timer=self._timer+dtime
        for _, player in pairs(minetest.get_connected_players()) do
            local dist=player:get_pos():distance(self.object:get_pos())
            if dist<self._notice_dist then
                local vel=self.object:get_pos():direction(player:get_pos())+vector.new(math.random(-0.1,0.1),math.random(-0.1,0.1),math.random(-0.1,0.1)):normalize()*0.1
                vel.y=self.object:get_velocity().y
                self.object:set_velocity(vel)
            end
            if dist<self._attack_dist and self._timer>self._attack_interval then
                self._timer=0
                player:punch(
                    self.object,
                    nil,
                    {
                        damage_groups={
                            fleshy=1,
                        }
                    },
                    self.object:get_pos():direction(player:get_pos())
                )
            end
        end
    end,
    on_death=function(self,killer)
        minetest.item_drop(ItemStack("regulus_mobs:health_powder"),self.object,self.object:get_pos())
    end
})

minetest.register_node("regulus_mobs:spawn_enemy1",{
    description="spawn enemy1",
    tiles={"regulus_v_panel.png"},
    groups={undiggable=1},
})
if not minetest.is_creative_enabled() then
    minetest.register_abm({
        label="spawn enemy1",
        --name="regulus_mobs:spawn_guide1",
        interval=0.5,
        chance=1,
        nodenames={"regulus_mobs:spawn_enemy1"},
        --run_at_every_load=true,
        action=function(pos,node)
            for _,player in pairs(minetest.get_connected_players()) do
                --minetest.chat_send_all("help me spawn mob")
                --minetest.after(0.1,function()
                local obj=minetest.add_entity(pos+vector.new(0,1,0),"regulus_mobs:enemy1")
                --obj:set_yaw(spawner.yaw or 0)
                --end)
                minetest.set_node(pos,{name="regulus_nodes:v_panel"})
            end
        end
    })
end

minetest.register_craftitem("regulus_mobs:health_powder",{
    description="Health Powder",
    inventory_image="regulus_health_powder.png",
    on_use=minetest.item_eat(5),
})