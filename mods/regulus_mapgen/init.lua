regulus_mapgen={}



for i=1,4 do
    minetest.register_node("regulus_mapgen:spawnpoint"..tostring(i),{
        description="node for setting the spawnpoint"..tostring(i).." in a map",
        tiles={"regulus_transparent_white.png^[multiply:#101010"},
        drawtype="nodebox",
        node_box={
            type="fixed",
            fixed={-0.5,-0.5,-0.5,0.5,-0.4,0.5},
        },
        paramtype="light",
        use_texture_alpha=true,
        after_place_node=function(pos,placer,itemstack,pointed_thing)
            placer:get_meta():set_string("spawnpoint"..tostring(i),minetest.serialize(pos))
            minetest.chat_send_all("spawnpoint"..tostring(i).." set to "..dump(pos))
        end,
        on_punch=function(pos,node,puncher,pointed_thing)
            puncher:get_meta():set_string("spawnpoint"..tostring(i),minetest.serialize(pos))
            minetest.chat_send_all("spawnpoint"..tostring(i).." set to "..dump(pos))
        end,
        after_dig_node=function(pos,oldnode,oldmetadata,digger)
            digger:get_meta():set_string("spawnpoint"..tostring(i),"")
            minetest.chat_send_all("spawnpoint"..tostring(i).." erased")
        end,
        groups={undiggable=1}
    })
end

minetest.register_node("regulus_mapgen:pos1",{
    description="node for setting the pos1 for a map schematic",
    tiles={"regulus_transparent_white.png^[multiply:#10ffff"},
    use_texture_alpha=true,
    after_place_node=function(pos,placer,itemstack,pointed_thing)
        placer:get_meta():set_string("pos1",minetest.serialize(pos))
        minetest.chat_send_all("pos1 set to "..dump(pos))
    end,
    on_punch=function(pos,node,puncher,pointed_thing)
        puncher:get_meta():set_string("pos1",minetest.serialize(pos))
        minetest.chat_send_all("pos1 set to "..dump(pos))
    end,
    groups={undiggable=1}
})

minetest.register_node("regulus_mapgen:pos2",{
    description="node for setting the pos2 for a map schematic",
    tiles={"regulus_transparent_white.png^[multiply:#ffff10"},
    use_texture_alpha=true,
    after_place_node=function(pos,placer,itemstack,pointed_thing)
        placer:get_meta():set_string("pos2",minetest.serialize(pos))
        minetest.chat_send_all("pos2 set to "..dump(pos))
    end,
    on_punch=function(pos,node,puncher,pointed_thing)
        puncher:get_meta():set_string("pos2",minetest.serialize(pos))
        minetest.chat_send_all("pos2 set to "..dump(pos))
    end,
    groups={undiggable=1}
})

--a room can have at most four doors; one exit to prev room, three to next rooms.
local map_trigger_node_colors={"#ffffff","#ffffff","#aaaaaa","#555555"}
for i,name in pairs({"exit","next1","next2","next3"}) do
    minetest.register_node("regulus_mapgen:"..name,{
        description="Trigger "..name,
        tiles={"regulus_transparent_white.png^[multiply:"..map_trigger_node_colors[i]},
        groups={undiggable=1},
        walkable=false,
        drawtype="glasslike",
        use_texture_alpha=true,
        after_place_node=function(pos,placer,itemstack,pointed_thing)
            --placer:get_meta():set_string(name,minetest.serialize(pos))
            --minetest.chat_send_all(name.." set to "..dump(pos))
        end,
        on_punch=function(pos,node,puncher,pointed_thing)
            --placer:get_meta():set_string(name,minetest.serialize(pos))
            --minetest.chat_send_all(name.." set to "..dump(pos))
        end
    })
end

for _,triggername in pairs({"exit","next1","next2","next3"}) do
    minetest.register_chatcommand("set_"..triggername,{
        description="set the level to which the "..triggername.." trigger nodes will spawn you",
        func=function(name,param)
            local player=minetest.get_player_by_name(name)
            player:get_meta():set_string(triggername,param)
            minetest.chat_send_all(triggername.." level set to "..param)
        end
    })
    minetest.register_chatcommand("get_"..triggername,{
        description="get the level to which the "..triggername.." trigger nodes will spawn you",
        func=function(name,param)
            local player=minetest.get_player_by_name(name)
            
            minetest.chat_send_all(triggername.." level is set to:"..player:get_meta():get_string(triggername))
        end
    })
