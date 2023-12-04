# https://adventofcode.com/2023/day/3

input = readlines("2023/data/day_3.txt")

struct Pos
  x::Int
  y::Int
end

struct NumPos
  num::Int
  poss::Vector{Pos}
end


struct SymPos
  sym::Char
  pos::Pos
end

function parse_line(x)
  y, line = x
  num_matches = findall(r"(\d+)", line)
  sym_matches = findall(r"([^\d\.])", line)
  numPoss = map(num_matches) do match
    poss = map(match) do m
      Pos(m, y)
    end
    NumPos(parse(Int, line[match]), poss)
  end
  symPoss = map(sym_matches) do c
    x = c[1]
    SymPos(line[x], Pos(x, y))
  end
  numPoss, symPoss
end

function parse_input(input::Vector{String})::Tuple{Vector{NumPos},Dict{Pos,Char}}
  numPoss, symPoss = Vector{NumPos}(), Dict{Pos,Char}()
  for poss in parse_line.(enumerate(input))
    append!(numPoss, poss[1])
    for sym in poss[2]
      symPoss[sym.pos] = sym.sym
    end
  end
  numPoss, symPoss
end


function get_boundary(num_pos::NumPos)::Vector{Pos}
  boundary = Vector{Pos}()
  map(num_pos.poss) do pos
    append!(boundary, [Pos(pos.x, pos.y - 1), Pos(pos.x, pos.y + 1)])
  end
  min_x = minimum(map(num_pos.poss) do pos
    pos.x
  end)
  max_x = maximum(map(num_pos.poss) do pos
    pos.x
  end)
  append!(boundary, [
    Pos(max_x + 1, num_pos.poss[1].y - 1),
    Pos(max_x + 1, num_pos.poss[1].y),
    Pos(max_x + 1, num_pos.poss[1].y + 1),
    Pos(min_x - 1, num_pos.poss[1].y - 1),
    Pos(min_x - 1, num_pos.poss[1].y),
    Pos(min_x - 1, num_pos.poss[1].y + 1),
  ])
  boundary
end


function is_adjacent(num_pos::NumPos, symPoss::Dict{Pos,Char})::Bool
  boundary = get_boundary(num_pos)
  for pos in boundary
    if haskey(symPoss, pos)
      return true
    end
  end
  false
end

function get_gear_num(gear::Pos, numPosMap::Dict{Pos,Int})::Int
  nums = Vector{Int}()
  for pos in [
    Pos(gear.x - 1, gear.y - 1),
    Pos(gear.x - 1, gear.y + 1),
    Pos(gear.x - 1, gear.y),
    Pos(gear.x, gear.y - 1),
    Pos(gear.x, gear.y + 1),
    Pos(gear.x + 1, gear.y - 1),
    Pos(gear.x + 1, gear.y + 1),
    Pos(gear.x + 1, gear.y),
  ]
    if haskey(numPosMap, pos)
      append!(nums, numPosMap[pos])
    end
  end
  nums = unique(nums)
  @info nums, gear
  if length(nums) == 2
    return nums[1] * nums[2]
  else
    return 0
  end
end

function part_1(input::Vector{String})
  numPoss, symPoss = parse_input(input)
  sum(map(numPoss) do num_pos
    if is_adjacent(num_pos, symPoss)
      num_pos.num
    else
      0
    end
  end)
end
@info part_1(input)

function part_2(input)
  numPoss, symPoss = parse_input(input)
  numPosMap = Dict{Pos,Int}()
  for num_pos in numPoss
    for pos in num_pos.poss
      numPosMap[pos] = num_pos.num
    end
  end

  gear_poss = filter(pos -> symPoss[pos] == '*', collect(keys(symPoss)))

  @info gear_poss

  sum(map(gear_poss) do gear
    get_gear_num(gear, numPosMap)
  end)
end
@info part_2(input)
