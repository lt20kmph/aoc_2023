# https://adventofcode.com/2023/day/2

input = readlines("2023/data/day_2.txt")

struct Reveal
  red::Int
  green::Int
  blue::Int
end

bag_contents = Reveal(12, 13, 14)

struct GameRecord
  id::Int
  reveals::Vector{Reveal}
end

function parse_line(line::String)::GameRecord
  id = match(r"Game (\d+)", line).captures[1]
  parts = split(line, ";")
  reveals = map(parts) do reveal
    red = match(r"(\d+) red", reveal)
    green = match(r"(\d+) green", reveal)
    blue = match(r"(\d+) blue", reveal)
    red = red !== nothing ? parse(Int, red.captures[1]) : 0
    green = green !== nothing ? parse(Int, green.captures[1]) : 0
    blue = blue !== nothing ? parse(Int, blue.captures[1]) : 0
    Reveal(red, green, blue)
  end
  GameRecord(parse(Int, id), reveals)
end

function is_record_valid(record::GameRecord, bag_contents::Reveal)::Bool
  for reveal in record.reveals
    if reveal.red > bag_contents.red
      return false
    end
    if reveal.green > bag_contents.green
      return false
    end
    if reveal.blue > bag_contents.blue
      return false
    end
  end
  true
end

function minimum_number_of_cubes(record::GameRecord)::Reveal
  min_red = maximum(map(record.reveals) do reveal
    reveal.red
  end)
  min_green = maximum(map(record.reveals) do reveal
    reveal.green
  end)
  min_blue = maximum(map(record.reveals) do reveal
    reveal.blue
  end)
  Reveal(min_red, min_green, min_blue)
end

function part_1(input::Vector{String})::Int
  records = map(parse_line, input)
  sum(map(records) do record
    is_record_valid(record, bag_contents) ? record.id : 0
  end)
end
@info part_1(input)

function part_2(input::Vector{String})::Int
  records = map(parse_line, input)
  map(records) do record
    r = minimum_number_of_cubes(record)
    r.red * r.green * r.blue
  end |> sum
end
@info part_2(input)
