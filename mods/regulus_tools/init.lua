--make wear cooldown stuff todo

minetest.register_tool("regulus_tools:test",{
    description="test",
    inventory_image="regulus_wand1.png",
    --wield_image="testwield.png",
    wield_scale={x=2,y=2,z=1},
    on_use=function(itemstack,user,pointed_thing)
        regulus_powerups.apply_current_powerup(user)
        --if itemstack:get_wear()==0 then
            --itemstack:set_wear(65535)
            --minetest.after(1,function()itemstack:set_wear(10)end)
            --minetest.chat_send_all("You used it"..tostring(itemstack:get_wear()))
            --return itemstack
        --end
    end
})