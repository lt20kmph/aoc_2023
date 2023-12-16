# https://adventofcode.com/2023/day/8
using Base.Iterators

input = readlines("2023/data/day_8.txt")


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

function get_time_to_stop(
  instructions::String,
  nodes::Dict{String,Node},
  current_node::String,
  stoping_condition::Function
)::Int
  counter = 1
  for instruction in cycle(instructions)

    if instruction == 'L'
      current_node = nodes[current_node].left
    elseif instruction == 'R'
      current_node = nodes[current_node].right
    end

    if stoping_condition(current_node)
      return counter
    end

    counter += 1
  end

end

function part_1(input::Vector{String})::Int
  instructions, nodes = parse_input(input)
  current_node = "AAA"
  get_time_to_stop(instructions, nodes, current_node, (node) -> node == "ZZZ")
end

@info part_1(input)

function part_2(input::Vector{String})::Int
  instructions, nodes = parse_input(input)
  current_nodes = [node for node in keys(nodes) if node[end] == 'A']
  ms = []
  for node in current_nodes
    t = get_time_to_stop(instructions, nodes, node, node -> node[end] == 'Z')
    push!(ms, t)
  end
  lcm(ms...)
end
@info part_2(input)
