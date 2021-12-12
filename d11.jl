function parse_input(input)
    M = Array{Int64}(undef, 0, 0)
    for (i, l) in enumerate(readlines(input))
        a = transpose(map((x) -> parse(Int64, x), collect(l)))
        if i == 1
            M = a
        else
            M = vcat(M, a)
        end
    end
    return M
end

function get_neighbors(x, y, dim_x, dim_y, immutable)
    neighbors = []
    for (dx, dy) in [(0, 1), (0, -1), (1, 0), (-1, 0), (1, 1), (-1, -1), (-1, 1), (1, -1)]
        if 1 <= x + dx <= dim_x && 1 <= y + dy <= dim_y
            push!(neighbors, CartesianIndex(x + dx, y + dy))
        end
    end
    return filter((x)-> !(x in immutable), neighbors)
end


function parts_1_and_2(input)
    M = parse_input(input)
    total = 0
    period = -1
    iter = 1
    
    while period == -1 || iter <= 100
        M = 1 .+ M
        full_charge = findall((x) -> x == 10, M)
        immutable = copy(full_charge)
        lights_on = 0
        while length(full_charge) != 0
            lights_on += 1
            coord = pop!(full_charge)
            neighbors = get_neighbors(coord[1], coord[2], size(M)[1], size(M)[2], immutable)
            M[coord[1], coord[2]] = 0
            for n in neighbors
                i = n[1]
                j = n[2]
                M[i, j] += 1
                if M[i, j] >= 10
                    push!(full_charge, CartesianIndex(i, j))
                    push!(immutable, CartesianIndex(i, j))
                end
            end
        end
        
        if iter <= 100
            total += lights_on
        end
        if lights_on == size(M)[1] * size(M)[2]
            period = iter
        end
        iter += 1
    end
    return total, period
end


total, period = parts_1_and_2("data/d11.txt")
println(total)
println(period)