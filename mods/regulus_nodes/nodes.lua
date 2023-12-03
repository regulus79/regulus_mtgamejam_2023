


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

minetest.register_node("regulus_nodes:stone",{
    description="stone",
    tiles={"regulus_stone1.png"},
    groups={undiggable=1},
})

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
    on_punch=function(pos,node,puncher,pointed_thing)
        local meta=puncher:get_meta()
        meta:set_string("respawn_pos",minetest.serialize(pos))
        minetest.chat_send_player(puncher:get_player_name(),"Progress Saved")
    end,
    on_rightclick=function(pos,node,puncher,itemstack,pointed_thing)
        local meta=puncher:get_meta()
        meta:set_string("respawn_pos",minetest.serialize(pos))
        minetest.chat_send_player(puncher:get_player_name(),"Progress Saved")
    end,
    groups={undiggable=1},
})

minetest.register_on_dieplayer(function(player,reason)
    minetest.chat_send_all(dump(reason))
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
})

minetest.register_node("regulus_nodes:v_panel",{
    description="v panel",
    tiles={"regulus_v_panel.png"},
    groups={undiggable=1},
})

minetest.register_node("regulus_nodes:killzone",{
    description="killzone",
    tiles={"regulus_killzone.png"},
    drawtype="nodebox",
    paramtype="light",
    node_box={
        type="fixed",
        fixed={-0.5,-0.5,-0.5,0.5,0,0.5}
    },
    use_texture_alpha=true,
    groups={undiggable=1},
    walkable=true,
})

minetest.register_node("regulus_nodes:fly_powerup",{
    description="fly powerup zone",
    tiles={"regulus_killzone.png"},
    drawtype="glasslike",
    paramtype="light",
    use_texture_alpha=true,
    groups={undiggable=1},
    walkable=false,
})

minetest.register_node("regulus_nodes:tiny_powerup",{
    description="tiny powerup zone",
    tiles={"regulus_killzone.png"},
    drawtype="glasslike",
    paramtype="light",
    use_texture_alpha=true,
    groups={undiggable=1},
    walkable=false,
})

minetest.register_globalstep(function(dtime)
    for _,player in pairs(minetest.get_connected_players()) do
        local nodename=minetest.get_node(player:get_pos()).name
        if player:get_pos().y<-100 or nodename=="regulus_nodes:killzone" then
            player:set_hp(0,{reason="set_hp"})
        end
        local nodename_slightly_above=minetest.get_node(player:get_pos()+vector.new(0,0.1,0)).name
        if nodename_slightly_above=="regulus_nodes:fly_powerup" then
            local old_powerup=player:get_meta():get_string("powerup")
            if old_powerup~="fly" then
                player:get_meta():set_string("powerup","fly")
                minetest.chat_send_all("You can now fly!")
            end
        elseif nodename_slightly_above=="regulus_nodes:tiny_powerup" then
            local old_powerup=player:get_meta():get_string("powerup")
            if old_powerup~="tiny" then
                player:get_meta():set_string("powerup","tiny")
                minetest.chat_send_all("You are now tiny!")
            end
        end
    end
end)