function part_1(numbers)
    count = 0
    for i in 2:length(numbers)
        count += (numbers[i-1] < numbers[i])
    end
    println(count)
end

function part_2(numbers)
    count = 0
    for i in 2:(length(numbers) - 2)
        count += (numbers[i-1] < numbers[i+2])
    end
    println(count)
end

input = readlines("data/d01.txt")
input = map((x) -> parse(Int64, x), input)

part_1(input)
part_2(input)


