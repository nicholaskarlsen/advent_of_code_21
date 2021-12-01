using LinearAlgebra

function get_input(fn::String)::Vector{Int}
    input = nothing
    open(fn) do file
        input = readlines(file)
    end
    return parse.(Int, input)
end

function convolution(measurements::Vector{Int})::Vector{Int}
    conv = zeros(length(measurements) - 2)
    kernel = [1; 1; 1]

    for i = 2:length(measurements)-1
        conv[i-1] = dot(measurements[i-1:i+1], kernel)
    end

    return conv
end

function compute_num_depth_increases(measurements::Vector)
    num_increased = 0
    for i = 2:length(measurements)
        num_increased += measurements[i] > measurements[i-1] ? 1 : 0
    end

    println("Number of times depth increased: $(num_increased)")
end

println("Part 1:")
get_input("01/test_input.dat") |> compute_num_depth_increases
get_input("01/input.dat") |> compute_num_depth_increases

println("Part 2:")
get_input("01/test_input.dat") |> convolution |> compute_num_depth_increases
get_input("01/input.dat") |> convolution |> compute_num_depth_increases