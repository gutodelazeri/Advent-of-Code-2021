using IterTools
using LRUCache

const lru = LRU{NTuple{5, Int64}, Tuple{Int128, Int128}}(maxsize=1000000000)


function parse_input(input)
    f = open(input, "r")
    p1 = parse(Int64, match(Regex("Player ([0-9]+) starting position: ([0-9]+)"), readline(f))[2])
    p2 = parse(Int64, match(Regex("Player ([0-9]+) starting position: ([0-9]+)"), readline(f))[2])
    close(f)
    return p1, p2
end

function deterministic_dice(p1_pos, p2_pos)
    p1_score, p2_score = (0, 0)
    dice = 1
    throws = 0
    while true
        p1_pos = (p1_pos + (dice + (dice + 1)%100 + (dice + 2)%100) -1 )%10 + 1
        dice = (dice + 3)%100
        throws += 3
        p1_score += p1_pos
        if p1_score >= 1000
            return p2_score * throws
        end
        
        p2_pos = (p2_pos + (dice + (dice + 1)%100 + (dice + 2)%100) - 1)%10 + 1
        dice = (dice + 3)%100
        p2_score += p2_pos
        throws += 3
        if p2_score >= 1000
            return p1_score * throws
        end
    end
end

function quantum_dice(turn, p1_pos, p2_pos, p1_score, p2_score, max_score, max_pos)
    get!(lru, (turn, p1_pos, p2_pos, p1_score, p2_score)) do
        if p1_score >= max_score
            lru[(turn, p1_pos, p2_pos, p1_score, p2_score)] =  (1, 0)
            return (1, 0)
        elseif p2_score >= max_score
            lru[(turn, p1_pos, p2_pos, p1_score, p2_score)] =  (0, 1)
            return (0, 1)
        else
            count = (0, 0)
            for (t1, t2, t3) in product(1:3, 1:3, 1:3)
                dice_sum = t1 + t2 + t3
                if turn == 1
                    new_pos = (p1_pos + dice_sum - 1)%max_pos + 1
                    new_score = p1_score + new_pos
                    ans = quantum_dice(2, new_pos, p2_pos, new_score, p2_score, max_score, max_pos)
                else
                    new_pos = (p2_pos + dice_sum - 1)%max_pos + 1
                    new_score = p2_score + new_pos
                    ans = quantum_dice(1, p1_pos, new_pos, p1_score, new_score, max_score, max_pos)
                end
                count = (count[1] + ans[1], count[2] + ans[2])
            end
            lru[(turn, p1_pos, p2_pos, p1_score, p2_score)] =  count
            return count
        end
    end
end

function part_1(input)
    p1, p2 = parse_input(input)
    ans = deterministic_dice(p1, p2)
    println(ans)
end

function part_2(input)
    p1, p2 = parse_input(input)
    ans = quantum_dice(1, p1, p2, 0, 0, 21, 10)
    println(max(ans[1], ans[2]))
end

part_1("data/d21.txt")
part_2("data/d21.txt")
