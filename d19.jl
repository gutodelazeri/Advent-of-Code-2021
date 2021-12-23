function parse_input(input)
    count = 0
    scanners = Dict{Int64, Vector{Tuple{Int64, Int64, Int64}}}()
    f = open(input, "r")
    while !eof(f)
        list_of_coords = Vector{Tuple{Int64, Int64, Int64}}()
        readline(f)
        line = readline(f)
        while length(line) > 0
            coords = map(x -> parse(Int64, x), split(line, ","))
            push!(list_of_coords, Tuple(coords))
            line = readline(f)
        end
        scanners[count] = list_of_coords
        count += 1
    end
    return scanners
end

function apply_transformation(points, permutation, rotation, candidate, reference)
    translation = reference .- ((candidate[permutation[1]], candidate[permutation[2]], candidate[permutation[3]]) .* rotation)
    points = map(x -> (x[permutation[1]], x[permutation[2]], x[permutation[3]]), points)
    points = map(x -> x .* rotation, points)
    points = map(x -> x .+ translation, points)    
    return points, translation
end

function check_overlap(scanner_1, scanner_2)
    for reference_point in scanner_1
        for candidate_point in scanner_2
            for permutation in [(1,2,3), (1,3,2), (2,1,3), (2,3,1), (3,1,2), (3,2,1)]
                for rotation in [(1, 1, 1), (-1, 1, 1), (1, -1, 1), (1, 1, -1), (-1, -1, 1), (-1, 1, -1), (1, -1, -1),  (-1, -1, -1)]
                    points, translation   = apply_transformation(scanner_2, permutation, rotation, candidate_point, reference_point)
                    overlap = intersect(points, scanner_1)
                    if length(overlap) >= 12
                        return (true, points, translation)
                    end
                end
            end
        end
    end
    return (false, Vector{Tuple{Int64, Int64, Int64}}(), (1,2,3), (1,1,1))
end

function parts_1_and_2(input)
    scanners = parse_input(input)
    not_aligned = Set{Int64}([i for i in 1:(length(scanners) - 1)])
    queue = Vector{Int64}([0])
    positions = Dict{Int64, Tuple{Int64, Int64, Int64}}(0 => (0, 0, 0))
    
    while length(not_aligned) != 0
        current = pop!(queue)
        for j in not_aligned
            align, points, j_pos = check_overlap(scanners[current], scanners[j])
            if align
                positions[j] = j_pos
                scanners[j] = points
                delete!(not_aligned, j)
                if !(j in queue)
                    push!(queue, j)
                end
            end
        end
    end

    # Part 1
    beacons = Set{Tuple{Int64, Int64, Int64}}()
    for points in values(scanners)
        for p in points
            push!(beacons, p)
        end
    end
    println(length(beacons))

    # Part 2
    max_dist = 0
    for i in 0:(length(scanners) - 1)
        for j in (i+1):(length(scanners) - 1)
            s = abs(positions[i][1] .- positions[j][1]) + abs(positions[i][2] .- positions[j][2]) + abs(positions[i][3] .- positions[j][3])
            if s > max_dist
                max_dist = s
            end
        end 
    end
    println(max_dist)
end

parts_1_and_2("data/d19.txt")
