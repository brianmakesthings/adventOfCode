# frozen_string_literal: true

data = File.read("input.txt")

def part1(data)
  puzzles = data.split("\n\n").map { |line| line.split("\n").map { |row| row.split("") } }
  # print(puzzles[0])
  split_points = puzzles.each_with_object({}) do |puzzle, acc|
    split_index = nil
    transposed = false
    2.times do |i|
      if i == 1
        puzzle = puzzle.transpose
        transposed = true
      end
      potential_split_points = find_potential_split_point(puzzle)
      split_index = potential_split_points.find do |index|
        is_split_point(puzzle, index)
      end
      break if split_index
    end
    raise "No split point found" unless split_index

    puts "#{split_index} - #{transposed}"

    if transposed
      acc[:vertical] = acc.fetch(:vertical, 0) + split_index + 1
    else
      acc[:horizontal] = acc.fetch(:horizontal, 0) + split_index + 1
    end
  end
  puts split_points[:horizontal] * 100 + split_points[:vertical]
end

def find_potential_split_point(puzzle)
  # split point if tow neighbouring rows are the same
  results = []
  puzzle.each_cons(2).with_index do |(row1, row2), index|
    results.push(index) if row1 == row2
  end

  results
end

def is_split_point(puzzle, index)
  left = puzzle[0..index]
  right = puzzle[index + 1..]
  min_len = [left.length, right.length].min

  left.reverse[0..min_len - 1] == right[0..min_len - 1]
end

def find_potential_split_point_with_smudge(puzzle)
  results = []
  puzzle.each_cons(2).with_index do |(row1, row2), index|
    one_off_match = one_off_match(row1, row2)
    results.push([index, one_off_match]) if one_off_match
  end

  results
end

def one_off_match(row1, row2)
  index = nil
  mismatches = 0
  row1.size.times do |i|
    next unless row1[i] != row2[i]

    if mismatches == 1
      return nil
    end

    mismatches += 1
    index = i
  end

  if mismatches <= 1
    index
  end
end

# part1(data)
def is_split_point_with_smudge(puzzle, index)
  left = puzzle[0..index].dup.map(&:dup)
  right = puzzle[index + 1..].dup.map(&:dup)
  min_len = [left.length, right.length].min

  left = left.reverse[0..min_len - 1]
  right = right[0..min_len - 1]

  mismatches = 0
  left.size.times do |i|
    left[i].size.times do |j|
      next unless left[i][j] != right[i][j]
      if mismatches == 1
        return false
      end

      # make the smudge
      left[i][j] = right[i][j]
      # binding.irb
      mismatches += 1
    end
  end

  mismatches == 1 && left == right
end

def part2(data)
  puzzles = data.split("\n\n").map { |line| line.split("\n").map { |row| row.split("") } }
  # print(puzzles[0])
  split_points = puzzles.each_with_object({}) do |puzzle, acc|
    split_index = nil
    transposed = false
    seen_first_match = nil
    2.times do |i|
      if i == 1
        puzzle = puzzle.transpose
        transposed = true
      end
      #
      # find first match
      potential_split_points = find_potential_split_point(puzzle)
      split_index = potential_split_points.find do |index|
        is_split_point(puzzle, index)
      end
      seen_first_match = [split_index, transposed]
      break if split_index
    end

    unless split_index
      binding.irb
      raise "no initial match found"
    end

    split_index = nil
    puzzle = puzzle.transpose if transposed
    transposed = false
    2.times do |i|
      if i == 1
        puzzle = puzzle.transpose
        transposed = true
      end
      # apply smudge outside reflection point
      potential_split_points = find_potential_split_point(puzzle)
      if seen_first_match && seen_first_match[1] == transposed
        potential_split_points.delete(seen_first_match[0])
      end

      split_index = potential_split_points.find do |index|
        is_split_point_with_smudge(puzzle, index)
      end

      break if split_index

      potential_split_points = find_potential_split_point_with_smudge(puzzle)
      split_index, _ = potential_split_points.find do |index, smudge|
        smuged_puzzle = Marshal.load(Marshal.dump(puzzle))
        smuged_puzzle[index][smudge] = smuged_puzzle[index + 1][smudge]
        is_split_point(smuged_puzzle, index)
      end

      break if split_index
    end
    unless split_index
      binding.irb
      raise "No split point found"
    end

    puts "#{split_index} - #{transposed}"

    if transposed
      acc[:vertical] = acc.fetch(:vertical, 0) + split_index + 1
    else
      acc[:horizontal] = acc.fetch(:horizontal, 0) + split_index + 1
    end
  end
  puts split_points.fetch(:horizontal, 0) * 100 + split_points.fetch(:vertical, 0)
end

part2(data)
