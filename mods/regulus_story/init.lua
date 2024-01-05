--todo

local mod_storage=minetest.get_mod_storage()

regulus_story={}

regulus_story.dialogues={
    intro={
        {file="guardian0101",text="Greetings, young one!"},
        {file="guardian0102",text="Thank you for coming when we called."},
        {file="guardian0103",text="You are the strongest wizard of the guild."},
        {file="guardian0104",text="But alas, now that the crystal is gone, this guild may not remain for long."},
        {file="guardian0105",text="The darkness will soon swallow our world unless we get it back."},
        {file="guardian0106",text="You are our only hope of recovering the crystal."},
        {file="guardian0107",text="Along your way, make sure to pick up your new wand at the library."},
        {file="guardian0108",text="Good luck."},
    },
    intro_idle={
        {file="guardiani101",text="Please, continue to the library to receive your wand."},
    },
    library1={
	{file="librarian0101",text="Ah, hello there!"},
	{file="librarian0102",text="Sorry I didn't notice when you came in."},
	{file="librarian0103",text="I've been busy thinking of strategies to recover our lost crystal."},
	{file="librarian0104",text="Oh, you were sent to pick up your new wand, right? "},
	{file="librarian0105",text="Hmm, I think left it somewhere in this library..."},
	{file="librarian0106",text="I'm awfully busy, though; maybe you could find it for me?"},
    },
    library_nowand={
        {file="librariani001",text="I'm sure that your wand is somewhere in this library."},
    },
    library2={
	{file="librarian0201",text="You found it?  Ah, excellent."},
	{file="librarian0202",text="The defensive obstacles in the base have been active ever since the crystal was stolen."},
	{file="librarian0203",text="You'll need your wand to get past them, and reach where the crystal was hidden."},
	{file="librarian0204",text="It probably won't be easy.  I wish you luck."},
    },
    library_idle={
        {file="librariani101",text="You can use your wand to fly out from the library."},
    },
    second_meeting1={
        {file="librarian0301",text="Why hello, long time no see!"},
        {file="librarian0302",text="I'm still quite busy, so I can't talk much right now."},
        {file="librarian0303",text="I've been making preparations all around the base for the rescue of our crystal."},
        {file="todo",text="",length=1},--pause
        {file="librarian0304",text="Is your new wand treating you well?"},
    },
    second_meeting2={
        {file="todo",text="",length=1},--pause
        {file="librarian0401",text="Oh, dear, that's not right. You're so tiny!"},
        {file="librarian0402",text="Your wand appears to be malfunctioning."},
        {file="librarian0403",text="I suppose you will have to take a detour through that little hole in the wall behind me."},
        {file="librarian0404",text="You'll still make it to the crystal, but it'll take a little longer."},
    },
    second_meeting_idle={
        {file="librariani201",text="Go through the hole in the wall to get to the next room"},
        {file="librariani202",text="Your wand is making you tiny because it's malfunctioning."},
    },
    third_meeting={
        {file="librarian0501",text="Ah, you made it through!"},
        {file="librarian0502",text="I'm glad you survived those ants!"},
        {file="librarian0503",text="I was worried for a second that they'd killed you."},
    },
    bossfight1={
        {file="boss0101",text="How'd you get here so quickly? I didn't even have a chance to--"},
        {file="boss0102",text="Eh, I guess it doesn't matter."},
        {file="boss0103",text="Maybe it's time that I tell you the truth..."},
        {file="boss0104",text="You probably should have figured it out sooner."},
        {file="boss0105",text="You see the crystal behind me?  I'm the one who stole it."},
    },
    bossfight2={
        {chorus=true,file="boss0201",text="For I am a master wizard"},
        {chorus=true,file="boss0202",text="None can compare to me"},
        {chorus=true,file="boss0203",text="You shall die, but I will live forever with the energy of this crystal."},
    },
    bossfight_try_dig_crystal={
        {text="",length=2},
        {chorus=true,file="boss0301",text="I have set a spell over the crystal."},
        {chorus=true,file="boss0302",text="It cannot be removed while I yet live."},
    },
    you_won={
        {text="",length=2},
        {file="guardian0201",text="At last!"},
        {file="guardian0202",text="The crystal has been returned safely!"},
        {file="guardian0203",text="Thank you, young wizard, for your excellent service."},
        {file="guardian0204",text="The sun shall never again be blotted out by the darkness."},
    }
}

