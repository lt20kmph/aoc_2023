# https://adventofcode.com/2023/day/7

input = readlines("2023/data/day_7.txt")


struct Bid
  hand::String
  value::Int
end

function parse_bid(line::String)::Bid
  hand, value = split(line, " ")
  Bid(hand, parse(Int, value))
end

count_char(s) = begin
  res = Dict{Char,Int}()
  for c in s
    if haskey(res, c)
      res[c] += 1
    else
      res[c] = 1
    end
  end
  res
end

function num_J(hand::String)::Int
  get(count_char(hand), 'J', 0)
end

function is_five_of_a_kind(hand::String)::Bool
  return length(unique(hand)) == 1
end

function is_four_of_a_kind(hand::String)::Bool
  if length(unique(hand)) != 2
    return false
  end
  return sort(collect(values(count_char(hand)))) == [1, 4]
end

function is_full_house(hand::String)::Bool
  if length(unique(hand)) != 2
    return false
  end
  return sort(collect(values(count_char(hand)))) == [2, 3]
end

function is_three_of_a_kind(hand::String)::Bool
  if length(unique(hand)) != 3
    return false
  end
  return sort(collect(values(count_char(hand)))) == [1, 1, 3]
end

function is_two_pairs(hand::String)::Bool
  if length(unique(hand)) != 3
    return false
  end
  return sort(collect(values(count_char(hand)))) == [1, 2, 2]
end

function is_one_pair(hand::String)::Bool
  if length(unique(hand)) != 4
    return false
  end
  return sort(collect(values(count_char(hand)))) == [1, 1, 1, 2]
end

function is_high_card(hand::String)::Bool
  return length(unique(hand)) == 5
end

function is_five_of_a_kind_2(hand::String)::Bool
  num_j = num_J(hand)
  if num_j == 0
    return is_five_of_a_kind(hand)
  end
  if num_j == 1
    return is_four_of_a_kind(hand)
  end
  if num_j == 2
    return is_full_house(hand)
  end
  if num_j == 3
    return is_one_pair(hand)
  end
  if num_j in [4, 5]
    return true
  end
end

function is_four_of_a_kind_2(hand::String)::Bool
  num_j = num_J(hand)
  if num_j == 0
    return is_four_of_a_kind(hand)
  end
  if num_j == 1
    return is_three_of_a_kind(hand)
  end
  if num_j == 2
    return is_two_pairs(hand)
  end
  if num_j == 3
    return is_one_pair(hand) || is_high_card(hand) || is_three_of_a_kind(hand)
  end
  if num_j in [4, 5]
    return false
  end
end

function is_full_house_2(hand::String)::Bool
  num_j = num_J(hand)
  if num_j == 0
    return is_full_house(hand)
  end
  if num_j == 1
    return is_three_of_a_kind(hand) || is_two_pairs(hand)
  end
  if num_j == 2
    return is_two_pairs(hand)
  end
  if num_j == 3
    return is_one_pair(hand) || is_high_card(hand)
  end
  if num_j in [4, 5]
    return false
  end
end

function is_three_of_a_kind_2(hand::String)::Bool
  num_j = num_J(hand)
  if num_j == 0
    return is_three_of_a_kind(hand)
  end
  if num_j == 1
    return is_two_pairs(hand) || is_one_pair(hand)
  end
  if num_j == 2
    return is_one_pair(hand) || is_high_card(hand)
  end
  if num_j in [3, 4, 5]
    return false
  end
end

function is_two_pairs_2(hand::String)::Bool
  num_j = num_J(hand)
  if num_j == 0
    return is_two_pairs(hand)
  end
  if num_j == 1
    return is_one_pair(hand) || is_high_card(hand)
  end
  if num_j in [2, 3, 4, 5]
    return false
  end
end

function is_one_pair_2(hand::String)::Bool
  num_j = num_J(hand)
  if num_j == 0
    return is_one_pair(hand)
  end
  if num_j == 1
    return is_high_card(hand)
  end
  if num_j in [2, 3, 4, 5]
    return false
  end
end

