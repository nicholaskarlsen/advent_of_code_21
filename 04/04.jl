using LinearAlgebra

function get_input(fn::String)
    input = (readlines ∘ open)(fn)

    # randomly drawn numbers
    numbers = parse.(Int, split(input[1], ","))
    # Each bingo card consists of 6 lines: 1 newline followed by 5 lines containing 5 numbers each
    num_lines::Int = length(input)
    num_cards::Int = (num_lines - 1) // 6
    bingo_cards = Array{Matrix{Int64}}(undef, num_cards)

    for (n, i) = enumerate(2:6:6*num_cards)
        bingo_cards[n] = reduce(hcat, map(x -> parse.(Int, x), split.(input[i+1:i+5])))
    end

    return numbers, bingo_cards
end

function check_bingo(unmarked)
    for i in 1:5
        if sum(unmarked[i,:]) == 0
            return true
        elseif sum(unmarked[:,i]) == 0
            return true
        end
    end
    return false
end

function bingo_first_win(input)
    numbers, bingo_cards = input
    num_cards = length(bingo_cards)
    unmarked = Bool.(ones(5, 5, num_cards))

    for num = numbers, i = 1:length(bingo_cards)
        unmarked[:,:,i] .*= (num .!= bingo_cards[i])
        if check_bingo(unmarked[:,:,i])
            unmarked_sum = sum(bingo_cards[i][unmarked[:,:,i]])
            return num * unmarked_sum
        end
    end
end

function bingo_last_win(input)
    numbers, bingo_cards = input
    num_cards = length(bingo_cards)
    unmarked = Bool.(ones(5, 5, num_cards))

    has_no_bingo = Bool.(ones(num_cards)) # keep track of which cards still has no bingo
    unmarked_sum = nothing
    num_last_bingo = nothing

    for num = numbers, i = 1:length(bingo_cards)
        if has_no_bingo[i]
            unmarked[:,:,i] .*= (num .!= bingo_cards[i])
            if check_bingo(unmarked[:,:,i])
                has_no_bingo[i] = false
                unmarked_sum = sum(bingo_cards[i][unmarked[:,:,i]])
                num_last_bingo = num
            end
        end
    end

    return unmarked_sum * num_last_bingo
end

println("part 1:")
get_input("04/test_input.dat") |> bingo_first_win |> println
get_input("04/input.dat") |> bingo_first_win |> println

println("part 2:")
get_input("04/test_input.dat") |> bingo_last_win |> println
get_input("04/input.dat") |> bingo_last_win |> println