local ogglengths={
	mtgj_story_boss0101 = 3.231,
	mtgj_story_boss0102 = 1.943,
	mtgj_story_boss0103 = 2.017,
	mtgj_story_boss0104 = 2.152,
	mtgj_story_boss0105 = 4.104,
	mtgj_story_boss0201 = 2.249,
	mtgj_story_boss0202 = 1.96,
	mtgj_story_boss0203 = 4.92,
	mtgj_story_boss0301 = 2.265,
	mtgj_story_boss0302 = 2.986,
	mtgj_story_guardian0101 = 1.53,
	mtgj_story_guardian0102 = 2.266,
	mtgj_story_guardian0103 = 2.296,
	mtgj_story_guardian0104 = 4.991,
	mtgj_story_guardian0105 = 3.94,
	mtgj_story_guardian0106 = 2.631,
	mtgj_story_guardian0107 = 3.788,
	mtgj_story_guardian0108 = 0.833,
	mtgj_story_guardian0201 = 1.093,
	mtgj_story_guardian0202 = 2.319,
	mtgj_story_guardian0203 = 3.845,
	mtgj_story_guardian0204 = 4.181,
	mtgj_story_guardiani101 = 3.424,
	mtgj_story_librarian0101 = 1.134,
	mtgj_story_librarian0102 = 2.018,
	mtgj_story_librarian0103 = 3.491,
	mtgj_story_librarian0104 = 2.22,
	mtgj_story_librarian0105 = 2.888,
	mtgj_story_librarian0106 = 2.98,
	mtgj_story_librarian0201 = 2.321,
	mtgj_story_librarian0202 = 4.229,
	mtgj_story_librarian0203 = 3.372,
	mtgj_story_librarian0204 = 3.196,
	mtgj_story_librarian0301 = 2.607,
	mtgj_story_librarian0302 = 3.025,
	mtgj_story_librarian0303 = 4.038,
	mtgj_story_librarian0304 = 1.655,
	mtgj_story_librarian0401 = 3.439,
	mtgj_story_librarian0402 = 1.977,
	mtgj_story_librarian0403 = 3.966,
	mtgj_story_librarian0404 = 3.173,
	mtgj_story_librarian0501 = 1.47,
	mtgj_story_librarian0502 = 1.848,
	mtgj_story_librarian0503 = 2.395,
	mtgj_story_librariani001 = 2.647,
	mtgj_story_librariani101 = 2.622,
	mtgj_story_librariani201 = 2.809,
	mtgj_story_librariani202 = 2.937,
}
for _, seq in pairs(regulus_story.dialogues) do
	for _, line in pairs(seq) do
		local fl = line.file and ogglengths["mtgj_story_"..line.file]
		line.length = line.length or fl and fl + 1
	end
end

regulus_story.win=function(player)
    if player:get_meta():get_int("finished")==0 then
        player:get_meta():set_int("finished",1)
        local total_time=(minetest.get_us_time()-player:get_meta():get_float("start_time"))/10^6
        local minutes=math.floor(total_time/60)
        local seconds=total_time % 60
        --minetest.chat_send_all("You completed the game in "..seconds.." seconds")
        --regulus_mapgen.load_level(player,"you_won")
        regulus_story.play_music("mtgj_victory_extended",false,function()regulus_story.show_credits(player,total_time)end)
        
        regulus_gui.remove_vignette(player)
        

        minetest.after(0.3,function()
            player:set_sky({
                base_color="#FFFFFF",
                type="regular",
                sky_color={
                    day_sky="#61b5f5",
                    day_horizon="#b4bafa",
                    
                }
            })
            player:set_sun({
                visible=true,
                sunrise_visible=false,
            })
            player:override_day_night_ratio(nil)
            minetest.set_timeofday(0.5)
            regulus_story.trigger_dialogue(player, "you_won")
        end)
    end
end

minetest.register_on_newplayer(function(player)
    --minetest.chat_send_player(player:get_player_name(),"Game starts now, at "..tostring(minetest.get_us_time()))
    player:get_meta():set_float("start_time",minetest.get_us_time())
end)

regulus_story.is_dialogue_playing=false

regulus_story.voiceline_length_pause_inbetween=0.4

