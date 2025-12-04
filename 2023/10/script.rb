# frozen_string_literal: true

data = File.read("input.txt")

def part1(data)
  grid = data.split("\n").map { |line| line.split("") }
  # puts grid
  start = [nil, nil]
  grid.size.times do |i|
    grid[0].size.times do |j|
      start = [i, j] if grid[i][j] == "S"
    end
  end

  visited = Set.new
  level = 0
  queue = [[start]]
  directions = [[-1, 0], [0, -1], [1, 0], [0, 1]]

  until queue.empty?
    frontier = queue.shift
    next_level = []
    frontier.each do |i, j|
      next if visited.include?([i, j])

      visited.add([i, j])

      directions = if grid[i][j] == "S"
        valid_s_directions([i, j], grid)
      else
        valid_directions(grid[i][j])
      end

      directions.each do |delta_i, delta_j|
        next_coords = [i + delta_i, j + delta_j]
        adjacent_cell = grid.dig(*next_coords)
        if adjacent_cell && adjacent_cell != "." && !visited.include?(next_coords)
          next_level.push(next_coords)
        end
      end
    end
    unless next_level.empty?
      queue.push(next_level)
      level += 1
    end
  end
  puts level
end

UP = [-1, 0].freeze
RIGHT = [0, 1].freeze
DOWN = [1, 0].freeze
LEFT = [0, -1].freeze
NORTHEAST = [-1, 1].freeze
SOUTHEAST = [1, 1].freeze
SOUTHWEST = [1, -1].freeze
NORTHWEST = [-1, -1].freeze

def valid_s_directions(starting_coords, grid)
  i, j = starting_coords

  valid = []
  up = grid.dig(i + UP[0], j + UP[1])
  if up
    valid.push(UP) if ["|", "F", "7"].include?(up)
  end
  right = grid.dig(i + RIGHT[0], j + RIGHT[1])
  if right
    valid.push(RIGHT) if ["-", "7", "J"].include?(right)
  end

  down = grid.dig(i + DOWN[0], j + DOWN[1])
  if down
    valid.push(DOWN) if ["|", "J", "L"].include?(down)
  end

  left = grid.dig(i + LEFT[0], j + LEFT[1])
  if left
    valid.push(LEFT) if ["-", "L", "F"].include?(left)
  end

  valid
end

def valid_directions(char)
  case char
  when "|"
    [UP, DOWN]
  when "-"
    [RIGHT, LEFT]
  when "L"
    [UP, RIGHT]
  when "J"
    [LEFT, UP]
  when "7"
    [LEFT, DOWN]
  when "F"
    [DOWN, RIGHT]
  when "S"
    raise "not implemented"
  else
    binding.irb
    raise "Unknown direction #{char}"
  end
end

def part2(data)
  grid = data.split("\n").map { |line| line.split("") }
  start = [nil, nil]
  grid.size.times do |i|
    grid[0].size.times do |j|
      start = [i, j] if grid[i][j] == "S"
    end
  end

  visited = Set.new
  level = 0
  queue = [[start]]
  viz = Array.new(grid.size) { Array.new(grid[0].size) { "." } }

  until queue.empty?
    frontier = queue.shift
    next_level = []
    frontier.each do |i, j|
      next if visited.include?([i, j])

      visited.add([i, j])
      viz[i][j] = grid[i][j]

      directions = if grid[i][j] == "S"
        valid_s_directions([i, j], grid)
      else
        valid_directions(grid[i][j])
      end

      directions.each do |delta_i, delta_j|
        next_coords = [i + delta_i, j + delta_j]
        adjacent_cell = grid.dig(*next_coords)
        if adjacent_cell && adjacent_cell != "." && !visited.include?(next_coords)
          next_level.push(next_coords)
        end
      end
    end
    unless next_level.empty?
      queue.push(next_level)
      level += 1
    end
  end

  # pretty_print_board(viz)

  viz[start[0]][start[1]] = s_true(start, viz)

  visited = Set.new
  expanded_board = expand_board(viz)
  # pretty_print_board(expanded_board)
  expanded_board.size.times do |i|
    expanded_board[0].size.times do |j|
      next if visited.include?([i, j]) || expanded_board[i][j] != "."

      flood_fill_expanded_board([i, j], expanded_board, visited)
    end
  end

  pretty_print_board(expanded_board)

  count = 0
  viz.size.times do |i|
    viz[0].size.times do |j|
      all_dots = true
      3.times do |delta_i|
        3.times do |delta_j|
          all_dots = false if expanded_board[i * 3 + delta_i][j * 3 + delta_j] != "I"
        end
      end
      count += 1 if all_dots
    end
  end
  puts(count)
end

def expand_board(grid)
  big_board = Array.new(grid.size * 3) { Array.new(grid[0].size * 3) { "." } }
  grid.size.times do |i|
    grid[0].size.times do |j|
      original_char = grid[i][j]
      block = expanded_block_from_char(original_char)
      implant_on_board([i, j], block, big_board)
    end
  end
  big_board
