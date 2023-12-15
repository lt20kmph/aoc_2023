# https://adventofcode.com/2023/day/14

input = readlines("2023/data/day_14.txt")

const Mirror = Vector{Vector{Char}}

function parse_input(input::Vector{String})::Vector{Vector{Char}}
  map(x -> collect(x), input)
end

function transpose(mirror::Mirror)::Mirror
  new_mirror = Mirror()
  for i in eachindex(mirror[1])
    new_row = Vector{Char}()
    for j in eachindex(mirror)
      push!(new_row, mirror[j][i])
    end
    push!(new_mirror, new_row)
  end
  new_mirror
end


function slide_east(row::Vector{Char})::Vector{Char}
  new_row = copy(row)
  while new_row != row
    for s in 1:(length(row) - 1)
      if row[s] == '.' && row[s+1] == '#'
        new_row[s] = '#'
        new_row[s+1] = '.'
        break
      end
    end
  end
  new_row
end


function part_1(input::Vector{String})::Int
  map = parse_input(input)
  map = transpose(map)
  slide_east(map[1])
  0
end
@info part_1(input)

function part_2(input::Vector{String})::Int
  0
end
@info part_2(input)
