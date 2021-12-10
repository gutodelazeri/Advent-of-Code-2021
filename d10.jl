function parse_input(input)
    return [collect(l) for l in readlines(input)]
end

function is_open_delimiter(delimiter)
    return delimiter == '(' || delimiter == '[' || delimiter == '{' || delimiter == '<'
end

function match(a, b)
    return (b == '(' && a == ')') || (b == '[' && a == ']') || (b == '{' && a == '}') || (b == '<' && a == '>')
end

function part_1(input)
    total = 0
    points = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
    for line in parse_input(input)
        if length(line) == 0
            continue
        end
        stack = []
        for delimiter in line
            if is_open_delimiter(delimiter)
                push!(stack, delimiter)
            else
                if length(stack) == 0 || !match(delimiter, last(stack))
                    total += points[delimiter]
                    break
                else
                    pop!(stack)
                end
            end
        end
    end
    println(total)
end

function part_2(input)
    scores = Int64[]
    points = Dict('(' => 1, '[' => 2, '{' => 3, '<' => 4)
    for line in parse_input(input)
        if length(line) == 0
            continue
        end
        stack = []
        flag = true
        for delimiter in line
            if is_open_delimiter(delimiter)
                push!(stack, delimiter)
            else
                if length(stack) == 0 || !match(delimiter, last(stack))
                    flag = false
                    break
                else
                    pop!(stack)
                end
            end
        end
        if flag
            total = 0
            for delimiter in reverse(stack)
                total = total * 5 + points[delimiter]
            end
            push!(scores, total)
        end
    end
    println(sort(scores)[Int64( (length(scores) - 1)/2 + 1)])
end

part_1("data/d10.txt")
part_2("data/d10.txt")