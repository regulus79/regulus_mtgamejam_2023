--todo

local mod_storage=minetest.get_mod_storage()

regulus_story={}

regulus_story.dialogues={
    intro={
        {file="todo",text="Greetings, young one!",length=2},
        {file="todo",text="Congratulations for completing your training",length=3},
        {file="todo",text="You are now a real wizard",length=2},
        {file="todo",text="But alas, this guild may not remain for long.",length=3},
        {file="todo",text="Our main source of energy was a large velvet crystal",length=5},
        {file="todo",text="But someone stole it in the night.",length=3},
        {file="todo",text="The darkness will soon swallow our world unless we get it back.",length=5},
        {file="todo",text="Your first mission as a wizard is to retrieve the stolen crystal",length=5},
        {file="todo",text="Along your way, make sure to pick up your new wand at the library.",length=5},
    },
    intro_idle={
        {file="todo",text="Go to the library to pick up your wand",length=4},
    },
    library1={
        {file="todo",text="Ah, hello young one!",length=2},
        {file="todo",text="I apologize for not noticing you when you came in. ",length=4},
        {file="todo",text="I was very busy thinking over our strategies to retrieve the crystal.",length=6},
        {file="todo",text="I believe you were sent to pick up your new wand, yes? ",length=4},
        {file="todo",text="It must be exciting to have finished your training.",length=3},
        {file="todo",text="The wand is somewhere in this library, I believe",length=3},
        {file="todo",text="But I am very busy at the moment,",length=1.5},
        {file="todo",text="perhaps you could go find it for me?",length=2},
    },
    library2={
        {file="todo",text="You found it? Oh, very good.",length=2},
        {file="todo",text="The defense obstacles in the base have been active ever since the crystal was stolen",length=6},
        {file="todo",text="You will need your wand to get past them to where the crystal was hidden",length=2},
        {file="todo",text="Good luck on your mission!",length=3},
    },
    library_idle={
        {file="todo",text="Use your wand to fly out of the library",length=4},
    },
    second_meeting1={
        {file="todo",text="Why, long time no see!",length=2},
        {file="todo",text="I wasn't expecting you to get here so fast.",length=3},
        {file="todo",text="The crystal is just after this room.",length=2},
        {file="todo",text="Is your new wand working okay?",length=3},
    },
    second_meeting2={
        {file="todo",text="",length=1},--pause
        {file="todo",text="Oh, dear, that is not right. You are so tiny!",length=2},
        {file="todo",text="You wand appears to be malfunctioning",length=3},
        {file="todo",text="I suppose you will have to take a detour through that small hole in the wall.",length=5},
        {file="todo",text="You'll still make it to the crystal, but it will take a bit longer.",length=3},
    },
    second_meeting_idle={
        {file="todo",text="Go through the hole in the wall to get to the next room",length=2},
        {file="todo",text="Your wand is malfunctioning. That's is why you become tiny when you use it.",length=3},
    },
    bossfight1={
        {file="todo",text="How did you get here so quickly? I wasn't finished preparing--",length=3},
        {file="todo",text="No matter.",length=1},
        {file="todo",text="I think it is time that I tell you the truth",length=3},
        {file="todo",text="I am not on your side",length=2},
        {file="todo",text="You see that crystal behind me? I am the one who stole it.",length=4},
    },
    bossfight2={
        {file="todo",text="For I am a master wizard",length=2},
        {file="todo",text="None can compare to me",length=2},
        {file="todo",text="You shall die, but I will live forever with the energy of this crystal.",length=4},
    },
    bossfight_try_dig_crystal={
        {file="todo",text="",length=2},
        {file="todo",text="I have set a spell over the crystal",length=2},
        {file="todo",text="You cannot remove it until I am dead",length=3},
    },
    you_won={
        {file="todo",text="",length=2},
        {file="todo",text="At last!",length=0.7},
        {file="todo",text="The crystal has been returned safely!",length=2},
        {file="todo",text="Thank you, young wizard, for your excellent service.",length=3},
        {file="todo",text="The sun shall never again be blotted out by the darkness,",length=3},
    }
}


