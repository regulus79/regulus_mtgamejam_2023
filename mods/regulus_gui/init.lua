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
        number=0xFFFFFF,
        size={x=2},
        alignment={x=0,y=0},
        style=1,
    }
    local id=player:hud_add(text_elem)
    minetest.after(time,function()
        player:hud_remove(id)
    end)
end

regulus_gui.fading_images={}

regulus_gui.fade_image=function(player,image_name,time)
    local image={
        hud_elem_type="image",
        text=image_name,
        position={x=0.5,y=0.5},
        scale={x=1,y=1},
        alignment={x=0,y=1},
    }
    local id=player:hud_add(image)
    local current_time=minetest.get_us_time()
    --minetest.chat_send_all(dump({id,current_time}))
    regulus_gui.fading_images[id]={playername=player:get_player_name(),starttime=current_time,endtime=current_time+time*10^6,image_name=image_name}
    --minetest.chat_send_all(dump(regulus_gui.fading_images[id]))
end

minetest.register_globalstep(function()
    for id,info in pairs(regulus_gui.fading_images) do
        local player=minetest.get_player_by_name(info.playername)
        local time=minetest.get_us_time()
        if time>info.starttime and time<info.endtime then
            local ratio=(time-info.starttime)/(info.endtime-info.starttime)
            player:hud_change(id, "text",info.image_name.."^[colorize:"..minetest.rgba(0,0,0,256*ratio)..":alpha")
        else
            player:hud_remove(id)
            regulus_gui.fading_images[id]=nil
        end
    end
end)




minetest.register_chatcommand("fade_image",{
    description="test fade image",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        regulus_gui.fade_image(player,"regulus_gray_splash1.png",4)
    end
})