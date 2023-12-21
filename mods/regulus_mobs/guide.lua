
local register_npc=function(name,textures,on_rightclick,on_step,on_spot,_notice_dist)
    minetest.register_entity("regulus_mobs:"..name,{
        visual="mesh",
        mesh="regulus_player_model2.obj",
        textures=textures,
        physical=true,
        selectionbox={-0.3,0,-0.3,0.3,1.77,0.3},
        collisionbox={-0.3,0,-0.3,0.3,1.77,0.3},
        _spotted=false,

        _notice_dist=_notice_dist or 2,

        on_activate=function(self, staticdata, dtime_s)
            self.object:set_acceleration(vector.new(0,-10,0))
            self.object:set_armor_groups({immortal=1})
        end,

        on_rightclick=on_rightclick,

        on_step=on_step or function(self,dtime)
            for _,player in pairs(minetest.get_connected_players()) do
                local dist=self.object:get_pos():distance(player:get_pos())
                if dist<self._notice_dist then
                    if not self._spotted and on_spot then
                        on_spot(self,player)
                        self._spotted=true
                    end
                    self.object:set_yaw(self.object:get_pos():direction(player:get_pos()):dir_to_rotation().y)
                end
            end
        end,
    })
end


register_npc(
    "guide_library",
    {"regulus_character_new3.png"},
    function(self,clicker)
        local meta=clicker:get_meta()
        if meta:get_int("dialogue_library1")~=1 then
            regulus_story.trigger_dialogue(clicker,"library1")
        elseif meta:get_int("dialogue_library2")~=1 and meta:get_int("has_wand")==1 then
            regulus_story.trigger_dialogue(clicker,"library2")
        else
            regulus_story.trigger_dialogue(clicker,"library_idle")
        end
        self.object:set_yaw(self.object:get_pos():direction(clicker:get_pos()):dir_to_rotation().y)
    end,
    function(self,dtime)
        for _,player in pairs(minetest.get_connected_players()) do
            if player:get_pos():distance(self.object:get_pos())<self._notice_dist then
                if not self._spotted then
                    local meta=player:get_meta()
                    if meta:get_int("dialogue_library1")~=1 then
                        regulus_story.trigger_dialogue(player,"library1")
                        self._spotted=true
                    end
                end
                if not self._spotted2 then
                    local meta=player:get_meta()
                    if meta:get_int("dialogue_library1")==1 and meta:get_int("dialogue_library2")~=1 and meta:get_int("has_wand")==1 then
                        regulus_story.trigger_dialogue(player,"library2")
                        self._spotted2=true
                    end
                end
                self.object:set_yaw((self.object:get_pos():direction(player:get_pos())):dir_to_rotation().y)
            end
        end
    end,
    nil,
    5
)


register_npc(
    "guide_room1",
    {"regulus_character_new2.png"},
    function(self,clicker)
        local meta=clicker:get_meta()
        regulus_story.trigger_dialogue(clicker,"intro_idle")
        self.object:set_yaw(self.object:get_pos():direction(clicker:get_pos()):dir_to_rotation().y)
    end,
    nil,
    function(self,player)
        local meta=player:get_meta()
        if meta:get_int("dialogue_intro")~=1 then
            regulus_story.trigger_dialogue(player,"intro")
        end
    end,
    5
)


register_npc(
    "guide_room5",
    {"regulus_character_new3.png"},
    function(self,clicker)
        local meta=clicker:get_meta()
        if meta:get_int("dialogue_second_meeting1")~=1 then
            regulus_story.trigger_dialogue(clicker,"second_meeting1")
        elseif meta:get_int("dialogue_second_meeting2")~=1 and meta:get_int("achievements_tiny")==1 then
            regulus_story.trigger_dialogue(clicker,"second_meeting2")
        else
            regulus_story.trigger_dialogue(clicker,"second_meeting_idle")
        end
        self.object:set_yaw(self.object:get_pos():direction(clicker:get_pos()):dir_to_rotation().y)
    end,
    function(self,dtime)
        for _,player in pairs(minetest.get_connected_players()) do
            if player:get_pos():distance(self.object:get_pos())<self._notice_dist then
                local meta=player:get_meta()
                if not self._spotted then
                    if meta:get_int("dialogue_second_meeting1")~=1 then
                        regulus_story.trigger_dialogue(player,"second_meeting1")
                        self._spotted=true
                    end
                end
                if not self._spotted2 and meta:get_int("dialogue_second_meeting1")==1 then
                    if meta:get_int("dialogue_second_meeting2")~=1 and meta:get_int("achievements_tiny")==1 then
                        regulus_story.trigger_dialogue(player,"second_meeting2")
                        self._spotted2=true
                    end
                end
                self.object:set_yaw(self.object:get_pos():direction(player:get_pos()):dir_to_rotation().y)
            end
        end
    end,
    nil,
    10
)



register_npc(
    "guide_third_meeting",
    {"regulus_character_new3.png"},
    nil,
    nil,
    function(self,player)
        local meta=player:get_meta()
        if meta:get_int("dialogue_third_meeting")~=1 then
            regulus_story.trigger_dialogue(player,"third_meeting")
        end
    end,
    5
)


register_npc(
    "guide_bossfight",
    {"regulus_character_new3.png"},
    nil,
    function(self,dtime)
        for _,player in pairs(minetest.get_connected_players()) do
            if not self._spotted then
                local meta=player:get_meta()
                if meta:get_int("dialogue_bossfight1")~=1 then
                    regulus_story.trigger_dialogue(player,"bossfight1",function()
                        --minetest.chat_send_all("Time to shapeshift!")
                        minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:light_ball")
                        minetest.add_entity(self.object:get_pos()+vector.new(0,1,0),"regulus_mobs:light_ball_backwards")
                        local props=self.object:get_properties()
                        props.is_visible=false
                        self.object:set_properties(props)
                        regulus_gui.add_cinematic_bars(player)
                        minetest.after(0.5,function()
                            minetest.add_entity(self.object:get_pos(),"regulus_mobs:boss")
                            self.object:remove()
                        end)
                    end)
                end
                self._spotted=true
            end
            local dist=self.object:get_pos():distance(player:get_pos())
            if dist<self._notice_dist then
                self.object:set_yaw(self.object:get_pos():direction(player:get_pos()):dir_to_rotation().y)
            end
        end
    end,
    nil,
    30
)