regulus_story.win=function(player)
    if player:get_meta():get_int("finished")==0 then
        player:get_meta():set_int("finished",1)
        local total_time=(minetest.get_us_time()-player:get_meta():get_float("start_time"))/10^6
        minetest.chat_send_all("You completed the game in "..total_time.." seconds")
        --regulus_mapgen.load_level(player,"you_won")

        minetest.after(0.3,function()
            player:set_sky({
                base_color="#FFFFFF",
                type="regular",
                sky_color={
                    day_sky="#61b5f5",
                    day_horizon="#b4bafa",
                    
                }
            })
            player:set_sun({
                visible=true,
                sunrise_visible=false,
            })
            player:override_day_night_ratio(nil)
            minetest.set_timeofday(0.5)
            regulus_story.trigger_dialogue(player, "you_won")
        end)
    end
end

minetest.register_on_newplayer(function(player)
    minetest.chat_send_player(player:get_player_name(),"Game starts now, at "..tostring(minetest.get_us_time()))
    player:get_meta():set_float("start_time",minetest.get_us_time())
end)

regulus_story.is_dialogue_playing=false

regulus_story.voiceline_length_pause_inbetween=0.5

regulus_story.trigger_voiceline=function(player,voiceline,predelay)
    minetest.after(predelay,function()
        regulus_gui.show_subtitles(player,voiceline.text,voiceline.length)
    end)
end

regulus_story.trigger_dialogue=function(player,dialogue_id,do_after)
    if regulus_story.is_dialogue_playing then
        return
    end
    regulus_story.is_dialogue_playing=true
    local total_delay=0
    for _,voiceline in ipairs(regulus_story.dialogues[dialogue_id]) do
        regulus_story.trigger_voiceline(player,voiceline,total_delay)
        --minetest.chat_send_all(dump(voiceline))
        total_delay=total_delay+voiceline.length+regulus_story.voiceline_length_pause_inbetween
    end
    minetest.after(total_delay,function()
        regulus_story.is_dialogue_playing=false
        player:get_meta():set_int("dialogue_"..dialogue_id,1)
        if do_after then
            do_after()
        end
    end)
end

minetest.register_node("regulus_story:crystal",{
    description="Crystal",
    drawtype="mesh",
    mesh="regulus_crystal.obj",
    tiles={"regulus_crystal.png"},
    collision_box={
        type="fixed",
        fixed={
            {-0.7,-0.2,-0.2,0.7,0.2,0.2},
            {-0.2,-0.2,-0.7,0.2,0.2,0.7},
            {-0.2,-0.7,-0.2,0.2,0.7,0.2},
            {-0.5,-0.5,-0.5,0.5,0.5,0.5},
        },
    },
    after_dig_node=function(pos,oldnode,oldmeta,digger)
        mod_storage:set_int("crystal_taken",1)
        digger:get_meta():set_int("crystal_taken",1)
        minetest.chat_send_all(dump({"Yelloooo",digger:get_meta():get_int("crystal_taken")}))
    end,

    groups={diggable=1,crystal=1},
})


minetest.register_node("regulus_story:unbreakable_crystal",{
    description="Unbreakable Crystal",
    drawtype="mesh",
    mesh="regulus_crystal.obj",
    tiles={"regulus_crystal.png"},
    collision_box={
        type="fixed",
        fixed={
            {-0.7,-0.2,-0.2,0.7,0.2,0.2},
            {-0.2,-0.2,-0.7,0.2,0.2,0.7},
            {-0.2,-0.7,-0.2,0.2,0.7,0.2},
            {-0.5,-0.5,-0.5,0.5,0.5,0.5},
        },
    },
    on_punch=function(pos,node,puncher)
        if puncher:get_meta():get_int("dialogue_bossfight_try_dig_crystal")~=1 then
            regulus_story.trigger_dialogue(puncher,"bossfight_try_dig_crystal")
        end
    end,
    groups={undiggable=1,crystal=1},
})

minetest.register_node("regulus_story:crystal_pedistal_original",{
    description="crystal pedistal original full",
    tiles={"regulus_pedistal.png"},
    drawtype="mesh",
    mesh="regulus_pedistal.obj",
    on_rightclick=function(pos,node,clicker,itemstack,pointed_thing)
    end,
    on_construct=function(pos)
        minetest.set_node(pos+vector.new(0,1,0),{name="regulus_story:crystal"})
    end,
    groups={undiggable=1},
    use_texture_alpha=true,
    paramtype="light",
    light_source=14,
})

