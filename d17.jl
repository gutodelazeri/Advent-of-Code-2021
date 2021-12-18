function parse_input(input)
    coords = match(Regex("target area: x=([0-9]+)..([0-9]+), y=(-?[0-9]+)..(-?[0-9]+)"), strip(readline(input)))
    return map(x -> parse(Int64, x), coords)
end

function check_height(vx, vy, coords)
    xmin, xmax = coords[1], coords[2]
    ymin, ymax = coords[3], coords[4]
    x, y, max_height=(0, 0, 0)
    while (x <= xmax && y >= ymin) && !(vx == 0 && !(xmin <= x <= xmax))
        x, y = (x + vx, y + vy)
        vx, vy = ((vx != 0 ? vx - 1 : 0), vy - 1)
        max_height = max(max_height, y)
        if xmin <= x <= xmax && ymin <= y <= ymax
            return max_height
        end
    end
    return -1
end

function parts_1_and_2(input)
    coords = parse_input(input)
    max_y, counter = (0, 0)
    for x in 1:coords[2]
        for y in -abs(coords[1]):1:abs(coords[1])
            tmp = check_height(x, y, coords)
            max_y = max(max_y, tmp)
            counter += (tmp != -1)
        end
    end
    println(max_y)
    println(counter)
end


parts_1_and_2("data/d17.txt")