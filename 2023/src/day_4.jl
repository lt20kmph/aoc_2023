# https://adventofcode.com/2023/day/4

input = readlines("2023/data/day_4.txt")

function parse_line(line::String)::Int
  parts = split(line, "|")
  winning_numbers_part = split(parts[1], ":")[2]
  my_numbers_part = parts[2]
  winning_numbers = filter(x -> length(x) > 0, split(winning_numbers_part, " "))
  my_numbers = filter(x -> length(x) > 0, split(my_numbers_part, " "))

  winning_numbers = parse.(Int, winning_numbers)
  my_numbers = parse.(Int, my_numbers)

  my_winning_numbers = filter(x -> x ∈ winning_numbers, my_numbers)

  length(my_winning_numbers)

end

function get_score(length::Int)::Int
  if length == 0
    return 0
  end

  2^(length - 1)
end

function part_1(input::Vector{String})::Int
  scoreMap = Dict{Int,Int}()
  for (i, line) in enumerate(input)
    scoreMap[i] = get_score(parse_line(line))
  end
  return sum(values(scoreMap))
end
@info part_1(input)

function part_2(input::Vector{String})::Int
  lengthMap = Dict{Int,Int}()
  freqMap = Dict{Int,Int}()

  for (i, line) in enumerate(input)
    lengthMap[i] = parse_line(line)
    freqMap[i] = 1
  end

  for i in eachindex(input)
    length = lengthMap[i]
    for j in 1:length
      freqMap[i+j] += freqMap[i]
    end
  end

  sum(values(freqMap))

end
@info part_2(input)
