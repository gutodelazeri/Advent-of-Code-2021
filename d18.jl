function parse_input(input)
    numbers = Vector{Vector{String}}()
    for n in readlines(input)
        push!(numbers, map(x -> string(x), filter(x -> x != ',', collect(n))))
    end
    return numbers
end

function find_component(number, start_index)
    if number[start_index] != "["
        return (start_index, start_index)
    end

    stack = [number[start_index]]
    end_index = start_index+1
    
    while length(stack) != 0
        if number[end_index] == "["
            push!(stack, "[")
        elseif number[end_index] == "]"
            pop!(stack)
        end
        end_index += 1
    end

    return (start_index, end_index-1)
end

function calculate_magnitude(number)
    s1, e1 = find_component(number, 2)
    s2, e2 = find_component(number, e1+1)
    #println(number[s1:e1])
    #println(number[s2:e2])
    #println("----------------------------------------")

    v1, v2 = (0, 0)
    if s1 == e1
        v1 = parse(Int64, number[s1])
    else
        v1 = calculate_magnitude(number[s1:e1])
    end
    if s2 == e2 
        v2 = parse(Int64, number[s2])
    else
        v2 = calculate_magnitude(number[s2:e2])
    end
    return 3*v1 + 2*v2
end

function add_numbers(a, b)
    new_number = vcat(["["], vcat(a, vcat(b, ["]"])))        
    flag = true
    while flag
        flag = false
        depth = 0
        for (i,s) in enumerate(new_number)
            if s == "["
                depth += 1
            elseif s == "]"
                depth -= 1
            end
            if depth == 5
                c1 = new_number[i+1]
                c2 = new_number[i+2]
                insert!(new_number, i, "0")
                deleteat!(new_number, i+1)
                deleteat!(new_number, i+1)
                deleteat!(new_number, i+1)
                deleteat!(new_number, i+1)
                tmp1, tmp2 = (i-1, i+1)
                while tmp1 > 0 || tmp2 <= length(new_number)
                    if tmp1 > 0 && new_number[tmp1] != "]" && new_number[tmp1] != "["
                        new_number[tmp1] = string(parse(Int64, new_number[tmp1]) + parse(Int64, c1))
                        tmp1 = 0
                    end
                    if tmp2 <= length(new_number) && new_number[tmp2] != "]" && new_number[tmp2] != "["
                        new_number[tmp2] = string(parse(Int64, new_number[tmp2]) + parse(Int64, c2))
                        tmp2 = length(new_number)
                    end
                    tmp1 -=1
                    tmp2 += 1
                end
                flag = true
                break
            end
        end
        if !flag
            for (i,s) in enumerate(new_number)
                if length(s) > 1
                    n = parse(Int64, s)
                    l, r = (Int64(floor(n/2)), Int64(ceil(n/2)))
                    insert!(new_number, i, "[")
                    insert!(new_number, i+1, string(l))
                    insert!(new_number, i+2, string(r))
                    insert!(new_number, i+3, "]")
                    deleteat!(new_number, i+4)
                    flag = true
                    break
                end
            end
        end
    end
    return new_number
end

function part_1(input)
    numbers = parse_input(input)
    new_number = numbers[1]
    for i in 2:length(numbers)
       other_number = numbers[i]
       new_number = add_numbers(new_number, other_number)
    end
    println(calculate_magnitude(new_number))
end

function part_2(input)
    numbers = parse_input(input)
    max_num = 0
    for i in 1:length(numbers)
        for j in (i+1):length(numbers)
            m1 = calculate_magnitude(add_numbers(numbers[i], numbers[j]))
            m2 = calculate_magnitude(add_numbers(numbers[j], numbers[i]))
            max_num = max(max_num, max(m1, m2))
        end
    end
    println(max_num)
end


part_1("data/d18.txt")
part_2("data/d18.txt")