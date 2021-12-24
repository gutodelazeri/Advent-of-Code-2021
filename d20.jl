function parse_input(input)
    f = open("data/d20.txt", "r")
    algorithm = map(x -> x == '.' ? '0' : '1', collect(readline(f)))
    image = Array{Char}(undef, 0, 0)
    readline(f) # skip line
    while !eof(f)
        row = permutedims(map(x -> x == '.' ? '0' : '1', collect(readline(f))))
        if size(image) == (0, 0)
            image = row
        else
            image = vcat(image, row) 
        end
    end
    close(f)
    return algorithm, image
end

function get_char_index(image, i, j)
    dim_x, dim_y = size(image)
    number = ""
    for (dx, dy) in [(-1,-1), (-1,0), (-1,1), (0,-1), (0,0), (0,1), (1,-1), (1,0), (1,1)]
        if 1 <= i + dx <= dim_x && 1 <= j + dy <= dim_y
            number = number * image[i+dx, j+dy]
        else
            number = number * image[i, j]
        end
    end
    return parse(Int64, number, base=2)
end

function apply_enhancement(image, algorithm)
    (dim_x, dim_y) = size(image)
    output = Matrix{Char}(undef, dim_x, dim_y)
    for i in 1:dim_x
        for j in 1:dim_y
            output[i, j] = algorithm[get_char_index(image, i, j)+1]
        end
    end
    return output
end

function parts_1_and_2(input, iterations)
    algorithm, image = parse_input(input)
    dim_x, dim_y = size(image)
    padded_image = fill('0', (dim_x + 2*(iterations), dim_y + 2*(iterations)))
    padded_image[(iterations+1):(iterations + dim_x), (iterations+1):(iterations + dim_y)] = image
    for i in 1:iterations
        padded_image = apply_enhancement(padded_image, algorithm)
    end
    println(count(x -> x == '1', padded_image))
end

parts_1_and_2("data/d20.txt", 2)
parts_1_and_2("data/d20.txt", 50)