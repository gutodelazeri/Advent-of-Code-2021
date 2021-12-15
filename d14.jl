function parse_input(input)
    dict = Dict{String, String}()
    template_pairs = Dict{String, Int128}()
    set = Set()
    f = open(input, "r")

    template = readline(f)
    readline(f)
    
    while !eof(f)
        line = match(Regex("([A-Z]+) -> ([A-Z]+)"), readline(f))
        dict[line[1]] = line[2]
        push!(set, line[1])
    end

    for i in 1:(length(template) - 1)
        template_pairs[template[i:i+1]] = get!(template_pairs, template[i:i+1], 0) + 1
    end

    return dict, set, template_pairs, template[1], template[end]
end

function parts_1_and_2(input, iters)
    d, s, tp, first, last = parse_input(input)
    for iter in 1:iters
        to_insert = Vector{Tuple{String, Int128}}()
        to_remove =  Vector{Tuple{String, Int128}}()
        for (key, value) in tp
            if haskey(d, key)
                mid = d[key]
                push!(to_insert, (key[1:1] * mid, value))
                push!(to_insert, (mid * key[2:2], value))
                push!(to_remove, (key, value))
            end
        end

        for (key, value) in to_insert
            tp[key] = get!(tp, key, 0) + value
        end
        for (key, value) in to_remove
            tp[key] = max(0, get!(tp, key, 0) - value)
        end
        tp = filter(e -> e[2] > 0, tp)
    end

    freq = Dict{Char, Int128}()
    freq[first] = 1
    freq[last] = 1
    for (key, value) in tp
        freq[key[1]] = get!(freq, key[1], 0) + value
        freq[key[2]] = get!(freq, key[2], 0) + value
    end
    vals = values(freq)
    println(Int128((maximum(vals) - minimum(vals))/2))
end

parts_1_and_2("data/d14.txt", 10)
parts_1_and_2("data/d14.txt", 40)