regulus_achievements={}

regulus_achievements.achievements={}

regulus_achievements.achievements.achievements_fly={
    name="Fly, you fools!",
    description="Fly for the first time",
    func=function(player)
        if player:get_meta():get_int("achievements_fly")==0 then
            player:get_meta():set_int("achievements_fly",1)
            regulus_achievements.finish_achievement(player,"achievements_fly")
        end
    end
}

regulus_achievements.achievements.achievements_tiny={
    name="Man of Ants",
    description="Become tiny",
    func=function(player)
        if player:get_meta():get_int("achievements_tiny")==0 then
            player:get_meta():set_int("achievements_tiny",1)
            regulus_achievements.finish_achievement(player,"achievements_tiny")
        end
    end
}

--optional param for multi-part achievements
regulus_achievements.trigger_achieve=function(player,achievement_name,param)
    regulus_achievements.achievements[achievement_name].func(player,param)
end

regulus_achievements.finish_achievement=function(player,achievement_name)
    --do a hud thing
    --save some meta
    --[[
    regulus_gui.splash_text_effect(
        player,
        regulus_achievements.achievements[achievement_name].name,
        "#ddd3f1",
        regulus_achievements.achievements[achievement_name].description
    )
    minetest.sound_play({name="regulus_achieve_minor",gain=10.0},{to_player=name,gain=10.0},true)
    ]]
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