# https://adventofcode.com/2023/day/12

input = readlines("2023/data/day_12_test_1.txt")

struct Record
  record::Vector{Char}
  configuration::Vector{Int}
end

function parse_input(input::Vector{String})::Vector{Record}
  records = Vector{Record}()
  for line in input
    parts = split(line, " ")
    record = parts[1]
    configuration = parts[2]
    record = Record(collect(record), map(x -> parse(Int, x), split(configuration, ",")))
    push!(records, record)
  end
  return records
end

function num_allowed_configurations(record::Record)::Int
  total_springs = sum(record.configuration)
  n_known_spings = sum(record.record .== '#')
  @info total_springs, n_known_spings
  @info check_record(record)
  0
end

function check_record(record::Record)::Bool
  joined_record = join(record.record, "")
  parts = split(joined_record, ".")
  @info parts
  if '?' in joined_record
    # throw("Record has unknown springs")
    return false
  end
  true
end

function part_1(input::Vector{String})::Int
  records = parse_input(input)
  num_allowed_configurations.(records)
  0
end
@info part_1(input)

function part_2(input::Vector{String})::Int
  0
end
@info part_2(input)