minetest.register_node("regulus_story:crystal_pedistal_original_empty",{
    description="crystal pedistal original empty",
    tiles={"regulus_pedistal.png"},
    drawtype="mesh",
    mesh="regulus_pedistal.obj",
    on_rightclick=function(pos,node,clicker,itemstack,pointed_thing)
    end,
    groups={undiggable=1,not_in_creative_inventory=1},
    paramtype="light",
    light_source=14,
})


minetest.register_node("regulus_story:crystal_pedistal_finish_empty",{
    description="crystal pedistal finish empty",
    tiles={"regulus_pedistal.png"},
    drawtype="mesh",
    mesh="regulus_pedistal.obj",
    on_rightclick=function(pos,node,clicker,itemstack,pointed_thing)
        minetest.chat_send_all(dump(itemstack:to_string()))
        if itemstack:get_name()=="regulus_story:crystal" then
            minetest.chat_send_all("Well done, player! you won!")
            minetest.set_node(pos+vector.new(0,1,0),{name="regulus_story:unbreakable_crystal"})
            minetest.set_node(pos,{name="regulus_story:crystal_pedistal_finish_full"})
            itemstack:clear()
            regulus_story.win(clicker)

            minetest.add_entity(pos,"regulus_story:crystal_laser")
            minetest.add_entity(pos,"regulus_story:crystal_laser_backward")
            
            minetest.add_particlespawner({
                amount=20,
                time=1,
                pos=pos,
                texture={
                    name="regulus_crystal_sparkle1.png",
                    scale=5,
                    alpha_tween={1,0},
                },
                vel={
                    min=vector.new(-10,-1,-10),
                    max=vector.new(10,1,10),
                }
            })
        end
    end,
    groups={undiggable=1},
    paramtype="light",
    light_source=14,
})

minetest.register_node("regulus_story:crystal_pedistal_finish_full",{
    description="crystal pedistal finish full",
    tiles={"regulus_pedistal.png"},
    drawtype="mesh",
    mesh="regulus_pedistal.obj",
    on_rightclick=function(pos,node,clicker,itemstack,pointed_thing)
    end,
    groups={undiggable=1,not_in_creative_inventory=1},
    paramtype="light",
    light_source=14,
})


minetest.register_node("regulus_story:wand_on_ground",{
    description="wand stand finish full",
    tiles={"regulus_wood2.png"},
    drawtype="nodebox",
    node_box={
        type="fixed",
        fixed={
            {-0.7,-0.5,-0.05,0.7,-0.4,0.05},
        }
    },
    on_punch=function(pos,node,clicker)
        clicker:get_inventory():add_item("main",ItemStack("regulus_tools:test"))
        minetest.set_node(pos,{name="air"})
        if minetest.get_node(pos-vector.new(0,1,0)).name=="regulus_story:wand_stand_full" then
            minetest.set_node(pos-vector.new(0,1,0),{name="regulus_story:wand_stand_empty"})
        end
        clicker:get_meta():set_int("has_wand",1)
    end,
    groups={undiggable=1},
    paramtype="light",
    paramtype2="facedir",
    light_source=14,
})
minetest.register_node("regulus_story:wand_stand_full",{
    description="wand stand finish full",
    tiles={"regulus_wand_stand.png"},
    groups={undiggable=1},
    paramtype="facedir",
    paramtype="light",
    light_source=14,
})
minetest.register_node("regulus_story:wand_stand_empty",{
    description="wand stand finish empty",
    tiles={"regulus_stone2.png"},
    groups={undiggable=1,not_in_creative_inventory=1},
    paramtype="facedir",
})


minetest.register_entity("regulus_story:crystal_laser",{
    visual="mesh",
    mesh="crystal_laser.obj",
    textures={"regulus_crystal_laser.png"},
    use_texture_alpha=true,
    backface_culling=false,
    automatic_rotate=1,
    shaded=false,
    on_activate=function(self)
        --self.object:set_velocity(vector.new(0,-20,0))
        minetest.after(1.0,function()
            self.object:remove()
        end)
    end,
})

minetest.register_entity("regulus_story:crystal_laser_backward",{
    visual="mesh",
    mesh="crystal_laser.obj",
    textures={"regulus_crystal_laser.png"},
    use_texture_alpha=true,
    backface_culling=false,
    automatic_rotate=-1,
    shaded=false,
    on_activate=function(self)
        --self.object:set_velocity(vector.new(0,-20,0))
        minetest.after(1.0,function()
            self.object:remove()
        end)
    end,
})