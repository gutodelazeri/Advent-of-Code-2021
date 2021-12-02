numbers = readlines("data/d01.txt")
numbers = map((x) -> parse(Int64, x), numbers)

global count = 0
for i in 2:length(numbers)
    global count
    count += (numbers[i-1] < numbers[i])
end
println(count)

count = 0
for i in 2:(length(numbers) - 2)
    global count
    count += (numbers[i-1] < numbers[i+2])
end
println(count)

