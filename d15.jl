using DataStructures

function parse_input(input, replicate)
    m = Matrix{Int64}(undef, 0, 0)
    
    for (i, line) in enumerate(readlines(input))
        if i == 1
            m = transpose(map(x -> parse(Int64, x), collect(line)))
        else
            m = vcat(m, transpose(map(x -> parse(Int64, x), collect(line))))
        end
    end
    
    if !replicate
        return m
    end

    dim_x, dim_y = size(m)
    for j in 0:3
        mp = map(x -> (x + 1 == 10 ? 1 : x+1), m[:, (dim_y*j + 1):(dim_y*(j+1))])
        m = hcat(m, mp)
    end
    
   dim_y = dim_y * 5
    for j in 0:3
        mp = map(x -> (x + 1 == 10 ? 1 : x+1), m[(dim_x*j + 1):(dim_x*(j+1)), :])
        m = vcat(m, mp)
    end
    
    return m
end

function manhattan(a, b)
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function get_neighbors(i, j, max_x, max_y)
    neighbors = []
    for (dx, dy) in [(0, 1), (0, -1), (1, 0), (-1, 0)]
        if (1 <= dx + i <= max_x) && (1 <= dy + j <= max_y)
            push!(neighbors, (i + dx, j + dy))
        end
    end
    return neighbors
end

function parts_1_and_2(input, replicate)
    M = parse_input(input, replicate)

    max_x, max_y = size(M)
    start, goal = ((1,1), (max_x, max_y))
    
    Q = PriorityQueue{Tuple{Int64, Int64}, Int64}(start => manhattan(start, goal));
    visited = Set{Tuple{Int64, Int64}}()
    
    g = Dict{Tuple{Int64, Int64}, Int64}(start => 0)
    h = Dict{Tuple{Int64,Int64}, Int64}(start => manhattan(start, goal))

    while length(Q) != 0
        current  = dequeue!(Q)
        if current == goal
            break
        else
            push!(visited, current)
        end
        for neighbor in get_neighbors(current[1], current[2], max_x, max_y)
            if !(neighbor in visited)
                if haskey(g, neighbor) 
                    if g[neighbor] > g[current] + M[neighbor[1], neighbor[2]]
                        g[neighbor] = g[current] + M[neighbor[1], neighbor[2]]
                        h[neighbor] =  get!(h, neighbor, manhattan(neighbor, goal))
                        Q[neighbor] = g[neighbor] + h[neighbor]
                    end
                else
                    g[neighbor] = g[current] + M[neighbor[1], neighbor[2]]
                    h[neighbor] =  get!(h, neighbor, manhattan(neighbor, goal))
                    Q[neighbor] = g[neighbor] + h[neighbor]
                end
            end
        end
    end
    println(g[goal])
end

parts_1_and_2("data/d15.txt", false)
parts_1_and_2("data/d15.txt", true)