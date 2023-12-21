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


regulus_gui.show_credit=function(player,text,pos,alignment,time)
    local text_elem={
        hud_elem_type="text",
        text=text,
        position=pos,
        --scale={x=2,y=2},
        number=0xFFFFFF,
        size={x=2},
        alignment=alignment or {x=0,y=0},
        style=1,
    }
    local id=player:hud_add(text_elem)
    minetest.after(time,function()
        player:hud_remove(id)
    end)
end

regulus_gui.show_credit_image=function(player,image,pos,alignment,time)
    local image_elem={
        hud_elem_type="image",
        text=image,
        position=pos,
        --scale={x=2,y=2},
        number=0xFFFFFF,
        size={x=2},
        scale={x=1,y=1},
        alignment=alignment or {x=0,y=0},
        style=1,
    }
    local id=player:hud_add(image_elem)
    minetest.after(time,function()
        player:hud_remove(id)
    end)
end


regulus_gui.fading_images={}

--type can be "in", "out', or "inout"
regulus_gui.add_fade_image=function(player,image_name,time,type)
    local image={
        hud_elem_type="image",
        text=image_name,
        position={x=0.5,y=0.5},
        scale={x=1,y=1},
        alignment={x=0,y=0},
    }
    local id=player:hud_add(image)
    local current_time=minetest.get_us_time()
    --minetest.chat_send_all(dump({id,current_time}))
    regulus_gui.fading_images[id]={
        playername=player:get_player_name(),
        starttime=current_time,
        endtime=current_time+time*10^6,
        image_name=image_name,
        type=type,
        max_opacity=256
    }
    --minetest.chat_send_all(dump(regulus_gui.fading_images[id]))
end

minetest.register_globalstep(function()
    for id,info in pairs(regulus_gui.fading_images) do
        local player=minetest.get_player_by_name(info.playername)
        local time=minetest.get_us_time()
        if time>info.starttime and time<info.endtime then
            local ratio=(time-info.starttime)/(info.endtime-info.starttime)
            if info.type=="in" then
                ratio=ratio
            elseif info.type=="out" then
                ratio=1-ratio
            elseif info.type=="inout" then
                ratio=1-math.abs(ratio*2-1)
            end
            player:hud_change(id, "text",info.image_name.."^[opacity:"..(info.max_opacity*ratio))
        else
            if info.type~="in" then
                player:hud_remove(id)
            end
            regulus_gui.fading_images[id]=nil
        end
    end
    if regulus_gui.cinematic_bar_animation then
        local info=regulus_gui.cinematic_bar_animation
        local time=minetest.get_us_time()
        local player=minetest.get_player_by_name(info.playername)
        local window_info=minetest.get_player_window_information(player:get_player_name()) or {
            size={x=1920,y=1080},
            real_hud_scaling=1
        }
        if time>info.starttime and time<info.endtime then
            local ratio=(time-info.starttime)/(info.endtime-info.starttime)
            if info.type=="in" then
                ratio=ratio
            elseif info.type=="out" then
                ratio=1-ratio
            end
            player:hud_change(regulus_gui.cinematic_bar_id1, "position",{x=0.5,y=-0.5-(0.1-ratio*0.2)*window_info.size.x/1920/window_info.real_hud_scaling})
            player:hud_change(regulus_gui.cinematic_bar_id2, "position",{x=0.5,y=1.5+(0.1-ratio*0.2)*window_info.size.y/1080/window_info.real_hud_scaling})
        else
            if info.type~="in" then
                player:hud_remove(regulus_gui.cinematic_bar_id1)
                player:hud_remove(regulus_gui.cinematic_bar_id2)
            end
            regulus_gui.cinematic_bar_animation=nil
        end
    end
end)

regulus_gui.vignette_id=nil
regulus_gui.add_vignette=function(player)
    local window_info=minetest.get_player_window_information(player:get_player_name()) or {
        size={x=1920,y=1080},
        real_hud_scaling=1
    }
    regulus_gui.vignette_id=player:hud_add({
        hud_elem_type="image",
        text="regulus_vignette2.png^[opacity:0",
        position={x=0.5,y=0.5},
        scale={x=1*window_info.size.x/1920/window_info.real_hud_scaling,y=1*window_info.size.y/1080/window_info.real_hud_scaling},
        alignment={x=0,y=0},
        z_index=-400,
    })
    local current_time=minetest.get_us_time()
    regulus_gui.fading_images[regulus_gui.vignette_id]={
        playername=player:get_player_name(),
        starttime=current_time,
        endtime=current_time+1*10^6,
        image_name="regulus_vignette2.png",
        type="in",
        max_opacity=150
    }
end

regulus_gui.remove_vignette=function(player)
    local current_time=minetest.get_us_time()
    if regulus_gui.vignette_id then
        regulus_gui.fading_images[regulus_gui.vignette_id]={
            playername=player:get_player_name(),
            starttime=current_time,
            endtime=current_time+1*10^6,
            image_name="regulus_vignette2.png",
            type="out",
            max_opacity=150
        }
    end
end


regulus_gui.cinematic_bar_id1=nil
regulus_gui.cinematic_bar_id2=nil
regulus_gui.cinematic_bar_animation=nil
regulus_gui.add_cinematic_bars=function(player)
    local window_info=minetest.get_player_window_information(player:get_player_name()) or {
        size={x=1920,y=1080},
        real_hud_scaling=1
    }
    regulus_gui.cinematic_bar_id1=player:hud_add({
        hud_elem_type="image",
        text="regulus_blackscreen_cutout.png",
        position={x=0.5,y=-0.6},
        scale={x=1*window_info.size.x/1920/window_info.real_hud_scaling,y=1*window_info.size.y/1080/window_info.real_hud_scaling},
        alignment={x=0,y=0},
        z_index=-1,
    })
    regulus_gui.cinematic_bar_id2=player:hud_add({
        hud_elem_type="image",
        text="regulus_blackscreen_cutout.png",
        position={x=0.5,y=1.6},
        scale={x=1*window_info.size.x/1920/window_info.real_hud_scaling,y=1*window_info.size.y/1080/window_info.real_hud_scaling},
        alignment={x=0,y=0},
        z_index=-1,
    })
    local current_time=minetest.get_us_time()
    regulus_gui.cinematic_bar_animation={
        playername=player:get_player_name(),
        starttime=current_time,
        endtime=current_time+1*10^6,
        type="in"
    }
end
regulus_gui.remove_cinematic_bars=function(player)
    local current_time=minetest.get_us_time()
    regulus_gui.cinematic_bar_animation={
        playername=player:get_player_name(),
        starttime=current_time,
        endtime=current_time+1*10^6,
        type="out"
    }
end



minetest.register_chatcommand("fade_image",{
    description="test fade image",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        regulus_gui.add_fade_image(player,"regulus_gray_splash1.png",4,"inout")
    end
})


minetest.register_chatcommand("add_bars",{
    description="test fade image",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        regulus_gui.add_cinematic_bars(player)
    end
})
minetest.register_chatcommand("remove_bars",{
    description="test fade image",
    func=function(name,param)
        local player=minetest.get_player_by_name(name)
        regulus_gui.remove_cinematic_bars(player)
    end
})