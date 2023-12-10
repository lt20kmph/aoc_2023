# https://adventofcode.com/2023/day/9

input = readlines("2023/data/day_9.txt")

function parse_input(input::Vector{String})::Vector{Vector{Int}}
  map(x -> map(y -> parse(Int, y), split(x)), input)
end

function compute_diffs(sequence::Vector{Int})::Vector{Int}
  diffs = []
  for i in 1:length(sequence)-1
    push!(diffs, sequence[i+1] - sequence[i])
  end
  diffs
end

function diffs_to_history(diffs::Vector{Vector{Int}})::Int
  n = 0
  for i in 1:length(diffs)
    n = diffs[end-i+1][end] + n
  end
  n
end

function diffs_to_prehistory(diffs::Vector{Vector{Int}})::Int
  n = 0
  for i in 1:length(diffs)
    n = diffs[end-i+1][1] - n
  end
  @info n
  n
end

function part_1(input::Vector{String})::Int
  sequences = parse_input(input)
  diffs = Vector{Vector{Vector{Int}}}()
  for sequence in sequences
    this_diffs = Vector{Vector{Int}}()
    this_diffs = push!(this_diffs, sequence)
    ds = compute_diffs(sequence)
    while any(x -> x != 0, ds)
      push!(this_diffs, ds)
      ds = compute_diffs(ds)
    end
    push!(diffs, this_diffs)
  end
  sum(diffs_to_history.(diffs))
end
@info part_1(input)

function part_2(input)
  sequences = parse_input(input)
  diffs = Vector{Vector{Vector{Int}}}()
  for sequence in sequences
    this_diffs = Vector{Vector{Int}}()
    this_diffs = push!(this_diffs, sequence)
    ds = compute_diffs(sequence)
    while any(x -> x != 0, ds)
      push!(this_diffs, ds)
      ds = compute_diffs(ds)
    end
    push!(diffs, this_diffs)
  end
  sum(diffs_to_prehistory.(diffs))
end
@info part_2(input)
