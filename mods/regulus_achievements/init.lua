regulus_achievements={}

regulus_achievements.achievements={}

regulus_achievements.trigger_achieve=function(player,achievement_name,param)
    regulus_achievements.achievements[achievement_name](player,param)
end

regulus_achievements.finish_achievement=function(player,achievement_name)
    --do a gui thing
    --save some meta
end

regulus_achievements.show_achievements_menu=function(player)
    --show formspec with the achievements pulled from the player's meta
end