regulus_story.trigger_voiceline=function(player,voiceline,predelay)
    local function core()
        if voiceline.file and voiceline.file ~= "todo" then
            local params={to_player=player:get_player_name()}
            local mindist
	    local ppos=player:get_pos()
	    for _, ent in pairs(minetest.luaentities) do
		if ent._can_speak then
		    local pos=ent.object:get_pos()
		    local dist=pos and vector.distance(pos,ppos)
		    if dist and ((not mindist) or (dist < mindist)) then
			mindist = dist
			params.pos = pos
		    end
		end
	    end
	    local play = minetest.sound_play
	    if params.pos then
		params.pos.y = params.pos.y + 1.5
		if voiceline.chorus then
		    local opos = params.pos
		    play = function(spec, params, ...)
			local qty = 5
			local offs = math.random() * math.pi * 2
			for i = 1, qty do
			    params.pos = vector.offset(opos,
				math.sin(i * 2 / qty * math.pi + offs) * 5, 0,
				math.cos(i * 2 / qty * math.pi + offs) * 5)
			    params.start_time = i / qty * 0.05
			    minetest.sound_play(spec, params, ...)
			end
		    end
		end
	    end
            play("mtgj_story_"..voiceline.file,params)
        end
        regulus_gui.show_subtitles(player,voiceline.text,voiceline.length)
    end
    if predelay then
        minetest.after(predelay,core)
    else
        core()
    end
end

regulus_story.trigger_dialogue=function(player,dialogue_id,do_after)
    if regulus_story.is_dialogue_playing then
        return
    end
    regulus_story.is_dialogue_playing=true
    local total_delay=0
    for _,voiceline in ipairs(regulus_story.dialogues[dialogue_id]) do
        regulus_story.trigger_voiceline(player,voiceline,total_delay)
        --minetest.chat_send_all(dump(voiceline))
        total_delay=total_delay+voiceline.length+regulus_story.voiceline_length_pause_inbetween
    end
    minetest.after(total_delay,function()
        regulus_story.is_dialogue_playing=false
        player:get_meta():set_int("dialogue_"..dialogue_id,1)
        if do_after then
            do_after()
        end
    end)
end

minetest.register_node("regulus_story:crystal",{
    description="Crystal",
    drawtype="mesh",
    mesh="regulus_crystal.obj",
    tiles={"regulus_crystal.png"},
    collision_box={
        type="fixed",
        fixed={
            {-0.7,-0.2,-0.2,0.7,0.2,0.2},
            {-0.2,-0.2,-0.7,0.2,0.2,0.7},
            {-0.2,-0.7,-0.2,0.2,0.7,0.2},
            {-0.5,-0.5,-0.5,0.5,0.5,0.5},
        },
    },
    after_dig_node=function(pos,oldnode,oldmeta,digger)
        mod_storage:set_int("crystal_taken",1)
        digger:get_meta():set_int("crystal_taken",1)
        --minetest.chat_send_all(dump({"Yelloooo",digger:get_meta():get_int("crystal_taken")}))
        minetest.add_particlespawner({
            amount=20,
            time=1,
            pos=pos,
            texture={
                name="regulus_crystal_sparkle1.png",
                scale=5,
                alpha_tween={1,0},
            },
            vel={
                min=vector.new(-10,-1,-10),
                max=vector.new(10,1,10),
            }
        })
    end,
    use_texture_alpha="blend",
    sounds={dig="default_dig_crystal"},
    groups={diggable=1,crystal=1},
})


minetest.register_node("regulus_story:unbreakable_crystal",{
    description="Unbreakable Crystal",
    drawtype="mesh",
    mesh="regulus_crystal.obj",
    tiles={"regulus_crystal.png"},
    collision_box={
        type="fixed",
        fixed={
            {-0.7,-0.2,-0.2,0.7,0.2,0.2},
            {-0.2,-0.2,-0.7,0.2,0.2,0.7},
            {-0.2,-0.7,-0.2,0.2,0.7,0.2},
            {-0.5,-0.5,-0.5,0.5,0.5,0.5},
        },
    },
    on_punch=function(pos,node,puncher)
        if puncher:get_meta():get_int("dialogue_bossfight_try_dig_crystal")~=1 and puncher:get_meta():get_int("bossfight_in_progress")==1 then
            regulus_story.trigger_dialogue(puncher,"bossfight_try_dig_crystal")
        end
    end,
    use_texture_alpha="blend",
    groups={undiggable=1,crystal=1},
})

minetest.register_node("regulus_story:crystal_pedistal_original",{
    description="crystal pedistal original full",
    tiles={"regulus_pedistal.png"},
    drawtype="mesh",
    mesh="regulus_pedistal.obj",
    on_rightclick=function(pos,node,clicker,itemstack,pointed_thing)
    end,
    on_construct=function(pos)
        minetest.set_node(pos+vector.new(0,1,0),{name="regulus_story:crystal"})
    end,
    groups={undiggable=1},
    paramtype="light",
    light_source=14,
})

