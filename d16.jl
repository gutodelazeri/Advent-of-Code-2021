function parse_input(input)
    d = Dict{String, String}("0" => "0000", "1" => "0001", "2" => "0010", "3" => "0011",
                             "4" => "0100", "5" => "0101", "6" => "0110", "7" => "0111",
                             "8" => "1000", "9" => "1001", "A" => "1010", "B" => "1011",
                             "C" => "1100", "D" => "1101", "E" => "1110", "F" => "1111")
    
    return join(map(x -> d[string(x)], collect(readline(input))))
end


function parse_packets(packet, start, numbers, versions)
    V = parse(Int64, packet[start:start+2], base=2)
    T = packet[start+3:start+5]

    push!(versions, V)
    
    if T == "100"
        base = start+6
        total = ""
        while packet[base:base] == "1"
            total = total * packet[base+1:base+4]
            base += 5
        end
        total = total * packet[base+1:base+4]
        push!(numbers, parse(Int64, total, base=2))
        return base + 5
    else
        base = start+6
        operands = []
        end_point = 0
        if packet[base:base] == "1"
            sub_packets = parse(Int64, packet[base+1:base+11], base=2)
            base += 12 
            for p in 1:sub_packets
                base = parse_packets(packet, base, operands, versions)
            end
            end_point = base
        else
            num_bits = parse(Int64, packet[base+1:base+15], base=2)
            base += 16
            new_base = base
            while num_bits != 0
                new_base = parse_packets(packet, base, operands, versions)
                num_bits -= (new_base - base)
                base = new_base
            end
            end_point = new_base
        end
        
        ans = 0
        if T == "000"
            ans = reduce(+, operands)
        elseif T == "001"
            ans = reduce(*, operands)
        elseif T == "010"
            ans = minimum(operands)
        elseif T == "011"
            ans = maximum(operands)
        elseif T == "101"
            ans = Int64(operands[1] > operands[2])
        elseif T == "110"
            ans = Int64(operands[1] < operands[2])
        elseif T == "111"
            ans = Int64(operands[1] == operands[2])
        else
            println("Unknow type: ", T)
            exit(1)
        end
        push!(numbers, ans)
        return end_point
    end
end

function parts_1_and_2(input)
    packet = parse_input(input)
    versions = Vector{Int64}()
    numbers = Vector{Int64}()
    parse_packets(packet, 1, numbers, versions)
    println(sum(versions))
    println(numbers[1])
end

parts_1_and_2("data/d16.txt")