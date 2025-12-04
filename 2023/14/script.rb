# frozen_string_literal: true

class Solution
  def initialize(data)
    @data = data
  end

  def part1
    grid = @data.split("\n").map { |line| line.split("") }
    titled_grid = tilt_north(grid)
    puts sum_loads(titled_grid)
    # pretty_print_board(titled_grid)
  end

  TIMES = 100_000
  def part2
    grid = @data.split("\n").map { |line| line.split("") }
    slow_grid = grid
    fast_grid = grid
    first_instances = {}
    cycle_at = nil
    occurences = Hash.new(0)
    TIMES.times do |i|
      slow_grid = slow_grid
        .yield_self { |grid| cycle(grid) }

      fast_grid = fast_grid
        .yield_self { |grid| cycle(grid) }
        .yield_self { |grid| cycle(grid) }

      # pretty_print_board(cycled_grid)
      diffs = grids_match?(slow_grid, fast_grid)
      hash_key = hash_grid(slow_grid)
      first_instances[hash_key] = i if first_instances[hash_key].nil?
      occurences[hash_key] += 1

      next unless diffs&.size == 0

      puts "cycle at #{i}"
      cycle_at = i if cycle_at.nil?
      break # if occurences.values.max > 50

      # puts "--------------------"
    end

    smallest = slow_grid.dup.map(&:dup)
    initial = slow_grid.dup.map(&:dup)
    current = slow_grid
    length = 0

    loop do
      next_grid = current
        .yield_self { |grid| cycle(grid) }

      length += 1

      unless first_instances[hash_grid(next_grid)]
        first_instances[hash_grid(next_grid)] = cycle_at + length
      end

      if first_instances[hash_grid(next_grid)] < first_instances[hash_grid(current)]
        smallest = next_grid.dup.map(&:dup)
      end

      if grids_match?(initial, next_grid).empty?
        break
      end

      current = next_grid
    end
    # binding.irb

    offset = (length - (1_000_000 - first_instances[hash_grid(smallest)]) % length)

    final = smallest.dup.map(&:dup)
    offset.times do |_i|
      final = final
        .yield_self { |grid| cycle(grid) }
    end

    # pp(counts)
    puts sum_loads(final)
    binding.irb
  end

  def hash_grid(grid)
    grid.flatten.join("")
  end

  def grids_match?(grid1, grid2)
    return if grid1.nil? || grid2.nil?

    diff = []

    grid1.size.times do |i|
      grid1[0].size.times do |j|
        if grid1[i][j] != grid2[i][j]
          diff << [i, j]
        end
      end
    end
    diff
  end

  def sum_loads(grid)
    load = 0
    grid.reverse.each_with_index do |row, y|
      load += row.count("O") * (y + 1)
    end
    load
  end

  def cycle(grid)
    grid
      .yield_self { |grid| tilt(grid, :north) }
      .yield_self { |grid| tilt(grid, :west) }
      .yield_self { |grid| tilt(grid, :south) }
      .yield_self { |grid| tilt(grid, :east) }
  end

  def tilt(grid, directions)
    grid = grid.dup.map(&:dup)

    case directions
    when :north
      res = tilt_north(grid)
      res
    when :west
      res = tilt_north(grid.transpose)
      res.transpose
    when :south
      res = tilt_north(grid.reverse)
      res.reverse
    when :east
      res = tilt_north(grid.transpose.reverse)
      res.reverse.transpose
    end
  end

  def tilt_north(grid)
    grid.transpose.each do |row|
      num_of_stones = row.count("O")
      open_indices = []
      row.size.times do |i|
        case row[i]
        when "."
          open_indices << i
        when "#"
          open_indices = []
        when "O"
          if open_indices[0] && i > open_indices[0]
            row[open_indices.shift] = "O"
            row[i] = "."
            open_indices << i
          end
        end
      end
    end.transpose
  end

  def pretty_print_board(grid, use_color: true)
    require "colorize"

    grid.each do |line|
      line.each do |char|
        unless use_color
          print(char)
          next
        end

        if char == "#"
          print(char.red)
        elsif char == "O"
          print(char.green)
        else
          print(char.white)
        end
      end
      puts
    end
  end
end

Solution.new(File.read("input.txt")).part2
