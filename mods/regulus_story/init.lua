--todo
regulus_story={}


regulus_story.voicelines={
    ["hello_everyone"]={file="todo",text="Why hello everyone this fine evening",length=1}
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


regulus_story.trigger_voiceline=function(player,line_id)
    local voiceline_metadata=regulus_story[line_id]
    regulus_gui.show_subtitles(voiceline_metadata.text,voiceline_metadata.length)
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
})

minetest.register_node("regulus_story:crystal_pedistal_original_empty",{
    description="crystal pedistal original empty",
    tiles={"regulus_pedistal.png"},
    drawtype="mesh",
    mesh="regulus_pedistal.obj",
    on_rightclick=function(pos,node,clicker,itemstack,pointed_thing)
    end,
    groups={undiggable=1,not_in_creative_inventory=1},
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
})

minetest.register_node("regulus_story:crystal_pedistal_finish_full",{
    description="crystal pedistal finish full",
    tiles={"regulus_pedistal.png"},
    drawtype="mesh",
    mesh="regulus_pedistal.obj",
    on_rightclick=function(pos,node,clicker,itemstack,pointed_thing)
    end,
    groups={undiggable=1,not_in_creative_inventory=1},
})