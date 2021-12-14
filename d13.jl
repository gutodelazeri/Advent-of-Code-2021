using Printf

function parse_input(input)
    points_section = true
    points = Vector{Tuple{Int64, Int64}}()
    folds = Vector{Tuple{String, Int64}}()
    for line in readlines(input)
        if length(line) == 0
            points_section = false
        elseif points_section
            coords = match(Regex("([0-9]+),([0-9]+)"), line)
            push!(points, (parse(Int64, coords[1])+1, parse(Int64, coords[2]) + 1))
        else
            fold = match(Regex("fold along (x|y)=([0-9]+)"), line)
            push!(folds, (fold[1], parse(Int64, fold[2]) + 1))
        end
    end
    return points, folds
end

function fold_it(point, fold_point, axis, max_x, max_y)
    x = point[1]
    y = point[2]

    if axis == "y"
        if y > fold_point
            y = (fold_point - (y - fold_point)) + max(0, (max_y - fold_point) - fold_point)
        else
            y = y - max(0, (max_y - fold_point) - fold_point)
        end
    else
        if x < fold_point
            x = abs(x - fold_point)
        else
            x = x - fold_point
        end
    end
    return (x, y)
end

function parts_1_and_2(input)
    points, folds = parse_input(input)
    for (axis, fold_point) in folds
        dim_x = maximum(x -> x[1], points)
        dim_y = maximum(x -> x[2], points)
        points = unique(map(x -> fold_it(x, fold_point, axis, dim_x, dim_y), points))
        println(length(points))
    end

    dim_x = maximum(x -> x[1], points)
    dim_y = maximum(x -> x[2], points)
    for j in 1:dim_y
        for i in dim_x:-1:1
            if (i, j) in points
                @printf("#")
             else
                @printf(".")
            end
        end
        @printf("\n")
    end
end

parts_1_and_2("data/d13.txt")