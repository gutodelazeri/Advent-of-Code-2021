function parse_input(input)
    f = open(input, "r")
    matrix = Array{Int64}(undef, 0, 0)
    while !eof(f) 
        line = transpose(map((x) -> parse(Int64, x), collect(readline(f))))
        if size(matrix) == (0, 0)
            matrix = line
        else
            matrix = vcat(matrix, line) 
        end
    end
    close(f)
    return matrix
end

function get_neighborhood(matrix, row, col)
    bottom = size(matrix)[1]
    right = size(matrix)[2]
    if row == 1 && col == 1
        neighbors = [(row+1, col), (row, col+1)]
    elseif row == 1 && col == right
        neighbors = [(row+1, col), (row, col-1)]
    elseif row == bottom && col == 1
        neighbors = [(row-1, col), (row, col+1)]
    elseif row == bottom && col == right
        neighbors = [(row-1, col), (row, col-1)]
    elseif row == 1
        neighbors = [(row+1, col), (row, col-1), (row, col+1)]
    elseif row == bottom
        neighbors = [(row-1, col), (row, col+1), (row, col-1)]
    elseif col == 1
        neighbors = [(row, col+1), (row+1, col), (row-1, col)]
    elseif col == right
        neighbors = [(row, col-1), (row+1, col), (row-1, col)]
    else
        neighbors =  [(row, col-1), (row, col+1), (row+1, col), (row-1, col)]
    end
 
    return neighbors
end

function is_low_point(row_index, col_index, neighbors, matrix)
    current = matrix[row_index, col_index]
    for (i, j) in neighbors
        if current >= matrix[i, j]
            current = -1
            break
        end
    end
    return current != -1
end

function get_basin_size(row_index, col_index, matrix, neighbors, visited)
    total = 0
    push!(visited, (row_index, col_index))
    for (i, j) in neighbors
        if matrix[i, j] != 9 && !((i, j) in visited)
            total += 1 + get_basin_size(i, j, matrix, get_neighborhood(matrix, i, j), visited)
        end
    end
    return total
end

function part_1(input)
    M = parse_input(input)
    dim = size(M)
    total = 0
    for row_index in 1:dim[1]
        for col_index in 1:dim[2]
            neighborhood = get_neighborhood(M, row_index, col_index)
            if is_low_point(row_index, col_index, neighborhood, M)
                total += M[row_index, col_index] + 1
            end
        end
    end
    println(total)
end

function part_2(input)
    M = parse_input(input)
    dim = size(M)
    basins = Int64[]
    for row_index in 1:dim[1]
        for col_index in 1:dim[2]
            neighborhood = get_neighborhood(M, row_index, col_index)
            if is_low_point(row_index, col_index, neighborhood, M)
                b = get_basin_size(row_index, col_index, M, neighborhood, [])
                push!(basins, b + 1)
            end
        end
    end
    basins = sort(basins, rev=true)
    total = 1
    for v in 1:min(length(basins), 3)
        total *= basins[v]
    end
    println(total)
end

part_1("data/d09.txt")
part_2("data/d09.txt")