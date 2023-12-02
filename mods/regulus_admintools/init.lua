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

minetest.register_tool("regulus_admintools:dig",{
    description="dig blocks",
    tool_capabilities={
        groupcaps={
            undiggable={maxlevel=1,times={0.2}}
        }
    }
})