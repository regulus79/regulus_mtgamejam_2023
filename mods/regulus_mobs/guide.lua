
local register_npc=function(name,textures,on_rightclick,on_step,_notice_dist)
    minetest.register_entity("regulus_mobs:"..name,{
        visual="mesh",
        mesh="regulus_player_model1.obj",
        textures=textures,
        physical=true,
        selectionbox={-0.3,0,-0.3,0.3,1.77,0.3},
        collisionbox={-0.3,0,-0.3,0.3,1.77,0.3},

        _notice_dist=_notice_dist or 2,

        on_activate=function(self, staticdata, dtime_s)
            self.object:set_acceleration(vector.new(0,-10,0))
        end,

        on_rightclick=on_rightclick,

        on_step=on_step or function(self,dtime)
            for _,player in pairs(minetest.get_connected_players()) do
                local dist=self.object:get_pos():distance(player:get_pos())
                if dist<self._notice_dist then
                    self.object:set_yaw(player:get_pos():direction(self.object:get_pos()):dir_to_rotation().y)
                end
            end
        end,
    })
end


register_npc(
    "guide_library",
    {"regulus_character2.png"},
    function(self,clicker)
        local meta=clicker:get_meta()
        if meta:get_int("dialogue_library1")~=1 then
            regulus_story.trigger_dialogue(clicker,"library1")
        elseif meta:get_int("dialogue_library2")~=1 and meta:get_int("has_wand")==1 then
            regulus_story.trigger_dialogue(clicker,"library2")
        else
            regulus_story.trigger_dialogue(clicker,"library_idle")
        end
        self.object:set_yaw(clicker:get_pos():direction(self.object:get_pos()):dir_to_rotation().y)
    end
)


register_npc(
    "guide_room1",
    {"regulus_character2.png"},
    function(self,clicker)
        local meta=clicker:get_meta()
        if meta:get_int("dialogue_intro")~=1 then
            regulus_story.trigger_dialogue(clicker,"intro")
        else
            regulus_story.trigger_dialogue(clicker,"intro_idle")
        end
        self.object:set_yaw(clicker:get_pos():direction(self.object:get_pos()):dir_to_rotation().y)
    end
)


register_npc(
    "guide_room5",
    {"regulus_character2.png"},
    function(self,clicker)
        local meta=clicker:get_meta()
        if meta:get_int("dialogue_second_meeting1")~=1 then
            regulus_story.trigger_dialogue(clicker,"second_meeting1")
        elseif meta:get_int("dialogue_second_meeting2")~=1 and meta:get_int("achievements_tiny")==1 then
            regulus_story.trigger_dialogue(clicker,"second_meeting2")
        else
            regulus_story.trigger_dialogue(clicker,"second_meeting_idle")
        end
        self.object:set_yaw(clicker:get_pos():direction(self.object:get_pos()):dir_to_rotation().y)
    end
)



register_npc(
    "guide_bossfight",
    {"regulus_character2.png"},
    nil,
    function(self,dtime)
        for _,player in pairs(minetest.get_connected_players()) do
            if not self._spotted then
                local meta=player:get_meta()
                if meta:get_int("dialogue_bossfight1")~=1 then
                    regulus_story.trigger_dialogue(player,"bossfight1",function()
                        minetest.chat_send_all("Time to shapeshift!")
                    end)
                end
                self._spotted=true
            end
            local dist=self.object:get_pos():distance(player:get_pos())
            if dist<self._notice_dist then
                self.object:set_yaw(player:get_pos():direction(self.object:get_pos()):dir_to_rotation().y)
            end
        end
    end,
    30
)