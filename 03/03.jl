using Statistics

function get_input(fn::String)
    input = open(fn) |> readlines
    N = length(input)       # Number of rows
    M = length(input[1])    # Cols in each row, assumes each row is equal in length

    # Parse the input and store it in a Bool array
    bits = Array{Bool}(undef, N, M)
    for i = 1:N, j = 1:M
        bits[i, j] = parse(Int, input[i][j])
    end

    return bits
end


function compute_power_consumption(bits)
    # Compute the mean along each column then Round to nearest int and convert to Bool
    γ_binary = (Bool ∘ round).(mean(bits, dims = 1))
    # epsilon is given by the least common bit and must thus be opposite of gamma.
    ϵ_binary = .!γ_binary
    # Convert the binary number to a decimal by reducing i.e [1, 0, 1] to "101" and parsing
    # Bools are converted to Int first because string repr of bools are "True"/"False" but want "1"/"0".
    γ_decimal = parse(Int, (string.(UInt8.(γ_binary)) |> join), base = 2)
    ϵ_decimal = parse(Int, (string.(UInt8.(ϵ_binary)) |> join), base = 2)

    return γ_decimal * ϵ_decimal
end

function compute_life_support_rating(bits)
    N = size(bits, 1)
    M = size(bits, 2)

    oxygen_generator_binary = ""
    CO2_scrubber_binary = ""

    cumulative_most_common_mask = Bool.(ones(N))
    cumulative_least_common_mask = Bool.(ones(N))

    for i = 1:M
        most_common_bit =
            sum(cumulative_most_common_mask) / 2 <=
            sum(bits[cumulative_most_common_mask, i])

        cumulative_most_common_mask .*= most_common_bit .== bits[:, i]
        oxygen_generator_binary *= most_common_bit |> Int |> string

        if sum(cumulative_most_common_mask) == 1
            oxygen_generator_binary *=
                (string ∘ Int).(bits[cumulative_most_common_mask, i+1:end]) |> join
            break
        end
    end

    for i = 1:M
        least_common_bit =
            sum(cumulative_least_common_mask) / 2 >
            sum(bits[cumulative_least_common_mask, i])

        cumulative_least_common_mask .*= least_common_bit .== bits[:, i]
        CO2_scrubber_binary *= least_common_bit |> Int |> string

        if sum(cumulative_least_common_mask) == 1
            CO2_scrubber_binary *=
                (string ∘ Int).(bits[cumulative_least_common_mask, i+1:end]) |> join
            break
        end
    end

    oxygen_generator_decimal = parse(Int, oxygen_generator_binary, base = 2)
    CO2_scrubber_decimal = parse(Int, CO2_scrubber_binary, base = 2)

    println("Res = ", oxygen_generator_decimal * CO2_scrubber_decimal)
end

println("Part 1:")
get_input("03/test_input.dat") |> compute_power_consumption |> println
get_input("03/input.dat") |> compute_power_consumption |> println

println("\nPart 2:")
get_input("03/test_input.dat") |> compute_life_support_rating |> println
get_input("03/input.dat") |> compute_life_support_rating |> println