end

def implant_on_board(original_coords, block_to_implant, big_board)
  i, j = original_coords
  3.times do |delta_i|
    3.times do |delta_j|
      big_board[i * 3 + delta_i][j * 3 + delta_j] = block_to_implant[delta_i][delta_j]
    end
  end

  nil
end

def expanded_block_from_char(char)
  {
    "L" => [
      [".", "#", "."],
      [".", "#", "#"],
      [".", ".", "."],
    ],
    "J" => [
      [".", "#", "."],
      ["#", "#", "."],
      [".", ".", "."],
    ],
    "7" => [
      [".", ".", "."],
      ["#", "#", "."],
      [".", "#", "."],
    ],
    "F" => [
      [".", ".", "."],
      [".", "#", "#"],
      [".", "#", "."],
    ],
    "|" => [
      [".", "#", "."],
      [".", "#", "."],
      [".", "#", "."],
    ],
    "-" => [
      [".", ".", "."],
      ["#", "#", "#"],
      [".", ".", "."],
    ],
    "." => [
      [".", ".", "."],
      [".", ".", "."],
      [".", ".", "."],
    ],
  }.fetch(char)
end

def flood_fill_expanded_board(start, grid, visited)
  queue = [[start]]

  touched = []
  reaches_outside = false
  until queue.empty?
    frontier = queue.shift
    next_level = []
    frontier.each do |i, j|
      next if visited.include?([i, j])

      visited.add([i, j])
      if (i == 0 || j == 0 || i == grid.size - 1 || j == grid[0].size - 1) && grid[i][j] == "."
        reaches_outside = true
      end

      directions = [UP, DOWN, LEFT, RIGHT]
      directions.each do |delta_i, delta_j|
        next_coords = [i + delta_i, j + delta_j]
        adjacent_cell = grid.dig(*next_coords)
        if adjacent_cell && !visited.include?(next_coords) && next_coords.none?(&:negative?) && adjacent_cell == "."
          next_level.push(next_coords)
        end
      end
      touched.push([i, j]) if grid[i][j] == "."
    end
    unless next_level.empty?
      queue.push(next_level)
    end
  end

  fill_color = reaches_outside ? "O" : "I"
  touched.each do |i, j|
    grid[i][j] = fill_color
  end
end

def part2_parity(data)
  puts("parity solution")
  grid = data.split("\n").map { |line| line.split("") }
  start = [nil, nil]
  grid.size.times do |i|
    grid[0].size.times do |j|
      start = [i, j] if grid[i][j] == "S"
    end
  end

  visited = Set.new
  level = 0
  queue = [[start]]
  viz = Array.new(grid.size) { Array.new(grid[0].size) { "." } }

  until queue.empty?
    frontier = queue.shift
    next_level = []
    frontier.each do |i, j|
      next if visited.include?([i, j])

      visited.add([i, j])
      viz[i][j] = grid[i][j]

      directions = if grid[i][j] == "S"
        valid_s_directions([i, j], grid)
      else
        valid_directions(grid[i][j])
      end

      directions.each do |delta_i, delta_j|
        next_coords = [i + delta_i, j + delta_j]
        adjacent_cell = grid.dig(*next_coords)
        if adjacent_cell && adjacent_cell != "." && !visited.include?(next_coords)
          next_level.push(next_coords)
        end
      end
    end
    unless next_level.empty?
      queue.push(next_level)
      level += 1
    end
  end

  # pretty_print_board(viz)

  viz.size.times do |i|
    line = viz[i]
    is_inside = false
    line.size.times do |j|
      if ["L", "J", "|"].include?(line[j]) || (line[j] == "S" && ["L", "J", "|"].include?(s_true([i, j], viz)))
        is_inside = !is_inside
        next
      end
      viz[i][j] = is_inside ? "I" : "O" if viz[i][j] == "."
    end
  end

  pretty_print_board(viz)

  counts = viz.sum do |line|
    line.count { |x| x == "I" }
  end
  puts counts
end

def s_true(s_coords, grid)
  directions = valid_s_directions(s_coords, grid)
  char = nil
  char = "L" if (directions & [UP, RIGHT]).any?
  char = "|" if (directions & [UP, DOWN]).any?
  char = "J" if (directions & [UP, LEFT]).any?
  char = "F" if (directions & [DOWN, RIGHT]).any?
  char = "7" if (directions & [DOWN, LEFT]).any?
  char = "-" if (directions & [LEFT, RIGHT]).any?
  char
end

def pretty_print_board(grid, use_color: true)
  require "colorize"

  grid.each do |line|
    line.each do |char|
      unless use_color
        print(char)
        next
      end

      if char == "." || char == "I"
        print(char.red)
      elsif char == "O"
        print(char.black)
      else
        print(char.green)
      end
    end
    puts
  end
end

part2(data)
# part2_parity(data)
