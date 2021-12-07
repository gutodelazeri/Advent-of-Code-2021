function parse_input(input)
    return map((x) -> (parse(Int64, x)), split(chomp(readline(input)), ","))
end


function part_1(input)
    numbers = sort(parse_input(input))
    pos = numbers[Int64(floor(length(numbers)/2))]
    println(reduce(+, map((x) -> abs( x- pos), numbers)))
end

function part_2(input)
    numbers = parse_input(input)
    best_cost = typemax(Int64)
    for pos in 1:length(numbers)
        cost = sum(map((x)-> Int64((abs(pos - x)*(abs(pos - x)+ 1))/2), numbers))
        if cost < best_cost
            best_cost = cost
        end
    end
    println(best_cost)
end

part_1("data/d07.txt")
part_2("data/d07.txt")