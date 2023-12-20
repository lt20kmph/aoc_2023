# https://adventofcode.com/2023/day/19

input = readlines("2023/data/day_19_test_1.txt")

@enum ConditionType gt lt

const ν = 4000

struct Range
  x::Tuple{Int,Int}
  m::Tuple{Int,Int}
  a::Tuple{Int,Int}
  s::Tuple{Int,Int}
end

struct Rule
  attribute::Char
  value::Int
  condition::ConditionType
  destination::String
end

struct Workflow
  name::String
  rules::Vector{Rule}
  destination::String
end

struct Part
  x::Int
  m::Int
  a::Int
  s::Int
end

function parse_rules(rules::Vector{String})::Vector{Rule}
  parsed_rules = Vector{Rule}()
  for rule in rules
    @debug rule
    matches = match(r"(a|m|x|s)(<|>)(\d+):(.+)", rule)
    attribute = only(matches.captures[1])
    condition = matches.captures[2]
    if condition == "<"
      condition = lt
    else
      condition = gt
    end
    value = parse(Int, matches.captures[3])
    destination = matches.captures[4]
    parsed_rule = Rule(attribute, value, condition, destination)
    push!(parsed_rules, parsed_rule)
  end
  parsed_rules
end

function accepted_range(workflow::Workflow)::Range
  x_range = (0, ν)
  m_range = (0, ν)
  a_range = (0, ν)
  s_range = (0, ν)

  for rule in workflow.rules
    if rule.destination == "A"
      if rule.attribute == 'x' && rule.condition == lt
        x_range = (x_range[1], max(x_range[1], rule.value - 1))
      elseif rule.attribute == 'x' && rule.condition == gt
        x_range = (min(x_range[2], rule.value + 1), x_range[2])
      elseif rule.attribute == 'm' && rule.condition == lt
        m_range = (m_range[1], max(m_range[1], rule.value - 1))
      elseif rule.attribute == 'm' && rule.condition == gt
        m_range = (min(m_range[2], rule.value + 1), m_range[2])
      elseif rule.attribute == 'a' && rule.condition == lt
        a_range = (a_range[1], max(a_range[1], rule.value - 1))
      elseif rule.attribute == 'a' && rule.condition == gt
        a_range = (min(a_range[2], rule.value + 1), a_range[2])
      elseif rule.attribute == 's' && rule.condition == lt
        s_range = (s_range[1], max(s_range[1], rule.value - 1))
      elseif rule.attribute == 's' && rule.condition == gt
        s_range = (min(s_range[2], rule.value + 1), s_range[2])
      end
    elseif rule.destination == "R"
      if rule.attribute == 'x' && rule.condition == lt
        x_range = (min(x_range[2], rule.value + 1), x_range[2])
      elseif rule.attribute == 'x' && rule.condition == gt
        x_range = (x_range[1], max(x_range[1], rule.value - 1))
      elseif rule.attribute == 'm' && rule.condition == lt
        m_range = (min(m_range[2], rule.value + 1), m_range[2])
      elseif rule.attribute == 'm' && rule.condition == gt
        m_range = (m_range[1], max(m_range[1], rule.value - 1))
      elseif rule.attribute == 'a' && rule.condition == lt
        a_range = (min(a_range[2], rule.value + 1), a_range[2])
      elseif rule.attribute == 'a' && rule.condition == gt
        a_range = (a_range[1], max(a_range[1], rule.value - 1))
      elseif rule.attribute == 's' && rule.condition == lt
        s_range = (min(s_range[2], rule.value + 1), s_range[2])
      elseif rule.attribute == 's' && rule.condition == gt
        s_range = (s_range[1], max(s_range[1], rule.value - 1))
      end
    end
  end
  Range(x_range, m_range, a_range, s_range)
end

function _join_workflows(workflows::Dict{String,Workflow})::Dict{String,Workflow}
  new_workflows = Dict{String,Workflow}()
  for (_, workflow) in workflows
    if workflow.destination ∈ ["A", "R"]
      new_workflows[workflow.name] = workflow
    else
      destintation_workflow = workflows[workflow.destination]
      new_workflow = Workflow(
        workflow.name,
        vcat(workflow.rules, destintation_workflow.rules),
        destintation_workflow.destination,
      )
      new_workflows[workflow.name] = new_workflow
    end
  end
  new_workflows
