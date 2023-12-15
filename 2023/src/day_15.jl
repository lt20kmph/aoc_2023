# https://adventofcode.com/2023/day/15

input = readlines("2023/data/day_15.txt")

function compute_hash(input::String)::Int
  hash = 0
  for c in input
    hash = ((hash + Int(c)) * 17) % 256
  end
  hash
end

struct Lens
  code::String
  focal_length::Int
end

const LensBoxes = Vector{Vector{Lens}}

function part_1(input::Vector{String})::Int
  sum([compute_hash(x) for x in split(input[1], ",")])
end
@info part_1(input)

function remove_lens!(boxes::LensBoxes, box_index::Int, lens::Lens)
  lenses = boxes[box_index]
  boxes[box_index] = [l for l in lenses if l.code != lens.code]
end


function add_lens!(boxes::LensBoxes, box_index::Int, lens::Lens)
  lenses = boxes[box_index]
  if lens.code in [l.code for l in lenses]
    lens_index = findfirst(x -> x == lens.code, [l.code for l in lenses])
    new_lens = Lens(lens.code, lens.focal_length)
    lenses[lens_index] = new_lens
  else
    push!(lenses, lens)
  end
  boxes[box_index] = lenses
end

function code_to_op(code::SubString)
  if '-' in code
    return remove_lens!
  end
  add_lens!
end

function code_to_data(code::SubString)
  if '-' in code
    return Lens(code[1:end-1], 0)
  end
  focal_length = parse(Int, split(code, "=")[2])
  return Lens(split(code, "=")[1], focal_length)
end

function score(boxes::LensBoxes)::Int
  total = 0
  for (i, box) in enumerate(boxes)
    for (j, lens) in enumerate(box)
      total += lens.focal_length * i * j
    end
  end
  total
end

function part_2(input::Vector{String})::Int
  boxes = [Vector{Lens}() for _ in 1:256]
  for code in split(input[1], ",")
    data = code_to_data(code)
    box_index = compute_hash(data.code)
    code_to_op(code)(boxes, box_index + 1, data)
  end
  score(boxes)
end
@info part_2(input)
