# https://adventofcode.com/2023/day/5

input = readlines("2023/data/day_5.txt")

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

constant_maps = [
  [Map(0, 0, 50)],
  [Map(54, 54, 46)],
  [Map(61, 61, 39)],
  [Map(95, 95, 5), Map(0, 0, 18)],
  [Map(0, 0, 45)],
  [Map(70, 70, 30)],
  [Map(97, 97, 3), Map(0, 0, 56)]]

function apply_maps(maps::Vector{Map}, ranges::Vector{Tuple{Int,Int}})::Vector{Tuple{Int,Int}}
  new_ranges = Vector{Tuple{Int,Int}}()
  for map in maps
    for range in ranges
      source_range = (map.sourceStart, map.sourceStart + map.width)
      @info source_range, "source_range"
      @info range, "range"
      overlap_range = overlap(source_range, range)
      @info overlap_range, "overlap_range"
      if overlap_range !== nothing && (overlap_range[1] <= overlap_range[2])
        @info "pushing"
        push!(
          new_ranges,
          (
            map.destinationStart + overlap_range[1] - map.sourceStart,
            map.destinationStart + overlap_range[2] - map.sourceStart
          )
        )
        @info new_ranges, "new_ranges"
      end
    end
  end
  new_ranges
end

function apply_all_maps(maps::Array{Vector{Map}}, ranges::Vector{Tuple{Int,Int}})::Vector{Tuple{Int,Int}}
  for (const_map, map) in zip(constant_maps, maps)
    map = push!(map, const_map...)
    ranges = apply_maps(map, ranges)
    @info ranges, "ranges"
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
  @info input
  seeds = parse_seeds(input)
  maps = parse_input(input)
  @info seeds, "seeds"
  input_ranges = [(seeds[i], seeds[i] + seeds[i+1] - 1) for i in 1:2:length(seeds)]
  @info input_ranges, "input_ranges"
  output_ranges = apply_all_maps(maps, input_ranges)
  @info output_ranges, "output_ranges"
  minimum(vcat([min(r[1], r[2]) for r in output_ranges]))
end
@info part_2(input)
