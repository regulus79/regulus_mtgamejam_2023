--todo
regulus_story={}


regulus_story.dialogues={
    greeting={
        {file="todo",text="Why hello everyone",length=1},
        {file="todo",text="Why hello everyone this fine evening",length=2}
    }
}


regulus_story.win=function(player)
    if player:get_meta():get_int("finished")==0 then
        player:get_meta():set_int("finished",1)
        local total_time=(minetest.get_us_time()-player:get_meta():get_float("start_time"))/10^6
        minetest.chat_send_all("You completed the game in "..total_time.." seconds")
        regulus_mapgen.load_level(player,"you_won")
    end
end

minetest.register_on_newplayer(function(player)
    minetest.chat_send_player(player:get_player_name(),"Game starts now, at "..tostring(minetest.get_us_time()))
    player:get_meta():set_float("start_time",minetest.get_us_time())
end)

regulus_story.voiceline_length_pause_inbetween=1

regulus_story.trigger_voiceline=function(player,voiceline,predelay)
    minetest.after(predelay,function()
        regulus_gui.show_subtitles(player,voiceline.text,voiceline.length)
    end)
end

regulus_story.trigger_dialogue=function(player,dialogue_id)
    local total_delay=0
    for _,voiceline in ipairs(regulus_story.dialogues[dialogue_id]) do
        regulus_story.trigger_voiceline(player,voiceline,total_delay)
        minetest.chat_send_all(dump(voiceline))
        total_delay=total_delay+voiceline.length+regulus_story.voiceline_length_pause_inbetween
    end
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
    groups={diggable=1},
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
    groups={undiggable=1},
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