minetest.register_node("regulus_story:crystal_pedistal_original_empty",{
    description="crystal pedistal original empty",
    tiles={"regulus_pedistal.png"},
    drawtype="mesh",
    mesh="regulus_pedistal.obj",
    on_rightclick=function(pos,node,clicker,itemstack,pointed_thing)
    end,
    groups={undiggable=1,not_in_creative_inventory=1},
    paramtype="light",
    light_source=14,
})


minetest.register_node("regulus_story:crystal_pedistal_finish_empty",{
    description="crystal pedistal finish empty",
    tiles={"regulus_pedistal.png"},
    drawtype="mesh",
    mesh="regulus_pedistal.obj",
    on_rightclick=function(pos,node,clicker,itemstack,pointed_thing)
        --minetest.chat_send_all(dump(itemstack:to_string()))
        if itemstack:get_name()=="regulus_story:crystal" then
            --minetest.chat_send_all("Well done, player! you won!")
            minetest.set_node(pos+vector.new(0,1,0),{name="regulus_story:unbreakable_crystal"})
            minetest.set_node(pos,{name="regulus_story:crystal_pedistal_finish_full"})
            itemstack:clear()
            regulus_story.win(clicker)

            minetest.add_entity(pos,"regulus_story:crystal_laser")
            minetest.add_entity(pos,"regulus_story:crystal_laser_backward")
            
            minetest.add_particlespawner({
                amount=20,
                time=1,
                pos=pos,
                texture={
                    name="regulus_crystal_sparkle1.png",
                    scale=5,
                    alpha_tween={1,0},
                },
                vel={
                    min=vector.new(-10,-1,-10),
                    max=vector.new(10,1,10),
                }
            })
        end
    end,
    groups={undiggable=1},
    paramtype="light",
    light_source=14,
})

minetest.register_node("regulus_story:crystal_pedistal_finish_full",{
    description="crystal pedistal finish full",
    tiles={"regulus_pedistal.png"},
    drawtype="mesh",
    mesh="regulus_pedistal.obj",
    on_rightclick=function(pos,node,clicker,itemstack,pointed_thing)
    end,
    groups={undiggable=1,not_in_creative_inventory=1},
    paramtype="light",
    light_source=14,
})


minetest.register_node("regulus_story:wand_on_ground",{
    description="wand stand finish full",
    tiles={"regulus_wood2.png"},
    drawtype="nodebox",
    node_box={
        type="fixed",
        fixed={
            {-0.7,-0.5,-0.05,0.7,-0.4,0.05},
        }
    },
    on_punch=function(pos,node,clicker)
        clicker:hud_set_flags({
            hotbar=true,
        })
        clicker:get_inventory():add_item("main",ItemStack("regulus_tools:test"))
        minetest.set_node(pos,{name="air"})
        if minetest.get_node(pos-vector.new(0,1,0)).name=="regulus_story:wand_stand_full" then
            minetest.set_node(pos-vector.new(0,1,0),{name="regulus_story:wand_stand_empty"})
        end
        clicker:get_meta():set_int("has_wand",1)
    end,
    groups={undiggable=1},
    paramtype="light",
    paramtype2="facedir",
    light_source=14,
})
minetest.register_node("regulus_story:wand_stand_full",{
    description="wand stand finish full",
    tiles={"regulus_wand_stand.png"},
    groups={undiggable=1},
    paramtype="facedir",
    paramtype="light",
    light_source=14,
})
minetest.register_node("regulus_story:wand_stand_empty",{
    description="wand stand finish empty",
    tiles={"regulus_stone2.png"},
    groups={undiggable=1,not_in_creative_inventory=1},
    paramtype="facedir",
})


minetest.register_entity("regulus_story:crystal_laser",{
    visual="mesh",
    mesh="crystal_laser.obj",
    textures={"regulus_crystal_laser.png"},
    use_texture_alpha=true,
    backface_culling=false,
    automatic_rotate=1,
    shaded=false,
    on_activate=function(self)
        --self.object:set_velocity(vector.new(0,-20,0))
        minetest.after(1.0,function()
            self.object:remove()
        end)
    end,
})

