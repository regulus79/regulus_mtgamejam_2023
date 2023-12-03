regulus_gui={}

regulus_gui.enable_powerup_effect=function(player,name,good)
    local image={
        hud_elem_type="image",
        text=(good and "regulus_green_splash.png") or "regulus_red_splash.png",
        position={x=0.5,y=0.3},
        scale={x=1,y=1},
        alignment={x=0,y=0},
    }
    local text={
        hud_elem_type="text",
        text=name,
        position={x=0.5,y=0.13},
        --scale={x=2,y=2},
        size={x=5},
        --alignment={x=0,y=0},
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