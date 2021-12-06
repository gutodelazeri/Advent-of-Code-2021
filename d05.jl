function parse_input(input)
    lines = Array{Tuple{Int64, Int64, Int64, Int64}}(undef,0)
    for line in readlines(input)
        coords = match(Regex("([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)"), line)
        push!(lines, (parse(Int64, coords[1]), parse(Int64, coords[2]), parse(Int64, coords[3]), parse(Int64, coords[4])))
    end
    return lines
end

function get_line_slope(line)
    x_slope = line[1] - line[3]
    y_slope = line[2] - line[4]
    
    if x_slope > 0
        x_slope = -1
    elseif x_slope < 0
        x_slope = 1
    end

    if y_slope > 0
        y_slope = -1
    elseif y_slope < 0
        y_slope = 1
    end

    return x_slope, y_slope
end

function intersections(lines)
    counter = Dict{Tuple{Int64,Int64},Int64}()
    for line in lines
        p = (line[1], line[2])
        dx, dy = get_line_slope(line)
        counter[(p[1], p[2])] = get!(counter, (p[1], p[2]), 0) + 1
        while p != (line[3], line[4])
            p = (p[1] + dx, p[2] + dy)
            counter[(p[1], p[2])] = get!(counter, (p[1], p[2]), 0) + 1
        end
    end
    return count((x) -> (x[2] >= 2), counter)
end

function part_1(input)
    lines = parse_input(input)
    println(intersections([l for l in lines if l[1] == l[3] || l[2] == l[4]]))
end

function part_2(input)
    lines = parse_input(input)
    println(intersections(lines))
end

part_1("data/d05.txt")
part_2("data/d05.txt")