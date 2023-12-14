minetest.register_chatcommand("setblock",{
    description="set the block you are in to the blockname you give the command",
    func=function(name,param)
        if param and minetest.registered_nodes[param] then
            local player=minetest.get_player_by_name(name)
            minetest.set_node(player:get_pos(),{name=param})
        end
    end
})

minetest.register_chatcommand("fill_inv",{
    description="give yourself every block in existance",
    func=function(name,param)
        --minetest.chat_send_all(dump(minetest.registered_nodes))
        for nodename,node_def in pairs(minetest.registered_nodes) do
            if not node_def.groups["not_in_creative_inventory"] and not minetest.get_player_by_name(name):get_inventory():contains_item("main",nodename) then
                minetest.get_player_by_name(name):get_inventory():add_item("main",ItemStack(nodename.." 99"))
            end
        end
    end
})

minetest.register_chatcommand("respawn",{
    description="respawn to the pos in your meta, else do nothing if no meta",
    func=function(name,param)
        local meta=minetest.get_player_by_name(name):get_meta()
        if meta~="" then
            minetest.get_player_by_name(name):set_pos(minetest.deserialize(meta:get_string("respawn_pos")))
        end
    end
})

minetest.register_tool("regulus_admintools:dig",{
    description="dig blocks",
    tool_capabilities={
        groupcaps={
            undiggable={maxlevel=1,times={0.2}}
        }
    }
})

if minetest.is_creative_enabled() then
    minetest.register_tool(":",{
        description="hand",
        wield_image="regulus_hand.png",
        tool_capabilities={
            groupcaps={
                undiggable={maxlevel=1,times={0.2}},
                diggable={maxlevel=1,times={0.5}}
            },
            damage_groups={
                fleshy=5,
            }
        }
    })
else
    minetest.register_tool(":",{
        description="hand",
        wield_image="regulus_hand.png",
        tool_capabilities={
            groupcaps={
                diggable={maxlevel=1,times={0.5}}
            },
            damage_groups={
                fleshy=5,
            }
        }
    })
end