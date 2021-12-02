commands = readlines("data/d02.txt")

depth = 0
horizontal_position = 0
for command in commands
    global depth, horizontal_position

    direction, step = split(command, " ")
    if direction == "forward"
        horizontal_position += parse(Int64, step)
    elseif direction == "down"
        depth += parse(Int64, step)
    else
        depth -= parse(Int64, step)
    end
end 
println(depth * horizontal_position)

aim = 0
depth = 0
horizontal_position = 0
for command in commands
    global depth, horizontal_position, aim

    direction, step = split(command, " ")
    if direction == "forward"
        horizontal_position += parse(Int64, step)
        depth += aim * parse(Int64, step)
    elseif direction == "down"
        aim += parse(Int64, step)
    else
        aim -= parse(Int64, step)
    end
end 
println(depth * horizontal_position)