function is_high_card_2(hand::String)::Bool
  num_j = num_J(hand)
  if num_j == 0
    return is_high_card(hand)
  end
  if num_j in [1, 2, 3, 4, 5]
    return false
  end
end


ranking_1 = [
  'A',
  'K',
  'Q',
  'J',
  'T',
  '9',
  '8',
  '7',
  '6',
  '5',
  '4',
  '3',
  '2'
]

ranking_2 = [
  'A',
  'K',
  'Q',
  'T',
  '9',
  '8',
  '7',
  '6',
  '5',
  '4',
  '3',
  '2',
  'J'
]

function compare_hands(a::String, b::String, ranking::Vector{Char})::Bool
  for i in 1:5
    if findfirst(x -> x == a[i], ranking) > findfirst(x -> x == b[i], ranking)
      return true
    end
    if findfirst(x -> x == a[i], ranking) < findfirst(x -> x == b[i], ranking)
      return false
    end
  end
end

function lt(a::Bid, b::Bid)::Bool
  rank_a, rank_b = 0, 0
  for (i, f) in enumerate([
    is_five_of_a_kind,
    is_four_of_a_kind,
    is_full_house,
    is_three_of_a_kind,
    is_two_pairs,
    is_one_pair,
    is_high_card
  ])
    if f(a.hand)
      rank_a = i
    end
    if f(b.hand)
      rank_b = i
    end
  end
  @info rank_a, rank_b, a.hand, b.hand
  if rank_a < rank_b
    return false
  end
  if rank_a > rank_b
    return true
  end

  compare_hands(a.hand, b.hand, ranking_1)

end

function get_rank_hand(hand::String)::Int
  for (i, f) in enumerate([
    is_five_of_a_kind,
    is_four_of_a_kind,
    is_full_house,
    is_three_of_a_kind,
    is_two_pairs,
    is_one_pair,
    is_high_card
  ])
    if f(hand)
      return i
    end
  end
end

function get_max_rank_hand(hand::String)::Int
  minimum(
    [get_rank_hand(replace(hand, "J" => c)) for c in ranking_1]
  )
end

function lt_3(a::Bid, b::Bid)::Bool
  mr_a = get_max_rank_hand(a.hand)
  mr_b = get_max_rank_hand(b.hand)
  @info mr_a, a.hand 
  @info mr_b, b.hand
  if mr_a == mr_b
    return compare_hands(a.hand, b.hand, ranking_2)
  end
  return mr_a > mr_b
end

function lt_2(a::Bid, b::Bid)::Bool
  rank_a, rank_b = 1, 1
  for (i, f) in enumerate([
    is_five_of_a_kind_2,
    is_four_of_a_kind_2,
    is_full_house_2,
    is_three_of_a_kind_2,
    is_two_pairs_2,
    is_one_pair_2,
    is_high_card_2,
  ])
    if f(a.hand)
      rank_a = i
      break
    end
  end

  for (i, f) in enumerate([
    is_five_of_a_kind_2,
    is_four_of_a_kind_2,
    is_full_house_2,
    is_three_of_a_kind_2,
    is_two_pairs_2,
    is_one_pair_2,
    is_high_card_2,
  ])
    if f(b.hand)
      rank_b = i
      break
    end
  end

  if num_J(a.hand) == 3 || num_J(b.hand) == 3
    @info rank_a, rank_b, a.hand, b.hand
  end

  # @info rank_a, rank_b, a.hand, b.hand
  if rank_a < rank_b
    return false
  end
  if rank_a > rank_b
    return true
  end

  compare_hands(a.hand, b.hand, ranking_2)

end

function part_1(input::Vector{String})::Int
  bids = parse_bid.(input)
  bids = sort(bids, lt=lt)
  return sum(b.value * i for (i, b) in enumerate(bids))
end
@info part_1(input), "1"

function part_2(input::Vector{String})::Int
  bids = parse_bid.(input)
  bids = sort(bids, lt=lt_3)
  @info bids
  return sum(b.value * i for (i, b) in enumerate(bids))
end
@info part_2(input), "2"
