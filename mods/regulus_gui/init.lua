regulus_gui={}

regulus_gui.splash_text_effect=function(player,text,color,secondary_text)
    local ids=regulus_gui.enable_splash_text_effect(player,text,color,secondary_text)
    minetest.after(1.5,function()
        regulus_gui.disable_splash_text_effect(player,ids)
    end)
    --play a sound
end


regulus_gui.enable_splash_text_effect=function(player,name,color,secondary_text)
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
    local text2={
        hud_elem_type="text",
        text=secondary_text,
        position={x=0.5,y=0.15},
        --scale={x=2,y=2},
        size={x=2},
        alignment={x=0,y=0},
        style=2
    }
    local id1=player:hud_add(image)
    local id2=player:hud_add(text)
    local id3=player:hud_add(text2)
    return {id1,id2,id3}
end

regulus_gui.disable_splash_text_effect=function(player,ids)
    for _,id in pairs(ids) do
        player:hud_remove(id)
    end
end

regulus_gui.show_subtitles=function(player,text,time)
    local text_elem={
        hud_elem_type="text",
        text=text,
        position={x=0.5,y=0.8},
        --scale={x=2,y=2},
        size={x=2},
        alignment={x=0,y=0},
    }
    local id=player:hud_add(text_elem)
    minetest.after(time,function()
        player:hud_remove(id)
    end)
end