minetest.register_entity("regulus_story:crystal_laser_backward",{
    visual="mesh",
    mesh="crystal_laser.obj",
    textures={"regulus_crystal_laser.png"},
    use_texture_alpha="blend",
    backface_culling=false,
    automatic_rotate=-1,
    shaded=false,
    on_activate=function(self)
        --self.object:set_velocity(vector.new(0,-20,0))
        minetest.after(1.0,function()
            self.object:remove()
        end)
    end,
})


regulus_story.current_music=nil
regulus_story.current_music_name=nil
regulus_story.is_music_queued=nil
regulus_story.current_music_beat_start=nil
regulus_story.current_music_spb=60/140--seconds per beat (bpm of my music is 140)

regulus_story.play_music=function(music_name,loop,on_music_start)
    if not regulus_story.current_music_beat_start then
        regulus_story.current_music_beat_start=minetest.get_us_time()
    end
    if loop==nil then
        loop=true
    end
    if regulus_story.current_music then
        minetest.sound_fade(regulus_story.current_music,1,0)
        local delay_until_beat=regulus_story.current_music_spb*4-((minetest.get_us_time()-regulus_story.current_music_beat_start)/10^6 % (regulus_story.current_music_spb*4))
        --minetest.chat_send_all(dump(delay_until_beat))
        regulus_story.is_music_queued=true
        minetest.after(delay_until_beat,function()
            regulus_story.is_music_queued=false
            --minetest.sound_stop(regulus_story.current_music)
            regulus_story.current_music=minetest.sound_play(music_name,{loop=loop,gain=0.25})
            regulus_story.current_music_name=music_name
            regulus_story.current_music_beat_start=minetest.get_us_time()
            if on_music_start then
                on_music_start()
            end
        end)
        --minetest.chat_send_all(dump(delay_until_beat))
    else
        regulus_story.current_music=minetest.sound_play(music_name,{loop=loop,gain=0.25})
    end
end

regulus_story.after_beat=function(delay,func,beat_interval)
    if regulus_story.current_music and regulus_story.current_music_beat_start then
        local at_that_time=minetest.get_us_time()+delay*10^6
        local delay_until_beat=regulus_story.current_music_spb*beat_interval-((at_that_time-regulus_story.current_music_beat_start)/10^6 % (regulus_story.current_music_spb*beat_interval))
        return minetest.after(delay+delay_until_beat,func)
    else
        return minetest.after(delay,func)
    end
end

regulus_story.do_functions_on_beat=function(list_of_funcs,beats_per_execution,predelay_beats)
    local jobs={}
    for i,func in pairs(list_of_funcs) do
        jobs[i]=regulus_story.after_beat((i-1)*regulus_story.current_music_spb*beats_per_execution+regulus_story.current_music_spb*predelay_beats,func,1)
    end
    return function()
        for _,job in pairs(jobs) do
            job:cancel()
        end
    end
end


minetest.register_chatcommand("play_music",{
    description="test playing music",
    func=function(name,param)
        regulus_story.play_music("mtgj_song2",true)
    end
})
minetest.register_chatcommand("on_beat",{
    description="test playing music",
    func=function(name,param)
        regulus_story.after_beat(1,function()regulus_story.trigger_voiceline(minetest.get_player_by_name(name),{text="Hello",length=1})end,4)
        regulus_story.after_beat(2,function()regulus_story.trigger_voiceline(minetest.get_player_by_name(name),{text="How are you",length=1})end,4)
        regulus_story.after_beat(3,function()regulus_story.trigger_voiceline(minetest.get_player_by_name(name),{text="I am good",length=1})end,4)
    end
})

regulus_story.show_intro=function(player)
    local blackscreen={
        hud_elem_type="image",
        text="regulus_blackscreen.png",
        position={x=0.5,y=0.5},
        scale={x=2,y=2},
        alignment={x=0,y=0},
    }
    local id=player:hud_add(blackscreen)
    local bar=regulus_story.current_music_spb*4
    regulus_story.do_functions_on_beat({
        function()regulus_story.trigger_voiceline(player,{text="Long ago, the world was peaceful and bright",length=bar*2})end,
        function()regulus_story.trigger_voiceline(player,{text="The guild of wizards kept the world in balance with the power of the velvet crystal",length=bar*3})end,
        function()regulus_story.trigger_voiceline(player,{text="But one day, a mysterious monster appeared",length=bar*3})end,
        function()regulus_story.trigger_voiceline(player,{text="It tried to steal the crystal, but the guilders fought it off",length=bar*3})end,
        function()regulus_story.trigger_voiceline(player,{text="Many believed that the monster was gone forever",length=bar*3})end,
        function()regulus_story.trigger_voiceline(player,{text="But they were all wrong; for just this past night, it struck again",length=bar*3})end,
        function()regulus_story.trigger_voiceline(player,{text="It stealthily stole the crystal and flew off with it to its lair",length=bar*3})end,
        function()regulus_story.trigger_voiceline(player,{text="Darkness enveloped the land, and the sun disappeared from the sky",length=bar*3})end,
        function()regulus_story.trigger_voiceline(player,{text="It is up to you, young wizard, to retrieve the crystal and save the land",length=bar*3})end,
        function()player:hud_remove(id)end,
    },4*4,-1)
