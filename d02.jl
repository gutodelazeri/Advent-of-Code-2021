function part_1(commands)
    depth = 0
    horizontal_position = 0
    for command in commands
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
end

function part_2(commands)
    aim = 0
    depth = 0
    horizontal_position = 0
    for command in commands
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
end

input = readlines("data/d02.txt")
part_1(input)
part_2(input)