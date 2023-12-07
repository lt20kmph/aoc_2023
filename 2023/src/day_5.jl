# https://adventofcode.com/2023/day/5

input = readlines("2023/data/day_5_test_1.txt")

function parse_seeds(input::Vector{String})::Vector{Int}
  parts = split(input[1], ":")
  [parse(Int, x) for x in filter(x -> x != "", split(parts[2], " "))]
end

function parse_map(input::Vector{String})::Vector{Map}
  map = Vector{Map}()
  for line in input[2:end]
    push!(map, parse_map_line(line))
  end
  map
end

struct Map
  sourceStart::Int
  destinationStart::Int
  width::Int
end

function parse_map_line(line::String)::Map
  numbers = [parse(Int, x) for x in filter(x -> x != "", split(line, " "))]
  Map(numbers[2], numbers[1], numbers[3])
end

function apply_maps(maps::Vector{Map}, number::Int)::Int
  for map in maps
    if number >= map.sourceStart && number < map.sourceStart + map.width
      return map.destinationStart + number - map.sourceStart
    end
  end
  number
end

function apply_all_maps(maps::Array{Vector{Map}}, number::Int)::Int
  for map in maps
    number = apply_maps(map, number)
  end
  number
end

function overlap(range_0::Tuple{Int,Int}, range_1::Tuple{Int,Int})::Union{Tuple{Int,Int},Nothing}
  if range_0[1] > range_1[2] || range_1[1] > range_0[2]
    nothing
  end
  (max(range_0[1], range_1[1]), min(range_0[2], range_1[2]))
end

function apply_maps(maps::Vector{Map}, range::Tuple{Int,Int})::Vector{Tuple{Int,Int}}
  new_ranges = Vector{Tuple{Int,Int}}()
  for map in maps
    source_range = (map.sourceStart, map.sourceStart + map.width)
    overlap_range = overlap(source_range, range)
    if overlap_range !== nothing
      push!(new_ranges, (map.destinationStart + overlap_range[1] - map.sourceStart, map.destinationStart + overlap_range[2] - map.sourceStart))
    end
  end
  new_ranges
end

function apply_all_maps(maps::Array{Vector{Map}}, range::Tuple{Int,Int})::Vector{Tuple{Int,Int}}
  ranges = [range]
  for map in maps
    ranges = vcat(apply_maps(map, range)...)
  end
  ranges
end

function parse_input(input::Vector{String})::Array{Vector{Map}}
  maps = Array{Vector{Map}}(undef, 7)
  idx = 0
  for line in input[2:end]
    if line == ""
      idx += 1
      maps[idx] = Vector{Map}()
    elseif contains(line, ":")
    else
      push!(maps[idx], parse_map_line(line))
    end
  end
  maps
end

function part_1(input::Vector{String})::Int
  seeds = parse_seeds(input)
  maps = parse_input(input)
  minimum([apply_all_maps(maps, seed) for seed in seeds])
end
@info part_1(input)

function part_2(input::Vector{String})::Int
  seeds = parse_seeds(input)
  maps = parse_input(input)
  @info seeds
  input_ranges = [(seeds[i], seeds[i] + seeds[i+1]) for i in 1:2:length(seeds)]
  @info input_ranges
  output_ranges = [apply_all_maps(maps, input_range) for input_range in input_ranges]
  output_ranges = vcat(output_ranges...)
  @info output_ranges
  m_0 = minimum([output_range[1] for output_range in output_ranges if minimum([output_range[1], output_range[2]]) > 1])
  m_1 = minimum([output_range[2] for output_range in output_ranges if minimum([output_range[1], output_range[2]]) > 1])
  @info m_0, m_1
  0
end
@info part_2(input)
