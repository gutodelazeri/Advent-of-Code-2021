function parse_input(input)
    return map((x) -> (parse(Int64, x)), split(chomp(readline(input)), ","))
end

function parts_1_and_2(MAX_DAYS)
    input = parse_input("data/d06.txt")
    counter = zeros(Int128,(9,))

    for i in input
        counter[i] += 1
    end

    for day in 1:(MAX_DAYS - 1)
        new_borns = counter[1]
        for i in 1:8
            counter[i] = counter[i+1]
        end
        counter[9] = new_borns
        counter[7] += new_borns
    end
    
    println(sum(counter))
end

parts_1_and_2(80)
parts_1_and_2(256)