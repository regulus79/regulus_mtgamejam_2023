local mod_storage=minetest.get_mod_storage()


minetest.register_node("regulus_nodes:testnode",{
    description="testnode",
    tiles={"regulus_wood1.png"},
    groups={undiggable=1},
})

minetest.register_node("regulus_nodes:wood",{
    description="wood",
    tiles={"regulus_wood1.png"},
    groups={undiggable=1},
})

for i=1,5 do
    minetest.register_node("regulus_nodes:stone"..tostring(i),{
        description="stone"..tostring(i),
        tiles={"regulus_stone"..tostring(i)..".png"},
        groups={undiggable=1},
    })
end

minetest.register_node("regulus_nodes:x_panel",{
    description="x panel",
    tiles={"regulus_x_panel.png"},
    groups={undiggable=1},
})

minetest.register_node("regulus_nodes:blank_panel",{
    description="blank panel",
    tiles={"regulus_blank_panel.png"},
    groups={undiggable=1},
})

minetest.register_node("regulus_nodes:hex_panel1",{
    description="hex panel1",
    tiles={"regulus_hex_panel1.png"},
    groups={undiggable=1},
})

minetest.register_node("regulus_nodes:cp",{
    description="checkpoint",
    tiles={"regulus_cp1.png"},
    drawtype="nodebox",
    node_box={
        type="fixed",
        fixed={
            {-0.5,-0.5,-0.5,0.5,-0.4,0.5},
            {-0.1,-0.5,-0.1,0.1,0.2,0.1},
            {-0.2,0.2,-0.2,0.2,0.5,0.2}
        }
    },
    paramtype="light",
    on_punch=function(pos,node,clicker)
        local meta=clicker:get_meta()
        meta:set_string("respawn_pos",minetest.serialize(pos))
        --minetest.chat_send_player(clicker:get_player_name(),"Progress Saved")
        regulus_gui.splash_text_effect(clicker,"Progress Saved","#444444")
        --play sound
        minetest.sound_play("regulus_checkpoint",{to_player=clicker:get_player_name()},true)
    end,
    groups={undiggable=1},
})

minetest.register_on_dieplayer(function(player,reason)
    --minetest.chat_send_all(dump(reason))
    local meta=player:get_meta():get_string("respawn_pos")
    if meta~="" then
        player:set_pos(minetest.deserialize(meta))
    end
end)

minetest.register_on_respawnplayer(function(player)
    local meta=player:get_meta():get_string("respawn_pos")
    if meta~="" then
        player:set_pos(minetest.deserialize(meta))
        return true
    end
end)

minetest.register_node("regulus_nodes:square_window",{
    description="square_window",
    tiles={"regulus_square_window.png"},
    drawtype="glasslike",
    paramtype="light",
    groups={undiggable=1},
    use_texture_alpha=true,
    sunlight_propagates=true,
})

minetest.register_node("regulus_nodes:v_panel",{
    description="v panel",
    tiles={"regulus_v_panel.png"},
    groups={undiggable=1},
})

for i=1,2 do
    minetest.register_node("regulus_nodes:evil_panel"..tostring(i),{
        description="evil panel"..tostring(i),
        tiles={"regulus_evil_panel"..tostring(i)..".png"},
        groups={undiggable=1},
    })
end

minetest.register_node("regulus_nodes:darkness",{
    description="darkness",
    tiles={"regulus_v_panel.png^[multiply:#000000"},
    groups={undiggable=1},
})


minetest.register_node("regulus_nodes:killzone",{
    description="killzone",
    tiles={"regulus_transparent_white.png^[multiply:#007700"},
    drawtype="glasslike",
    paramtype="light",
    use_texture_alpha=true,
    pointable=minetest.is_creative_enabled(),
    groups={undiggable=1},
    walkable=false,
})

minetest.register_node("regulus_nodes:winzone",{
    description="win zone",
    tiles={"regulus_transparent_white.png^[multiply:#00ff00"},
    paramtype="light",
    drawtype="glasslike",
    paramtype="light",
    use_texture_alpha=true,
    groups={undiggable=1},
    walkable=false,
})

