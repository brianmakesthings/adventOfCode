# frozen_string_literal: true

require "algorithms"
require "debug"

data = File.read("./input.txt")

NORTH_DELTA = [-1, 0].freeze
EAST_DELTA = [0, 1].freeze
SOUTH_DELTA = [1, 0].freeze
WEST_DELTA = [0, -1].freeze
DIRECTIONS = [:north, :east, :south, :west]
DIRECTION_DELTA = {
  north: NORTH_DELTA,
  east: EAST_DELTA,
  south: SOUTH_DELTA,
  west: WEST_DELTA,
}

def part2(data)
  grid = data.split("\n").map { |line| line.split("").map(&:to_i) }

  distance = {}
  previous = {}
  seen = Set.new

  start = [0, 0]
  end_point = [grid.size - 1, grid[0].size - 1]

  distance[start] = 0

  queue = Containers::MinHeap.new
  queue.push([0, 0, 0, :initial])

  until queue.empty?
    cost, y, x, disallowed_direction = queue.pop

    return cost if y == grid.size - 1 && x == grid[0].size - 1

    next unless seen.add?([y, x, disallowed_direction])

    # foo
    DIRECTIONS.each do |direction|
      if direction == disallowed_direction || direction == reverse_direction(disallowed_direction)
        next
      end

      cost_increase = 0

      dy, dx = DIRECTION_DELTA[direction]
      (1..10).each do |step|
        new_y = y + dy * step
        new_x = x + dx * step
        if !(0...grid.size).include?(new_y) || !(0...grid[0].size).include?(new_x)
          next
        end

        binding.irb if grid[new_y][new_x].nil?

        cost_increase += grid[new_y][new_x]
        next if step < 4

        new_cost = cost + cost_increase
        if distance.fetch([new_y, new_x, direction], Float::INFINITY) <= new_cost
          next
        end

        distance[[new_y, new_x, direction]] = new_cost
        queue.push([new_cost, new_y, new_x, direction])
      end
    end
  end
  "path not found"
end

def reverse_direction(direction)
  {
    initial: nil,
    north: :south,
    east: :west,
    south: :north,
    west: :east,
  }.fetch(direction)
end

def neighbours(vertex, graph)
  DIRECTIONS
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

puts part2(data)
# part1(<<~TEXT,
#   199
#   111
#   919
#   111
# TEXT
#      )
# puts part2(<<~TEXT,
#   2413432311323
#   3215453535623
#   3255245654254
#   3446585845452
#   4546657867536
#   1438598798454
#   4457876987766
#   3637877979653
#   4654967986887
#   4564679986453
#   1224686865563
#   2546548887735
#   4322674655533
# TEXT
#           )
