function get_most_common(vec, bit, tie_break)
    if tie_break == "lcb"
        return count(i->(i[bit] == '0'), vec) <= size(vec, 1)/2 ? '0' : '1'
    else
        return (count(i->(i[bit] == '1'), vec) >= size(vec, 1)/2 ? '1' : '0')
    end
end

function part_1(strings)
    gamma_rate = fill(0, sizeof(strings[1]))
    input_size = length(strings)
    
    for s in strings
        c = map((x) -> parse(Int64, x), collect(s))
        gamma_rate = gamma_rate .+ c
    end

    gamma_rate = map((x) -> Int64(round(x/input_size)), gamma_rate)
    epsilon_rate = 1 .- gamma_rate

    println(parse(Int, join(gamma_rate), base=2) * parse(Int, join(epsilon_rate), base=2))
end


function part_2(input)
    matrix_A = Array{Array{Char}}(undef, length(input))
    matrix_B = Array{Array{Char}}(undef, length(input))
    for (index, bitstring) in enumerate(input)
        matrix_A[index] = collect(bitstring)
        matrix_B[index] = collect(bitstring)
    end

    for bit in 1:length(input[1])
        
        if size(matrix_A, 1) > 1
            mc_a = get_most_common(matrix_A, bit, "mcb")
            matrix_A = filter(x -> x[bit] == mc_a, matrix_A)
        end
        if size(matrix_B, 1) > 1
            mc_b = get_most_common(matrix_B, bit, "lcb")
            matrix_B = filter(x -> x[bit] == mc_b, matrix_B)
        end
    end
    println(parse(Int, join(matrix_A[1]), base=2) * parse(Int, join(matrix_B[1]), base=2))
end

input = readlines("data/d03.txt")
part_1(input)
part_2(input)