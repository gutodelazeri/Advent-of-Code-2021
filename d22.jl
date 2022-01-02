function parse_input(input)
    instructions = Vector{Tuple{Bool, Int64, Int64, Int64, Int64, Int64, Int64}}()
    for line in readlines(input)
        info = match(Regex("^(on|off) x=(-?[0-9]+)..(-?[0-9]+),y=(-?[0-9]+)..(-?[0-9]+),z=(-?[0-9]+)..(-?[0-9]+)"), line)
        turn = (info[1] == "on" ? true : false)
        push!(instructions, (turn, parse(Int64, info[2]), parse(Int64, info[3]), parse(Int64, info[4]), parse(Int64, info[5]), parse(Int64, info[6]), parse(Int64, info[7])))
    end
    return instructions
end

function get_intersection_cuboid(c1, c2)
    x1b, x1e, y1b, y1e, z1b, z1e = c1
    x2b, x2e, y2b, y2e, z2b, z2e = c2
    
    coords = []
    for axis in 0:2
        v1_min, v1_max = c1[2*axis + 1], c1[2*axis + 2]
        v2_min, v2_max = c2[2*axis + 1], c2[2*axis + 2]
        if v2_max < v1_min || v1_max < v2_min
            return nothing
        else
            append!(coords, [max(v1_min, v2_min), min(v1_max, v2_max)])
        end
    end

    return NTuple{6, Int64}(coords)
end

function get_cuboid_volume(c)
    s = (c[1] ? 1 : -1)
    v = (c[3] - c[2] + 1) * (c[5] - c[4] + 1) * (c[7] - c[6] + 1)
    return s * v
end

function part_1(input)
    instructions = parse_input(input)
    lights_on = Set{Tuple{Int64, Int64, Int64}}()
    for (turn, x1, x2, y1, y2, z1, z2) in instructions
        if -50 <= x1 && x2 <= 50 && -50 <= y1 && y2 <= 50 && -50 <= z1 && z2 <= 50
            for x in x1:x2
                for y in y1:y2
                    for z in z1:z2
                        if turn
                            push!(lights_on, (x, y, z))
                        else
                            delete!(lights_on, (x, y, z))
                        end
                    end
                end
            end
        end
    end
    println(length(lights_on))
end

function part_2(input)
    instructions = parse_input(input)

    cuboid_list = Vector{Tuple{Bool, Int64, Int64, Int64, Int64, Int64, Int64}}()

    for instruction in instructions
        instruction_turn = instruction[1]
        instruction_cuboid = NTuple{6, Int64}([i for i in instruction[2:end]])
        for id in 1:length(cuboid_list)
            list_turn =  cuboid_list[id][1]
            list_cuboid =  cuboid_list[id][2:end]
            new_cuboid = get_intersection_cuboid(instruction_cuboid, list_cuboid)
            if new_cuboid != nothing
                push!(cuboid_list, (!list_turn, new_cuboid...))
            end
        end

        if instruction_turn
            push!(cuboid_list, (true, instruction_cuboid...))
        end
    end
    println(sum([get_cuboid_volume(c) for c in cuboid_list]))
end


part_1("data/d22.txt")
part_2("data/d22.txt")