for powerupname,settings in pairs(regulus_powerups.list_of_powerups) do
    minetest.register_node("regulus_nodes:"..powerupname.."_powerup_visible",{
        description=powerupname.." powerup zone visible",
        tiles={"regulus_transparent_white.png^[multiply:"..settings.color.."^[opacity:200"},
        drawtype="glasslike",
        paramtype="light",
        use_texture_alpha=true,
        pointable=minetest.is_creative_enabled(),
        groups={undiggable=1},
        walkable=false,
    })
    minetest.register_node("regulus_nodes:"..powerupname.."_powerup",{
        description=powerupname.." powerup zone",
        tiles={"regulus_transparent_white.png^[multiply:"..settings.color.."^[opacity:0"},
        drawtype="glasslike",
        paramtype="light",
        pointable=minetest.is_creative_enabled(),
        use_texture_alpha=true,
        groups={undiggable=1},
        walkable=false,
    })
end
--[[
minetest.register_node("regulus_nodes:tiny_powerup",{
    description="tiny powerup zone",
    tiles={"regulus_transparent_white.png^[multiply:#45ff00"},
    drawtype="glasslike",
    paramtype="light",
    use_texture_alpha=true,
    groups={undiggable=1},
    walkable=false,
})]]

minetest.register_globalstep(function(dtime)
    for _,player in pairs(minetest.get_connected_players()) do
        local nodename=minetest.get_node(player:get_pos()).name
        if player:get_pos().y<-10 or nodename=="regulus_nodes:killzone" then
            player:set_hp(0,{reason="set_hp"})
        end
        local nodename_slightly_above=minetest.get_node(player:get_pos()+vector.new(0,0.1,0)).name
        for powerupname,settings in pairs(regulus_powerups.list_of_powerups) do
            if nodename_slightly_above=="regulus_nodes:"..powerupname.."_powerup" or nodename_slightly_above=="regulus_nodes:"..powerupname.."_powerup_visible" then
                local old_powerup=player:get_meta():get_string("powerup")
                if old_powerup~=powerupname then
                    player:get_meta():set_string("powerup",powerupname)
                    --regulus_gui.splash_text_effect(player,settings.motto,settings.color)
                    minetest.sound_play({name="thx",gain=0.04},{pos=player:get_pos()},true)
                    minetest.add_particlespawner({
                        amount=30,
                        time=0.5,
                        texture="regulus_spark.png",
                        vel={
                            min=vector.new(-1,-1,-1)+player:get_velocity(),
                            max=vector.new(1,1,1)+player:get_velocity(),
                        },
                        acc=vector.new(0,-1,0),
                        pos=player:get_pos()+vector.new(0,1.625,0)+player:get_look_dir(),
                    })
                end
            end
        end
        if nodename_slightly_above=="regulus_nodes:winzone" then
            regulus_story.win(player)
        end
        if nodename_slightly_above=="regulus_mapgen:exit" then
            regulus_mapgen.exit_level(player)
        elseif nodename_slightly_above=="regulus_mapgen:next1" then
            regulus_mapgen.next_level(player,1)
        elseif nodename_slightly_above=="regulus_mapgen:next2" then
            regulus_mapgen.next_level(player,2)
        elseif nodename_slightly_above=="regulus_mapgen:next3" then
            regulus_mapgen.next_level(player,3)
        end
    end
end)


for nodename,texture_name in pairs({
    ["blank_panel"]="regulus_blank_panel_stair.png",
    ["stone1"]="regulus_stone1.png",
    ["stone4"]="regulus_stone4.png",
    ["stone5"]="regulus_stone5.png",
    ["wood1"]="regulus_wood1.png",
    ["v_panel"]="regulus_v_panel.png",
    ["evil_panel1"]="regulus_evil_panel1.png",
}) do
    minetest.register_node("regulus_nodes:"..nodename.."_stair",{
        description=nodename.." stair",
        tiles={texture_name},
        drawtype="nodebox",
        node_box={
            type="fixed",
            fixed={
                {-0.5,-0.5,-0.5,0.5,0,0.5},
                {-0.5,0,0,0.5,0.5,0.5}
            }
        },
        paramtype="light",
        paramtype2="4dir",
        groups={undiggable=1},
    })
    minetest.register_node("regulus_nodes:"..nodename.."_inner_stair",{
        description=nodename.." stair",
        tiles={texture_name},
        drawtype="nodebox",
        node_box={
            type="fixed",
            fixed={
                {-0.5,-0.5,-0.5,0.5,0,0.5},
                {-0.5,0,0,0.5,0.5,0.5},
                {0,0,-0.5,0.5,0.5,0}
            }
        },
        paramtype="light",
        paramtype2="4dir",
        groups={undiggable=1},
    })

    minetest.register_node("regulus_nodes:"..nodename.."_outer_stair",{
        description=nodename.." stair",
        tiles={texture_name},
        drawtype="nodebox",
        node_box={
            type="fixed",
            fixed={
                {-0.5,-0.5,-0.5,0.5,0,0.5},
                {0,0,0,0.5,0.5,0.5}
            }
        },
        paramtype="light",
        paramtype2="4dir",
        groups={undiggable=1},
    })
