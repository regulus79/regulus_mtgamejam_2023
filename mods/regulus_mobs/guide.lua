
minetest.register_entity("regulus_mobs:guide",{
    visual="mesh",
    mesh="regulus_player_model1.obj",
    textures={"regulus_character.png"},
    physical=true,
    selectionbox={-0.3,0,-0.3,0.3,1.77,0.3},
    collisionbox={-0.3,0,-0.3,0.3,1.77,0.3},

    _notice_dist=1,

    on_activate=function(self, staticdata, dtime_s)
        self.object:set_acceleration(vector.new(0,-10,0))
    end,

    on_rightclick=function(self,clicker)
        regulus_story.trigger_dialogue(clicker,"greeting")
        self.object:set_yaw(player:get_pos():direction(self.object:get_pos()):dir_to_rotation().y)
    end,

    on_step=function(self,dtime)
        for _,player in pairs(minetest.get_connected_players()) do
            local dist=self.object:get_pos():distance(player:get_pos())
            if dist<self._notice_dist then
                self.object:set_yaw(player:get_pos():direction(self.object:get_pos()):dir_to_rotation().y)
            end
        end
    end,
})