end

function join_workflows(workflows::Dict{String,Workflow})::Dict{String,Workflow}
  new_workflows = _join_workflows(workflows)
  while all(workflow -> workflow.destination ∉ ["A", "R"], values(new_workflows))
    new_workflows = _join_workflows(new_workflows)
  end
  new_workflows
end

function parse_input_to_workflows(input::Vector{String})::Dict{String,Workflow}
  workflows = Dict{String,Workflow}()
  for line in input
    if line == ""
      break
    end
    matches = match(r"(.+)\{(.*)\}", line)
    name = matches.captures[1]
    rules = matches.captures[2]
    rules = string.(split(rules, ","))
    destination = rules[end]
    rules = rules[1:end-1]
    @debug name, rules, destination
    workflows[name] = Workflow(name, parse_rules(rules), destination)
  end
  workflows
end

function parse_input_to_parts(input::Vector{String})::Vector{Part}
  parts = Vector{Part}()
  for line in input
    matches = match(r"\{x=(\d+),m=(\d+),a=(\d+),s=(\d+)\}", line)
    if matches === nothing
      continue
    end
    part = Part(
      parse(Int, matches.captures[1]),
      parse(Int, matches.captures[2]),
      parse(Int, matches.captures[3]),
      parse(Int, matches.captures[4])
    )
    push!(parts, part)
  end
  parts
end

function apply_rule(rule::Rule, part::Part)::String
  if rule.condition == lt
    if rule.attribute == 'a'
      if part.a < rule.value
        return rule.destination
      end
    elseif rule.attribute == 'm'
      if part.m < rule.value
        return rule.destination
      end
    elseif rule.attribute == 'x'
      if part.x < rule.value
        return rule.destination
      end
    elseif rule.attribute == 's'
      if part.s < rule.value
        return rule.destination
      end
    end
  elseif rule.condition == gt
    if rule.attribute == 'a'
      if part.a > rule.value
        return rule.destination
      end
    elseif rule.attribute == 'm'
      if part.m > rule.value
        return rule.destination
      end
    elseif rule.attribute == 'x'
      if part.x > rule.value
        return rule.destination
      end
    elseif rule.attribute == 's'
      if part.s > rule.value
        return rule.destination
      end
    end
  end
  ""
end

function is_part_accepted(workflows::Dict{String,Workflow}, part::Part, workflow_name::String)::Bool
  for rule in workflows[workflow_name].rules
    destination = apply_rule(rule, part)
    @info "destination", destination
    if destination == ""
      continue
    elseif destination == "A"
      return true
    elseif destination == "R"
      return false
    else
      return is_part_accepted(workflows, part, destination)
    end
  end
  wf_destination = workflows[workflow_name].destination
  if wf_destination == "A"
    return true
  elseif wf_destination == "R"
    return false
  else
    return is_part_accepted(workflows, part, wf_destination)
  end
end

function part_sum(part::Part)::Int
  part.x + part.m + part.a + part.s
end

function part_1(input::Vector{String})::Int
  workflows = parse_input_to_workflows(input)
  parts = parse_input_to_parts(input)
  for part in parts
    @info is_part_accepted(workflows, part, "in")
  end
  sum(map(part_sum, filter(part -> is_part_accepted(workflows, part, "in"), parts)))
end
@info part_1(input)

function calculate_combinations(ranges::Vector{Range})::Int
  for range in ranges
    @info 'a', range.a
    @info 'm', range.m
    @info 'x', range.x
    @info 's', range.s
    @info 'a'^30
  end
  0
end

function part_2(input::Vector{String})::Int
  workflows = parse_input_to_workflows(input)
  workflows = join_workflows(workflows)
  ranges = accepted_range.(values(workflows))
  for (workflow, range) in zip(values(workflows), ranges)
    @info workflow, range
  end
  calculate_combinations(ranges)
  0
end
@info part_2(input)
