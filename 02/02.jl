function get_input(fn::String)
    input = open(fn) |> readlines
    input = split.(input)

    direction = Array{String}(undef, length(input))
    steps = Array{Int}(undef, length(input))

    for i = 1:length(input)
        direction[i] = input[i][1]
        steps[i] = parse(Int, input[i][2])
    end

    return direction, steps
end

function compute_final_position(input)
    direction, steps = input

    x = 0 # horizontal position
    y = 0 # depth

    for i = 1:length(steps)
        if direction[i] == "forward"
            x += steps[i]
        elseif direction[i] == "down"
            y += steps[i]
        elseif direction[i] == "up"
            y -= steps[i]
        end
    end

    return x, y
end

function compute_final_position_p2(input)
    direction, steps = input

    x = 0 # horizontal position
    y = 0 # depth
    aim = 0

    for i = 1:length(steps)
        if direction[i] == "forward"
            x += steps[i]
            y += steps[i] * aim
        elseif direction[i] == "down"
            aim += steps[i]
        elseif direction[i] == "up"
            aim -= steps[i]
        end
    end

    return x, y
end

println("Part 1:")
x, y = get_input("02/test_input.dat") |> compute_final_position
println("Test case: $(x*y)")
x, y = get_input("02/input.dat") |> compute_final_position
println("Puzzle case: $(x*y)")

println("Part 2:")
x, y = get_input("02/test_input.dat") |> compute_final_position_p2
println("Test case: $(x*y)")
x, y = get_input("02/input.dat") |> compute_final_position_p2
println("Puzzle case: $(x*y)")