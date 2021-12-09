function parse_input(input)
    return [strip(l) for l in readlines(input)]
end


function part_1(input)
    easy_digits = Set([2, 3, 4, 7])
    lines = parse_input(input)
    counter  = 0
    for line in lines
        counter += count((x) -> (sizeof(x) in easy_digits), split(split(line, " | ")[2]))
    end
    println(counter)
end


function part_2(input)
    lines = parse_input(input)
    counter  = 0
    for line in lines
        notes, digits = split(line, " | ")
        notes = map((x) -> Set(x), split(notes))
        digits = map((x) -> Set(x), split(digits))
        
        d = Dict{Int64, Set{Char}}()
        d[1] = filter((x) -> length(x) == 2, notes)[1]
        d[4] = filter((x) -> length(x) == 4, notes)[1]
        d[7] = filter((x) -> length(x) == 3, notes)[1]
        d[8] = filter((x) -> length(x) == 7, notes)[1]
        d[3] = filter((x) -> length(x) == 5 && setdiff(d[1], x) == Set(), notes)[1]
        d[5] = filter((x) -> length(x) == 5 && setdiff(setdiff(d[4], d[1]), x) == Set(), notes)[1]
        d[2] = filter((x) -> length(x) == 5 && !issetequal(x, d[3]) && !issetequal(x, d[5]) , notes)[1]
        d[6] = filter((x) -> length(x) == 6 && !(setdiff(d[1], x) == Set()), notes)[1]
        d[9] = filter((x) -> length(x) == 6 && setdiff(d[4], x) == Set(), notes)[1]
        d[0] = filter((x) -> length(x) == 6 && !issetequal(x, d[9]) && !issetequal(x, d[6]) , notes)[1]
        num = 0
        for (m, digit) in zip([1000, 100, 10, 1], digits)
            num += m * ([x[1] for x in d if issetequal(x[2], digit)][1])
        end
        counter += num    
    end
    println(counter)
end

part_1("data/d08.txt")
part_2("data/d08.txt")