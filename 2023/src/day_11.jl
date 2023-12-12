# https://adventofcode.com/2023/day/11

input = readlines("2023/data/day_11.txt")

function parse_input(input::Vector{String})::Vector{Vector{Char}}
  map(collect, input)
end

function is_col_empty(grid::Vector{Vector{Char}}, col::Int)::Bool
  for row in grid
    if row[col] != '.'
      return false
    end
  end
  true
end

function is_row_empty(grid::Vector{Vector{Char}}, row::Int)::Bool
  for col in grid[row]
    if col != '.'
      return false
    end
  end
  true
end

function expand_map(grid::Vector{Vector{Char}}, expansion_factor::Int)::Vector{Vector{Char}}
  new_rows = []
  empty_cols = [is_col_empty(grid, col) for col in 1:length(grid[1])]
  for row in grid
    new_row = []
    for col in eachindex(row)
      if empty_cols[col]
        push!(new_row, '.')
        for _ in 1:expansion_factor
          push!(new_row, '.')
        end
      else
        push!(new_row, row[col])
      end
    end
    push!(new_rows, new_row)
  end
  newwer_rows = []
  for row in eachindex(new_rows)
    if is_row_empty(grid, row)
      push!(newwer_rows, new_rows[row])
      for _ in 1:expansion_factor
        push!(newwer_rows, new_rows[row])
      end
    else
      push!(newwer_rows, new_rows[row])
    end
  end
  newwer_rows
end

function manhattan_distance(p_1::Tuple{Int,Int}, p_2::Tuple{Int,Int})::Int
  abs(p_1[1] - p_2[1]) + abs(p_1[2] - p_2[2])
end

function modified_manhattan_distance(
  p_1::Tuple{Int,Int},
  p_2::Tuple{Int,Int},
  grid::Vector{Vector{Char}},
  f::Int=1000000
)::Int

  min_1 = minimum([p_1[1], p_2[1]])
  min_2 = minimum([p_1[2], p_2[2]])

  max_1 = maximum([p_1[1], p_2[1]])
  max_2 = maximum([p_1[2], p_2[2]])

  num_empty_cols = [is_col_empty(grid, col) for col in min_2:max_2]
  num_empty_rows = [is_row_empty(grid, row) for row in min_1:max_1]

  abs(p_1[1] - p_2[1]) + abs(p_1[2] - p_2[2]) + (f - 1) * (sum(num_empty_cols) + sum(num_empty_rows))
end

function get_galaxy_positions(grid::Vector{Vector{Char}})::Vector{Tuple{Int,Int}}
  positions = []
  for row in eachindex(grid)
    for col in eachindex(grid[row])
      if grid[row][col] == '#'
        push!(positions, (row, col))
      end
    end
  end
  positions
end

function part_1(input::Vector{String})::Int
  grid = parse_input(input)
  grid = expand_map(grid, 1)
  positions = get_galaxy_positions(grid)
  total = 0
  for p_0 in positions
    for p_1 in positions
      if p_0[1] > p_1[1] || (p_0[1] == p_1[1] && p_0[2] >= p_1[2])
        continue
      end
      dist = manhattan_distance(p_0, p_1)
      total += dist
    end
  end
  total
end
@info part_1(input)

function part_2(input::Vector{String})::Int
  grid = parse_input(input)
  positions = get_galaxy_positions(grid)
  total = 0
  for p_0 in positions
    for p_1 in positions
      if p_0[1] > p_1[1] || (p_0[1] == p_1[1] && p_0[2] >= p_1[2])
        continue
      end
      dist = modified_manhattan_distance(p_0, p_1, grid)
      total += dist
    end
  end
  total
end
@info part_2(input)
