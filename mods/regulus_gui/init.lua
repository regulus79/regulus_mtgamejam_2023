regulus_gui={}

regulus_gui.splash_text_effect=function(player,name,color)
    local ids=regulus_gui.enable_powerup_effect(player,name,color)
    minetest.after(1.5,function()
        regulus_gui.disable_powerup_effect(player,ids)
    end)
    --play a sound
end


regulus_gui.enable_powerup_effect=function(player,name,color)
    local image={
        hud_elem_type="image",
        text="regulus_gray_splash"..tostring(math.random(6))..".png^[multiply:"..color,
        position={x=0.5,y=0.0},
        scale={x=1,y=1},
        alignment={x=0,y=1},
    }
    local text={
        hud_elem_type="text",
        text=name,
        position={x=0.5,y=0},
        --scale={x=2,y=2},
        size={x=5},
        alignment={x=0,y=2},
        style=2
    }
    local id1=player:hud_add(image)
    local id2=player:hud_add(text)
    return {id1,id2}
end

regulus_gui.disable_powerup_effect=function(player,ids)
    for _,id in pairs(ids) do
        player:hud_remove(id)
    end
end