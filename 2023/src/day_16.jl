# https://adventofcode.com/2023/day/16

input = readlines("2023/data/day_16.txt")

mutable struct MapCell
  type::Char
  directions::Vector{Bool}
end

const Map = Vector{Vector{MapCell}}

function parse_input(input::Vector{String})::Map
  map(row -> map(x -> MapCell(x, [false, false, false, false]), collect(row)), input)
end

# left, right, top, bottom

function update_cell!(map::Map, x::Int, y::Int)
  num_rows = length(map)
  num_cols = length(map[1])
  cell = map[y][x]
  if all(cell.directions)
    return
  end

  if x > 1
    left_cell = map[y][x-1]
    if left_cell.directions[2]
      if cell.type == '-'
        cell.directions[2] = true
      elseif cell.type == '|'
        cell.directions[3] = true
        cell.directions[4] = true
      elseif cell.type == '/'
        cell.directions[3] = true
      elseif cell.type == '\\'
        cell.directions[4] = true
      else
        cell.directions[2] = true
      end
    end
  end

  if x < num_cols
    right_cell = map[y][x+1]
    if right_cell.directions[1]
      if cell.type == '-'
        cell.directions[1] = true
      elseif cell.type == '|'
        cell.directions[3] = true
        cell.directions[4] = true
      elseif cell.type == '/'
        cell.directions[4] = true
      elseif cell.type == '\\'
        cell.directions[3] = true
      else
        cell.directions[1] = true
      end
    end
  end

  if y > 1
    top_cell = map[y-1][x]
    if top_cell.directions[4]
      if cell.type == '-'
        cell.directions[1] = true
        cell.directions[2] = true
      elseif cell.type == '|'
        cell.directions[4] = true
      elseif cell.type == '/'
        cell.directions[1] = true
      elseif cell.type == '\\'
        cell.directions[2] = true
      else
        cell.directions[4] = true
      end
    end
  end

  if y < num_rows
    bottom_cell = map[y+1][x]
    if bottom_cell.directions[3]
      if cell.type == '-'
        cell.directions[1] = true
        cell.directions[2] = true
      elseif cell.type == '|'
        cell.directions[3] = true
      elseif cell.type == '/'
        cell.directions[2] = true
      elseif cell.type == '\\'
        cell.directions[1] = true
      else
        cell.directions[3] = true
      end
    end
  end

end

function map_to_str(map::Map)::String
  string("\n", join([join([any(cell.directions) ? '#' : '.' for cell in row]) for row in map], "\n"))
end

function num_tiles_energized(map::Map, n::Int, starting_config::Tuple{Int,Int,Int})::Int
  map = deepcopy(map)
  map[starting_config[1]][starting_config[2]].directions[starting_config[3]] = true
  num_tiles = 0
  num_constant_iterations = 0
  for _ in 1:n
    for i in eachindex(map)
      for j in eachindex(map[i])
        update_cell!(map, i, j)
      end
    end
    new_num_tiles = sum(1 for row in map for cell in row if any(cell.directions))
    if new_num_tiles == num_tiles
      num_constant_iterations += 1
      if num_constant_iterations == 50
        break
      end
    else
      num_tiles = new_num_tiles
      num_constant_iterations = 0
    end
  end
  num_tiles
end

function part_1(input::Vector{String})::Int
  map = parse_input(input)
  num_tiles_energized(map, 2000, (1, 1, 2))
end
@info part_1(input)

function part_2(input::Vector{String})::Int
  map = parse_input(input)
  num_rows = length(map)
  num_cols = length(map[1])
  n = 300
  m_1 = maximum([num_tiles_energized(map, n, (i, 1, 2)) for i in 1:num_rows])
  m_2 = maximum([num_tiles_energized(map, n, (i, num_cols, 1)) for i in 1:num_rows])
  m_3 = maximum([num_tiles_energized(map, n, (1, i, 4)) for i in 1:num_cols])
  m_4 = maximum([num_tiles_energized(map, n, (num_rows, i, 3)) for i in 1:num_cols])
  max(m_1, m_2, m_3, m_4)
end
@info part_2(input)
