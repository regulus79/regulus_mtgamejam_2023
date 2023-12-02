--todo
regulus_powerups={}

regulus_powerups.random_teleport=function(player)
    local vec=vector.new(math.random(-10,10),math.random(-10,10),math.random(-10,10))
    local ray=minetest.raycast(player:get_pos(),player:get_pos()+vec,false)
    local hit_something,hit_pos=minetest.line_of_sight(player:get_pos(),player:get_pos()+vec)
    local dir=vector.normalize(vec)
    if hit_something~=true then
        --minetest.chat_send_all(dump(ray:next()))
        local the_pos=ray:next().above
        minetest.chat_send_all(dump(the_pos))
        player:set_pos(the_pos)
    end
end



minetest.register_chatcommand("powerup",{
    description="test powerup",
    func=function(name,param)
        regulus_powerups.random_teleport(minetest.get_player_by_name(name))
    end
})