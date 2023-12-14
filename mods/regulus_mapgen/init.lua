regulus_mapgen={}

local mod_storage=minetest.get_mod_storage()

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
            if minetest.is_creative_enabled() then
                placer:get_meta():set_string("spawnpoint"..tostring(i),minetest.serialize(pos))
                minetest.chat_send_all("spawnpoint"..tostring(i).." set to "..dump(pos))
            end
        end,
        on_punch=function(pos,node,puncher,pointed_thing)
            if minetest.is_creative_enabled() then
                puncher:get_meta():set_string("spawnpoint"..tostring(i),minetest.serialize(pos))
                minetest.chat_send_all("spawnpoint"..tostring(i).." set to "..dump(pos))
            end
        end,
        after_dig_node=function(pos,oldnode,oldmetadata,digger)
            if minetest.is_creative_enabled() then
                digger:get_meta():set_string("spawnpoint"..tostring(i),"")
                minetest.chat_send_all("spawnpoint"..tostring(i).." erased")
            end
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
        if minetest.is_creative_enabled() then
            puncher:get_meta():set_string("pos1",minetest.serialize(pos))
            minetest.chat_send_all("pos1 set to "..dump(pos))
        end
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
        if minetest.is_creative_enabled() then
            puncher:get_meta():set_string("pos2",minetest.serialize(pos))
            minetest.chat_send_all("pos2 set to "..dump(pos))
        end
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
minetest.register_chatcommand("set_level_name",{
    description="set the name of the current level. this will the be name of the schematic file and level_settings file",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        player:get_meta():set_string("level_name",param)
        minetest.chat_send_all("level_name set to "..param)
    end
})
minetest.register_chatcommand("get_exit_num",{
    description="get which entrance number the exit goes to",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        minetest.chat_send_all("exit number level set to"..tostring(player:get_meta():get_int("exit_spawnpoint_num")))
    end
})

minetest.register_chatcommand("clear_map_meta",{
    description="clear all of the meta data regarding the map, like spawnposes and pos1/pos2 stuff",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        local meta=player:get_meta()
        meta:set_int("exit_spawnpoint_num",0)
        meta:set_string("exit","")
        meta:set_string("next1","")
        meta:set_string("next2","")
        meta:set_string("next3","")
        meta:set_string("spawnpoint1","")
        meta:set_string("spawnpoint2","")
        meta:set_string("spawnpoint3","")
        meta:set_string("spawnpoint4","")
        meta:set_string("pos1","")
        meta:set_string("pos2","")
    end
})

minetest.register_chatcommand("get_map_meta",{
    description="get the level settings table",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        local meta=player:get_meta()
        minetest.chat_send_all(dump(
            {
                exit_spawnpoint_num=meta:get_int("exit_spawnpoint_num"),
                exit=meta:get_string("exit"),
                next1=meta:get_string("next1"),
                next2=meta:get_string("next2"),
                next3=meta:get_string("next3"),
                spawnpoint1=meta:get_string("spawnpoint1"),
                spawnpoint2=meta:get_string("spawnpoint2"),
                spawnpoint3=meta:get_string("spawnpoint3"),
                spawnpoint4=meta:get_string("spawnpoint4"),
                pos1=meta:get_string("pos1"),
                pos2=meta:get_string("pos2"),
                level_name=meta:get_string("level_name"),
            }
        ))
    end
})

minetest.register_chatcommand("save_level",{
    description="save the area between the two pos1 and pos2 nodes as a schematic with the current level data",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        local meta=player:get_meta()
        local level_name=meta:get_string("level_name")
        local pos1=minetest.deserialize(meta:get_string("pos1"))
        local pos2=minetest.deserialize(meta:get_string("pos2"))
        local global_spawnpoint1=minetest.deserialize(meta:get_string("spawnpoint1"))
        local global_spawnpoint2=minetest.deserialize(meta:get_string("spawnpoint2")) or global_spawnpoint1
        local global_spawnpoint3=minetest.deserialize(meta:get_string("spawnpoint3")) or global_spawnpoint1
        local global_spawnpoint4=minetest.deserialize(meta:get_string("spawnpoint4")) or global_spawnpoint1
        local minpos=vector.new(math.min(pos1.x,pos2.x),math.min(pos1.y,pos2.y),math.min(pos1.z,pos2.z))
        local maxpos=vector.new(math.max(pos1.x,pos2.x),math.max(pos1.y,pos2.y),math.max(pos1.z,pos2.z))
        minetest.create_schematic(pos1,pos2,{},minetest.get_modpath("regulus_mapgen").."/schems/"..level_name..".mts")

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
            extent=maxpos-minpos,
            level_name=level_name,
        }
        minetest.safe_file_write(minetest.get_modpath("regulus_mapgen").."/level_settings/"..level_name..".lua",minetest.serialize(level_settings))
    end

})

