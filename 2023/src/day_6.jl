using Base: product
# https://adventofcode.com/2023/day/6

input = readlines("2023/data/day_6.txt")

struct Race
  time::Int
  distance::Int
end

function parse_input(input::Vector{String})::Vector{Race}
  times = input[1]
  distances = input[2]

  times = split(times, " ")
  distances = split(distances, " ")

  times = filter(x -> x != "", times)
  distances = filter(x -> x != "", distances)

  times = times[2:end]
  distances = distances[2:end]

  times = map(x -> parse(Int, x), times)
  distances = map(x -> parse(Int, x), distances)

  collect([Race(p...) for p in zip(times, distances)])

end

function num_ways_to_win(race::Race)::Int
  num_ways_to_win = 0
  for i in 1:race.time
    distance = i * (race.time - i)
    if distance > race.distance
      @info i, distance
      num_ways_to_win += 1
    end
  end
  num_ways_to_win
end

function part_1(input::Vector{String})::Int
  races = parse_input(input)
  α = num_ways_to_win.(races)
  @info α
  prod(α)
end
@info part_1(input)

function combine_races(races::Vector{Race})::Race
  time = string([string(race.time) for race in races]...)
  distance = string([string(race.distance) for race in races]...)

  time = parse(Int, time)
  distance = parse(Int, distance)

  Race(time, distance)
end

function part_2(input::Vector{String})::Int
  races = parse_input(input)
  race = combine_races(races)
  @info race
  0
  # i * (B - i) > A
  # i * B - i^2 > A
  # i^2 - i * B + A < 0
  # i = (B +- sqrt(B^2 - 4 * A)) / 2
  #
  β = sqrt(race.time^2 - 4 * race.distance) / 2
  i_min = race.time - β
  i_max = race.time + β

  floor(i_max) - ceil(i_min) + 1

end
@info part_2(input)
