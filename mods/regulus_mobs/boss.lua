minetest.register_entity("regulus_mobs:boss",{
    visual="mesh",
    mesh="regulus_player_model1.obj",
    _state="",
    on_step=function(self,dtime)
        for _,player in pairs(minetest.get_connected_players()) do
            local dist=self.object:get_pos():distance(player:get_pos())
            self.object:set_yaw(player:get_pos():direction(self.object:get_pos()):dir_to_rotation().y)
        end
    end

})

minetest.register_entity("regulus_mobs:boss_projectile1",{
    visual="sprite",
    textures={"regulus_boss_projectile1.png"},
    on_step=function(self,dtime,moveresult)
        minetest.chat_send_all(dump(moveresult))
        self.object:remove()
    end
})