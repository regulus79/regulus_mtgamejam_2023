--make wear cooldown stuff todo

minetest.register_tool("regulus_tools:test",{
    description="test",
    inventory_image="regulus_wand1.png",
    --wield_image="testwield.png",
    wield_scale={x=2,y=2,z=1},
    on_use=function(itemstack,user,pointed_thing)
        minetest.chat_send_all("You used it")
        itemstack:set_wear(0.1)
    end
})