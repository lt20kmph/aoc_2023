# https://adventofcode.com/2023/day/1

input = readlines("2023/data/day_1.txt")

num_map = Dict(
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
)

function process_line_part_1(line::String)::Int32
  line = filter(x -> x ∈ "123456789", line)
  if length(line) == 0
    return 0
  end
  parse(Int32, line[1]) * 10 + parse(Int32, line[end])
end

function process_line_part_2(line::String)::Int32
  vec = Vector{Int32}()
  for i in 1:length(line)
    if line[i] ∈ "123456789"
      append!(vec, parse(Int32, line[i]))
    else
      for (k, v) in num_map
        if startswith(line[i: end], k)
          append!(vec, v)
          break
        end
      end
    end
  end
  vec[1] * 10 + vec[end]
end

function part_1(input::Vector{String})::Int32
  sum(map(process_line, input))
end
@info part_1(input)

function part_2(input::Vector{String})::Int64
  sum(map(process_line_part_2, input))
end
@info part_2(input)