end
minetest.register_chatcommand("set_exit_num",{
    description="set which entrance number the exit goes to",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        player:get_meta():set_int("exit_spawnpoint_num",tonumber(param))
        minetest.chat_send_all("exit number level set to "..param)
    end
})
minetest.register_chatcommand("get_exit_num",{
    description="get which entrance number the exit goes to",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        minetest.chat_send_all("exit number level set to"..tostring(player:get_meta():get_int("exit_spawnpoint_num")))
    end
})

minetest.register_chatcommand("save_level",{
    description="save the area between the two pos1 and pos2 nodes as a schematic with the level name as the param",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        local meta=player:get_meta()
        local pos1=minetest.deserialize(meta:get_string("pos1"))
        local pos2=minetest.deserialize(meta:get_string("pos2"))
        local global_spawnpoint1=minetest.deserialize(meta:get_string("spawnpoint1"))
        local global_spawnpoint2=minetest.deserialize(meta:get_string("spawnpoint2")) or global_spawnpoint1
        local global_spawnpoint3=minetest.deserialize(meta:get_string("spawnpoint3")) or global_spawnpoint1
        local global_spawnpoint4=minetest.deserialize(meta:get_string("spawnpoint4")) or global_spawnpoint1
        local minpos=vector.new(math.min(pos1.x,pos2.x),math.min(pos1.y,pos2.y),math.min(pos1.z,pos2.z))
        local maxpos=vector.new(math.max(pos1.x,pos2.x),math.max(pos1.y,pos2.y),math.max(pos1.z,pos2.z))
        minetest.create_schematic(pos1,pos2,{},minetest.get_modpath("regulus_mapgen").."/schems/"..param..".mts")

        local level_settings={
            spawnpoint1=global_spawnpoint1-minpos,
            spawnpoint2=global_spawnpoint2-minpos,
            spawnpoint3=global_spawnpoint3-minpos,
            spawnpoint4=global_spawnpoint4-minpos,
            exit=meta:get_string("exit"),
            next1=meta:get_string("next1"),
            next2=meta:get_string("next2"),
            next3=meta:get_string("next3"),
            exit_spawnpoint_num=meta:get_int("exit_spawnpoint_num"),
        }
        local file=io.open(minetest.get_modpath("regulus_mapgen").."/level_settings/"..param..".lua","w")
        if file then
            file:write(minetest.serialize(level_settings))
            file:close()
        else
            minetest.chat_send_all("Error "..dump(err).."while saving level to file")
        end
    end

})

regulus_mapgen.load_level=function(player,levelname)
    minetest.place_schematic(
        vector.new(0,0,0),
        minetest.get_modpath("regulus_mapgen").."/schems/"..levelname..".mts"
    )
    local level_settings=dofile(minetest.get_modpath("regulus_mapgen").."/level_settings/"..levelname..".lua")--minetest.deserialize(storage:get_string(levelname.."_relative_spawnpoint"))
    --minetest.chat_send_all("hello"..dump(level_settings))
    local respawn_pos=level_settings["spawnpoint"..tostring(level_settings.spawnpoint_num)]
    if force_spawnpoint_num~=nil then
        respawn_pos=level_settings["spawnpoint"..tostring(force_spawnpoint_num)]
    end
    player:set_pos(respawn_pos)

    local meta=player:get_meta()
    meta:set_string("respawn_pos",minetest.serialize(level_settings.spawnpoint))
    meta:set_string("exit",level_settings.exit)
    meta:set_string("next1",level_settings.next1)
    meta:set_string("next2",level_settings.next2)
    meta:set_string("next3",level_settings.next3)
end


minetest.register_chatcommand("load_level",{
    description="load the area of the given name",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        regulus_mapgen.load_level(player,param)
    end
})



regulus_mapgen.exit_level=function(player,oldlevel)
    local exit_level_name=player:get_meta():get_string("exit")
    local spawnpoint_num=player:get_meta():get_int("exit_spawnpoint_num")
    if exit_level_name~="" then
        if spawnpoint_num~=0 then
            regulus_mapgen.load_level(player,exit_level_name)
        else
            regulus_mapgen.load_level(player,1)
        end
    else
        minetest.chat_send_all("ERROR, exit level not set")
    end
end

--second param is whether you want to go to next1, next2, or next3
regulus_mapgen.next_level=function(player,number)
    local next_level_name=player:get_meta():get_string("next"..tostring(number))
    if next_level_name~="" then
        regulus_mapgen.load_level(player,next_level_name,1)--spawnpoint 1 for right next to exit
    else
        minetest.chat_send_all("ERROR, next"..tostring(number).." level not set")
    end
end




minetest.register_on_newplayer(function(player)
    --regulus_mapgen.load_level(player,"main")
    player:get_inventory():add_item("main",ItemStack("regulus_tools:test"))
end)