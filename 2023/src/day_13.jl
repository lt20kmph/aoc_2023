# https://adventofcode.com/2023/day/13

input = readlines("2023/data/day_13.txt")

const Notes = Vector{Vector{Char}}

function parse_input(input::Vector{String})::Vector{Notes}
  notes = Vector{Notes}()
  new_notes = Notes()
  for line in input
    if line == ""
      push!(notes, new_notes)
      new_notes = Notes()
    end
    if line != ""
      push!(new_notes, collect(line))
    end
  end
  push!(notes, new_notes)
  notes
end

function find_horizontal_los(notes::Notes)::Int
  los = 0
  for i in eachindex(notes)
    m = min(i, length(notes) - i)
    if m ∈ [0, length(notes) - 1]
      continue
    end
    if all([notes[i+j+1] == notes[i-j] for j in 0:(m-1)])
      los = i
      break
    end
  end
  los
end

function find_horizontal_loss(notes::Notes)::Vector{Int}
  loss = []
  for i in eachindex(notes)
    m = min(i, length(notes) - i)
    if m ∈ [0, length(notes) - 1]
      continue
    end
    if all([notes[i+j+1] == notes[i-j] for j in 0:(m-1)])
      push!(loss, i)
    end
  end
  loss
end

function transpose(notes::Notes)::Notes
  new_notes = Notes()
  for i in eachindex(notes[1])
    new_row = Vector{Char}()
    for j in eachindex(notes)
      push!(new_row, notes[j][i])
    end
    push!(new_notes, new_row)
  end
  new_notes
end

function test_smudges(notes::Notes)::Vector{Notes}
  potential_smudges = Vector{Notes}()
  for i in eachindex(notes)
    for j in eachindex(notes[i])
      new_notes = deepcopy(notes)
      if notes[i][j] == '#'
        new_notes[i][j] = '.'
        push!(potential_smudges, new_notes)
      end
      if notes[i][j] == '.'
        new_notes[i][j] = '#'
        push!(potential_smudges, new_notes)
      end
    end
  end
  potential_smudges
end

function find_vertical_los(notes::Notes)::Int
  notes = transpose(notes)
  find_horizontal_los(notes)
end

function find_vertical_loss(notes::Notes)::Vector{Int}
  notes = transpose(notes)
  find_horizontal_loss(notes)
end

function part_1(input::Vector{String})::Int
  notes = parse_input(input)
  total = 0
  for note in notes
    total += 100 * find_horizontal_los(note)
    total += find_vertical_los(note)
  end
  total

end
@info part_1(input)

function part_2(input::Vector{String})::Int
  notes = parse_input(input)
  total = 0
  for (i, note) in enumerate(notes)
    potential_smudges = test_smudges(note)
    v_los_note = find_vertical_los(note)
    h_los_note = find_horizontal_los(note)
    for smudge in potential_smudges
      h_loss = find_horizontal_loss(smudge)
      v_loss = find_vertical_loss(smudge)
      v_loss = filter(x -> x != v_los_note, v_loss)
      h_loss = filter(x -> x != h_los_note, h_loss)
      if length(h_loss) == 0 && length(v_loss) == 0
        continue
      end
      h_los = 0
      v_los = 0
      if length(h_loss) == 1
        h_los = h_loss[1]
      end
      if length(v_loss) == 1
        v_los = v_loss[1]
      end
      if v_los == v_los_note
        v_los = 0
      end
      if h_los == h_los_note
        h_los = 0
      end
      @info h_los, v_los
      total += 100 * h_los
      total += v_los
      if h_los > 0 || v_los > 0
        @info "breaking", i
        break
      end
    end
  end
  total
end
@info part_2(input)

function test(input::Vector{String})::Int
  notes = parse_input(input)
  @info "\n" * join(map(row -> join(row, ""), notes[5]), "\n")
  @info find_horizontal_los(notes[5])
  @info find_vertical_los(notes[5])
  new_notes = deepcopy(notes[5])
  new_notes[7][7] = '#'
  @info "\n" * join(map(row -> join(row, ""), new_notes), "\n")
  @info find_horizontal_loss(new_notes)
  @info find_vertical_loss(new_notes)

  potential_smudges = test_smudges(new_notes)
  total = 0
  for smudge in potential_smudges
    h_loss = find_horizontal_loss(smudge)
    v_loss = find_vertical_loss(smudge)
    v_loss = filter(x -> x != find_vertical_loss(new_notes), v_loss)
    h_loss = filter(x -> x != find_horizontal_loss(new_notes), h_loss)
    if length(h_loss) == 0 && length(v_loss) == 0
      continue
    end
    h_los = 0
    v_los = 0
    if length(h_loss) == 1
      h_los = h_loss[1]
    end
    if length(v_loss) == 1
      v_los = v_loss[1]
    end
    total += 100 * h_los
    total += v_los
    if h_los > 0 || v_los > 0
      @info "breaking" 
      break
    end
  end
  @info total
  0
end
# test(input)
