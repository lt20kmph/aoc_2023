# https://adventofcode.com/2023/day/10

input = readlines("2023/data/day_10_test_1.txt")

function parse_input(input::Vector{String})::Vector{Vector{Char}}
  map(x -> collect(x), input)
end

struct LoopPos
  dist::Int
  x::Int
  y::Int
end

function is_connected(δ_x::Int, δ_y::Int, pipe::Char)::Bool
  if δ_x == 1 && δ_y == 0
    return pipe in ['-', 'J', '7']
  elseif δ_y == 1 && δ_x == 0
    return pipe in ['|', '7', 'J']
  elseif δ_x == -1 && δ_y == 0
    return pipe in ['-', 'L', 'F']
  elseif δ_y == -1 && δ_x == 0
    return pipe in ['|', '7', 'F']
  else
    return false
  end
end

function find_loop(map::Vector{Vector{Char}})::Vector{LoopPos}
  start_pos = LoopPos(0, 0, 0)

  for (i, row) in enumerate(map)
    for (j, col) in enumerate(row)
      if col == 'S'
        start_pos = LoopPos(0, i, j)
      end
    end
  end

  @info start_pos

  loop_pos = [start_pos]

  loop_ends = [start_pos, start_pos]

  find_loop!(map, loop_pos, loop_ends)

  while loop_ends[1].x != loop_ends[2].x || loop_ends[1].y != loop_ends[2].y
    find_loop!(map, loop_pos, loop_ends)
  end

  loop_pos
end


function find_loop!(map::Vector{Vector{Char}}, loop_pos::Vector{LoopPos}, loop_ends::Vector{LoopPos})
  max_x = length(map[1])
  max_y = length(map)

  for (i, loop_end) in enumerate(loop_ends)
    for (δ_x, δ_y) in [(1, 0), (0, 1), (-1, 0), (0, -1)]
      if loop_end.x + δ_x > 0 && loop_end.x + δ_x <= max_x && loop_end.y + δ_y > 0 && loop_end.y + δ_y <= max_y
        if is_connected(δ_x, δ_y, map[loop_end.y+δ_y][loop_end.x+δ_x])
          ν = LoopPos(loop_end.dist + 1, loop_end.x + δ_x, loop_end.y + δ_y)
          @info ν, i, "ν"
          if !((ν.x, ν.y) in [(x.x, x.y) for x in loop_pos])
            loop_ends[i] = ν
            push!(loop_pos, ν)
            break
          end
        end
      end
    end
  end
  @info loop_ends, "loop_ends"
  @info loop_pos, "loop_pos"
end


function part_1(input::Vector{String})::Int
  map = parse_input(input)
  @info map
  loop_pos = find_loop(map)
  @info loop_pos
  0
end
@info part_1(input)

function part_2(input)
  nothing
end
@info part_2(input)
