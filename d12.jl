function parse_input(input)
    G = Dict{String, Vector{String}}()
    lines = readlines(input)
    sizehint!(G, length(lines))
    for line in lines
        a, b = split(line, "-")
        G[a] = push!(get!(G, a, []), b)
        G[b] = push!(get!(G, b, []), a)
    end
    return G
end

function DFS(G::Dict{String, Vector{String}}, start::String, goal::String, visited::Vector{String}, twice::Bool, current_path::Vector{String}, paths::Set{Vector{String}})
    if start in visited
        return
    else
        is_lowercase = (start != uppercase(start))
        for neighbor in G[start]
            if neighbor == goal
                a = vcat(current_path, [goal])
                push!(paths, a)
            elseif !(neighbor in visited)
                DFS(G, neighbor, goal, (is_lowercase ? vcat(visited, [start]) : visited), twice, vcat(current_path, [neighbor]), paths)
                if is_lowercase && twice && start != "start"
                    DFS(G, neighbor, goal, visited, false, vcat(current_path, [neighbor]), paths)
                end
            end
        end
    end
end

function parts_1_and_2(input)
    G = parse_input(input)
    s1 = Set{Vector{String}}()
    s2 = Set{Vector{String}}()
    DFS(G, "start", "end", Vector{String}(), false, ["start"], s1)
    DFS(G, "start", "end", Vector{String}(), true, ["start"], s2)
    println(length(s1))
    println(length(s2))
end

parts_1_and_2("data/d12.txt")

