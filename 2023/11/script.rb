# frozen_string_literal: true

UP = [-1, 0].freeze
RIGHT = [0, 1].freeze
DOWN = [1, 0].freeze
LEFT = [0, -1].freeze

data = File.read("input.txt")

def part1(data)
  grid = data.split("\n").map { |line| line.split("") }
  expand_galaxy(grid)
  # pretty_print_grid(grid)

  all_distances = {}
  grid.size.times do |i|
    grid[0].size.times do |j|
      next unless grid[i][j] == "#"

      results = bfs([i, j], grid)
      all_distances = all_distances.merge(results)
    end
  end
  puts grid.size
  puts all_distances.values.sum
end

EXPANSION_AMOUNT = 999_999

def part2(data)
  grid = data.split("\n").map { |line| line.split("") }
  pretty_print_grid(grid)
  col_no_gal, row_no_gal = find_cols_rows_without_galaxies(grid)
  all_distances = {}
  grid.size.times do |i|
    grid[0].size.times do |j|
      next unless grid[i][j] == "#"

      results = bfs_with_path([i, j], grid)
      all_distances = all_distances.merge(results)
    end
  end
  res = all_distances.map do |key, path|
    path_length = path.size
    # row_exp_factor = row_no_gal.dup
    # col_exp_factor =
    expansion_points = 0
    hit_col = Set.new
    hit_row = Set.new
    path.each do |i, j|
      if row_no_gal.include?(i) && !hit_row.include?(i)
        expansion_points += EXPANSION_AMOUNT
        hit_row.add(i)
      end

      if col_no_gal.include?(j) && !hit_col.include?(j)
        expansion_points += EXPANSION_AMOUNT
        hit_col.add(j)
      end
    end
    # binding.irb if key[0] == [1, 7] && key[1] == [9, 4]
    path_length += expansion_points - 1
    puts "#{key} #{path_length}"
    path_length
  end

  puts(res.sum)
end

def bfs_with_path(start, grid)
  queue = [[start]]
  visited = Set.new
  found_distances = {}
  until queue.empty?
    path = queue.shift
    i, j = path[-1]

    visited.add([i, j])
    if grid[i][j] == "#" && start != [i, j]
      final_path = path.dup
      found_distances[[start, [i, j]].sort] = final_path
      next
    end

    directions = [UP, RIGHT, DOWN, LEFT]

    directions.each do |delta_i, delta_j|
      next_coords = [i + delta_i, j + delta_j]
      adjacent_cell = grid.dig(*next_coords)
      next unless adjacent_cell && !visited.include?(next_coords) && !next_coords.any?(&:negative?)

      new_path = path.dup
      new_path.push(next_coords)
      queue.push(new_path)
    end
  end

  found_distances
end

def find_cols_rows_without_galaxies(grid)
  cols_with_galaxies = Set.new
  rows_with_galaxies = Set.new
  grid.size.times do |i|
    grid[0].size.times do |j|
      if grid[i][j] == "#"
        rows_with_galaxies.add(i)
        cols_with_galaxies.add(j)
      end
    end
  end
  cols_without_galaxies = (0...grid[0].size).to_set - cols_with_galaxies
  rows_without_galaxies = (0...grid.size).to_set - rows_with_galaxies
  [cols_without_galaxies, rows_without_galaxies]
end

def bfs(start, grid)
  queue = [[start]]
  level = 0
  visited = Set.new
  found_distances = {}
  until queue.empty?
    frontier = queue.shift
    next_level = []
    frontier.each do |i, j|
      next if visited.include?([i, j])

      visited.add([i, j])
      if grid[i][j] == "#" && start != [i, j]
        found_distances[[start, [i, j]].sort] = level
      end

      directions = [UP, RIGHT, DOWN, LEFT]

      directions.each do |delta_i, delta_j|
        next_coords = [i + delta_i, j + delta_j]
        adjacent_cell = grid.dig(*next_coords)
        if adjacent_cell && !visited.include?(next_coords) && !next_coords.any?(&:negative?)
          next_level.push(next_coords)
        end
      end
    end
    unless next_level.empty?
      queue.push(next_level)
      level += 1
    end
  end

  found_distances
end

def expand_galaxy(grid)
  cols_with_galaxies = Set.new
  rows_with_galaxies = Set.new
  grid.size.times do |i|
    grid[0].size.times do |j|
      if grid[i][j] == "#"
        rows_with_galaxies.add(i)
        cols_with_galaxies.add(j)
      end
    end
  end
  cols_without_galaxies = (0...grid[0].size).to_set - cols_with_galaxies
  rows_without_galaxies = (0...grid.size).to_set - rows_with_galaxies
  puts "cols #{cols_without_galaxies}"
  puts "rows #{rows_without_galaxies}"

  offset = 0
  cols_without_galaxies.to_a.each do |col_num|
    grid.size.times do |i|
      grid[i].insert(col_num + offset, *Array.new(EXPANSION_AMOUNT) { "." })
    end
    offset += EXPANSION_AMOUNT
  end

  offset = 0
  rows_without_galaxies.to_a.each do |row_num|
    grid.insert(row_num + offset, *Array.new(EXPANSION_AMOUNT) { Array.new(grid[0].size) { "." } })
    offset += EXPANSION_AMOUNT
  end

  nil
end

def pretty_print_grid(grid, use_color: true)
  require "colorize"
  grid.each do |line|
    line.each do |char|
      unless use_color
        print(char)
        next
      end

      if char == "#"
        print(char.red)
      else
        print(char.green)
      end
    end
    puts
  end
end

def part2_manhattan(data)
  grid = data.split("\n").map { |line| line.split("") }
  galaxies = find_galaxies(grid)
  cols_no_gals, rows_no_gals = find_cols_rows_without_galaxies(grid)
  cols_no_gals = cols_no_gals.to_a.sort
  rows_no_gals = rows_no_gals.to_a.sort
  expanded_galaxy_coords = galaxies.map do |i, j|
    num_row_exp = rows_no_gals.count { |y| y < i } * EXPANSION_AMOUNT
    num_col_exp = cols_no_gals.count { |x| x < j } * EXPANSION_AMOUNT
    [i + num_row_exp, j + num_col_exp]
  end
  distances = []
  expanded_galaxy_coords.size.times do |i|
    (i...expanded_galaxy_coords.size).each do |j|
      # puts "#{expanded_galaxy_coords[i]} #{expanded_galaxy_coords[j]}"
      distance = manhattan_distance(expanded_galaxy_coords[i], expanded_galaxy_coords[j])
      distances.push(distance)
    end
  end
  puts distances.sum
end

def manhattan_distance(point_1, point_2)
  sum = 0
  point_1.size.times do |i|
    sum += (point_1[i] - point_2[i]).abs
  end
  sum
end

def find_galaxies(grid)
  galaxies = []
  grid.size.times do |i|
    grid[0].size.times do |j|
      galaxies.push([i, j]) if grid[i][j] == "#"
    end
  end
  galaxies
end

# part1(data)
# part2(data)
part2_manhattan(data)