end


regulus_story.show_credits=function(player,total_seconds)
    local blackscreen={
        hud_elem_type="image",
        text="regulus_blackscreen.png",
        position={x=0.5,y=0.5},
        scale={x=2,y=2},
        alignment={x=0,y=0},
    }
    local minutes=math.floor(total_seconds/60)
    local seconds=total_seconds % 60
    local id=nil
    local beat=regulus_story.current_music_spb
    player:hud_set_flags({
        hotbar=false,
        healthbar=false,
    })
    regulus_story.do_functions_on_beat({
        [1]=function()id=player:hud_add(blackscreen)end,
        [1+4]=function()regulus_gui.show_credit_image(player,"header.png",{x=0.5,y=0.5},nil,beat*8)end,
        --[1+8]=function()regulus_gui.show_credit(player,"by Regulus",{x=0.5,y=0.6},nil,beat*4)end,
        [1+12]=function()regulus_gui.show_credit(player,"Code - ",{x=0.5,y=0.3},{x=1},beat*4)end,
        [1+16]=function()regulus_gui.show_credit(player,"Code - Regulus",{x=0.5,y=0.3},{x=1},beat*12)end,
        [1+20]=function()regulus_gui.show_credit(player,"Textures - ",{x=0.5,y=0.5},{x=1},beat*4)end,
        [1+24]=function()regulus_gui.show_credit(player,"Textures - Regulus",{x=0.5,y=0.5},{x=1},beat*4)end,
        [1+28]=function()regulus_gui.show_credit(player,"Story - ",{x=0.2,y=0.2},{x=1},beat*4)end,
        [1+32]=function()regulus_gui.show_credit(player,"Story - Regulus",{x=0.2,y=0.2},{x=1},beat*12)end,
        [1+36]=function()regulus_gui.show_credit(player,"Music - ",{x=0.7,y=0.7},{x=1},beat*4)end,
        [1+40]=function()regulus_gui.show_credit(player,"Music - Regulus",{x=0.7,y=0.7},{x=1},beat*4)end,
        [1+44]=function()regulus_gui.show_credit(player,"Beta-testers",{x=0.5,y=0.2},nil,beat*20)end,
        [1+48]=function()regulus_gui.show_credit(player,"Dalgamer",{x=0.5,y=0.3},{x=1},beat*16)end,
        [1+52]=function()regulus_gui.show_credit(player,"Josiah VanderZee",{x=0.5,y=0.4},{x=1},beat*12)end,
        [1+56]=function()regulus_gui.show_credit(player,"archfan",{x=0.5,y=0.5},{x=1},beat*8)end,
        [1+60]=function()regulus_gui.show_credit(player,"Maple8",{x=0.5,y=0.6},{x=1},beat*4)end,
        [1+64]=function()regulus_gui.show_credit(player,"Thanks",{x=0.5,y=0.5},nil,beat)end,
        [1+65]=function()regulus_gui.show_credit(player,"Thanks for",{x=0.5,y=0.5},nil,beat)end,
        [1+66]=function()regulus_gui.show_credit(player,"Thanks for play",{x=0.5,y=0.5},nil,beat)end,
        [1+67]=function()regulus_gui.show_credit(player,"Thanks for playing!",{x=0.5,y=0.5},nil,beat)end,
        [1+68]=function()minetest.sound_fade(regulus_story.current_music,1,0)end,
        [1+70]=function()minetest.disconnect_player(player:get_player_name(),"You finished the game in "..minutes.." minutes, "..seconds.." seconds")end,
    },1,(12*4-1-4) + (4-1)*0)
end


minetest.register_chatcommand("show_credits",{
    description="test playing credits",
    func=function(name,param)
        regulus_story.play_music("mtgj_victory_extended",false,function()
            regulus_story.show_credits(minetest.get_player_by_name(name),1678)
        end)
    end,
})