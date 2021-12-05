function parse_input(input)
    f = open(input, "r")

    draws = map((x) -> parse(Int64, x), split(readline(f), ","))
    
    boards = Matrix{Int64}[]
    while !eof(f) 
        current_board = Array{Int64}(undef, 5, 5)
        readline(f)
        for i in 1:5
            s = map((x) -> parse(Int64, x), split(readline(f)))
            current_board[i, :] = s
        end
        push!(boards, current_board)
    end
    
    close(f)

    return boards, draws
end


function part_1(input)
    boards, draws = parse_input(input)
    for draw in draws
        for board in boards
            pos = findall(x->x==draw, board)
            if length(pos) > 0
                pos = pos[1]
                board[pos[1], pos[2]] = -1
                if sum(board[pos[1], :]) == -5 || sum(board[:, pos[2]]) == -5
                    println(draw * sum(board[board .!= -1]))
                    return
                end
            end
        end
    end
end

function part_2(input)
    boards, draws = parse_input(input)
    completed = Set()
    counter = 0
    for draw in draws
        for (i, board) in enumerate(boards)
            if i in completed
                continue
            end
            pos = findall(x->x==draw, board)
            if length(pos) > 0
                pos = pos[1]
                board[pos[1], pos[2]] = -1
                if sum(board[pos[1], :]) == -5 || sum(board[:, pos[2]]) == -5
                    counter += 1
                    if counter == length(boards)
                        println(draw * sum(board[board .!= -1]))
                        return
                    else
                        push!(completed, i)
                    end
                end
            end
        end
    end
end


part_1("data/d04.txt")
part_2("data/d04.txt")