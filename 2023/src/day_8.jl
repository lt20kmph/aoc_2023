# https://adventofcode.com/2023/day/8
using Base.Iterators

input = readlines("2023/data/day_8_test_3.txt")


struct Node
  label::String
  left::String
  right::String
end

function parse_input(input::Vector{String})::Tuple{String,Dict{String,Node}}
  instructions = input[1]
  nodes = Dict{String,Node}()
  for line in input[3:end]
    parts = split(line, " = ")
    label = strip(parts[1])
    lefts_rights = split(strip(parts[2], ['(', ')']), ",")
    left = strip(lefts_rights[1])
    right = strip(lefts_rights[2])
    nodes[label] = Node(label, left, right)
  end
  return (instructions, nodes)
end

function part_1(input::Vector{String})
  :Int
  instructions, nodes = parse_input(input)
  counter = 1
  current_node = "AAA"
  for instruction in cycle(instructions)

    if instruction == 'L'
      current_node = nodes[current_node].left
    elseif instruction == 'R'
      current_node = nodes[current_node].right
    end

    if current_node == "ZZZ"
      return counter
    end

    counter += 1
  end

end
@info part_1(input)

function check_at_end(current_nodes::Vector{String})
  return all([node[end] == 'Z' for node in current_nodes])
end

function part_2(input)
  instructions, nodes = parse_input(input)
  counter = 1
  current_nodes = [node for node in keys(nodes) if node[end] == 'A']
  for instruction in cycle(instructions)

    if instruction == 'L'
      current_nodes = [nodes[node].left for node in current_nodes]
    elseif instruction == 'R'
      current_nodes = [nodes[node].right for node in current_nodes]
    end

    @info current_nodes

    if check_at_end(current_nodes)
      return counter
    end

    counter += 1
  end
end
@info part_2(input)
