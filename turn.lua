turn = {}

turn.delay = 0.2
turn.count = 0
turn.time = 0
turn.max = 2

function turn.next()

    turn.count = turn.count + 1
    turn.time = 0

    cycle.turn()
    fog.new()

    for i = 1, #monsters do
        monsters[i]:addturn()
    end
end


function turn.update(dt)

    turn.time = turn.time + dt
    
    if turn.time > turn.max then
        turn.next()
    end

end