local level_finished_loading=true

regulus_mapgen.load_level=function(player,levelname,spawnpoint_num)
    if not level_finished_loading then
        minetest.after(1,function()
            level_finished_loading=true
        end)
        return
    end
    local does_level_exist,level_settings=pcall(dofile,minetest.get_modpath("regulus_mapgen").."/level_settings/"..levelname..".lua")
    if not does_level_exist then
        minetest.chat_send_all("Level "..levelname.." does not exist")
        return
    end
    --minetest.chat_send_all(dump(level_settings))
    
    local random_level_spawn_pos=vector.new(math.random(-300,300),0,math.random(-300,300))

    level_finished_loading=false

    minetest.place_schematic(
        random_level_spawn_pos,
        minetest.get_modpath("regulus_mapgen").."/schems/"..levelname..".mts"
    )
    local respawn_pos=level_settings.spawnpoint1
    if spawnpoint_num then
        respawn_pos=level_settings["spawnpoint"..tostring(spawnpoint_num)]
        --minetest.chat_send_all("spawnpoint"..tostring(spawnpoint_num))
    end
    player:set_pos(respawn_pos+random_level_spawn_pos)

    local meta=player:get_meta()
    meta:set_string("respawn_pos",minetest.serialize(respawn_pos+random_level_spawn_pos))
    meta:set_string("exit",level_settings.exit)
    meta:set_string("exit_spawnpoint_num",level_settings.exit_spawnpoint_num)
    meta:set_string("next1",level_settings.next1)
    meta:set_string("next2",level_settings.next2)
    meta:set_string("next3",level_settings.next3)
    meta:set_string("pos1",minetest.serialize(random_level_spawn_pos))
    meta:set_string("pos2",minetest.serialize(random_level_spawn_pos+(level_settings.extent or vector.new(100,100,100))))
    meta:set_string("level_name",level_settings.level_name)
    meta:set_string("spawnpoint1",minetest.serialize(level_settings.spawnpoint1+random_level_spawn_pos))
    meta:set_string("spawnpoint2",minetest.serialize(level_settings.spawnpoint2+random_level_spawn_pos or ""))
    meta:set_string("spawnpoint3",minetest.serialize(level_settings.spawnpoint3+random_level_spawn_pos or ""))
    meta:set_string("spawnpoint4",minetest.serialize(level_settings.spawnpoint4+random_level_spawn_pos or ""))
    minetest.after(1,function()
        level_finished_loading=true
        --minetest.chat_send_all(dump((level_settings.extent or vector.new(100,100,100))))
        minetest.fix_light(random_level_spawn_pos,random_level_spawn_pos+(level_settings.extent or vector.new(100,100,100)))
    end)
end


minetest.register_chatcommand("load_level",{
    description="load the area of the given name",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        regulus_mapgen.load_level(player,param,1)
    end
})



regulus_mapgen.exit_level=function(player,oldlevel)
    if mod_storage:get_int("bossfight_in_progress")==1 then
        return
    end
    local exit_level_name=player:get_meta():get_string("exit")
    local exit_spawnpoint_num=player:get_meta():get_int("exit_spawnpoint_num")
    if exit_level_name~="" then
        if exit_spawnpoint_num~=0 then
            regulus_mapgen.load_level(player,exit_level_name,exit_spawnpoint_num)
        else
            regulus_mapgen.load_level(player,exit_level_name,2)--assuming the prev level had one spawn for the start, and the second spawn by the door to next (this) level
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



