regulus_achievements={}

regulus_achievements.achievements={}

--Fly for the first time
regulus_achievements.achievements.achievements_fly={
    name="Fly, you fools!",
    description="Fly for the first time.",
    func=function(player)
        player:get_meta():set_int("achievements_fly",1)
        regulus_achievements.finish_achievement(player,"fly")
        minetest.chat_send_all("Well done")
    end
}

--optional param for multi-part achievements
regulus_achievements.trigger_achieve=function(player,achievement_name,param)
    if player:get_meta():get_int("achievements_fly")==0 then
        regulus_achievements.achievements[achievement_name].func(player,param)
    end
end

regulus_achievements.finish_achievement=function(player,achievement_name)
    --do a hud thing
    --save some meta
    minetest.sound_play("regulus_achieve_minor",{to_player=name,gain=10.0},true)
end

regulus_achievements.show_achievements_menu=function(player)
    --show formspec with the achievements pulled from the player's meta
end

minetest.register_chatcommand("reset_achievements",{
    description="reset achievements for testing purposes",
    func=function(name,param)
        local meta=minetest.get_player_by_name(name):get_meta()
        for achievement_name,_ in pairs(regulus_achievements.achievements) do
            meta:set_int(achievement_name,0)
        end
    end
})

minetest.register_chatcommand("test_sound",{
    description="test sound",
    func=function(name,param)
        minetest.sound_play("regulus_achieve_minor",{to_player=name,gain=10.0},true)
    end
})