end

minetest.register_node("regulus_nodes:blank_panel_hole",{
    description="blank panel hole",
    tiles={"regulus_blank_panel_stair.png"},
    drawtype="nodebox",
    node_box={
        type="fixed",
        fixed={
            {-0.5,-0.5,-0.5,0.5,-0.3,0.5},
            {-0.5,0.3,-0.5,0.5,0.5,0.5},
            {-0.5,-0.5,-0.5,-0.3,0.5,0.5},
            {0.3,-0.5,-0.5,0.5,0.5,0.5},
        }
    },
    paramtype="light",
    paramtype2="4dir",
    groups={undiggable=1},
})


minetest.register_node("regulus_nodes:blank_panel_vertical_hole",{
    description="blank panel vertical hole",
    tiles={"regulus_blank_panel_stair.png"},
    drawtype="nodebox",
    node_box={
        type="fixed",
        fixed={
            {-0.5,-0.5,-0.2,0.5,0.5,-0.5},
            {-0.5,-0.5,0.2,0.5,0.5,0.5},
            {-0.5,-0.5,-0.5,-0.2,0.5,0.5},
            {0.2,-0.5,-0.5,0.5,0.5,0.5},
        }
    },
    paramtype="light",
    paramtype2="4dir",
    groups={undiggable=1},
})

minetest.register_node("regulus_nodes:lantern",{
    description="Lantern",
    drawtype="nodebox",
    node_box={
        type="fixed",
        fixed={
            {-0.2,-0.5,-0.2,0.2,0.2,0.2},
        }
    },
    tiles={"regulus_wood1.png","regulus_wood1.png","regulus_lantern.png"},

    paramtype="light",
    light_source=10,
    groups={undiggable=1},

})


minetest.register_node("regulus_nodes:lantern2",{
    description="Lantern",
    drawtype="nodebox",
    node_box={
        type="fixed",
        fixed={
            {-0.2,-0.2,-0.2,0.2,0.2,0.2},
            {-0.1,0,-0.1,0.1,0.5,0.1},
        }
    },
    tiles={"regulus_lantern2.png"},

    paramtype="light",
    light_source=14,
    groups={undiggable=1},

})

minetest.register_node("regulus_nodes:lantern2_good",{
    description="Lantern Good",
    drawtype="nodebox",
    node_box={
        type="fixed",
        fixed={
            {-0.2,-0.2,-0.2,0.2,0.2,0.2},
            {-0.1,0,-0.1,0.1,0.5,0.1},
        }
    },
    tiles={"regulus_lantern2_good.png"},

    paramtype="light",
    light_source=14,
    groups={undiggable=1},

})

minetest.register_abm({
    label="replace green ligths with yellow",
    nodenames={"regulus_nodes:lantern2"},
    interval=1,
    chance=1,
    action=function(pos)
        for _,player in pairs(minetest.get_connected_players()) do 
            if player:get_meta():get_int("crystal_taken",1)==1 then
                minetest.set_node(pos,{name="regulus_nodes:lantern2_good"})
            end
        end
    end
})


minetest.register_node("regulus_nodes:lantern3",{
    description="Lantern",
    drawtype="nodebox",
    node_box={
        type="fixed",
        fixed={
            {-0.1,-0.5,-0.1,0.1,0.5,0.1},
        }
    },
    tiles={"regulus_lantern3.png"},

    paramtype="light",
    light_source=14,
    groups={undiggable=1},

})

minetest.register_node("regulus_nodes:bookshelf",{
    description="bookshelf",
    tiles={"regulus_wood2.png","regulus_wood2.png","regulus_bookshelf1.png"},
    groups={undiggable=1},
})