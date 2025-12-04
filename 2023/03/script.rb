# frozen_string_literal: true

data = File.read("input.txt")

def digit_strings
  ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
end

def part1(data)
  grid = data.split("\n").map { |line| line.split("") }
  nums = []
  visited = Set.new
  grid.each_with_index do |row, y|
    row.each_with_index do |col, x|
      next if col == "." || digit_strings.include?(col)

      directions = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
      directions.each do |dx, dy|
        next if grid.dig(y + dy, x + dx).nil?
        next if visited.include?([y + dy, x + dx])
        next unless digit_strings.include?(grid.dig(y + dy, x + dx))

        visited.add([y + dy, x + dx])
        left = x + dx
        while digit_strings.include?(grid.dig(y + dy, left))
          left -= 1
          visited.add([y + dy, left])
        end
        right = x + dx
        while digit_strings.include?(grid.dig(y + dy, right))
          right += 1
          visited.add([y + dy, right])
        end

        num = grid[y + dy][left + 1...right].join("").to_i
        nums << num if num
      end
    end
  end
  puts nums.sum
end

def part2(data)
  digit_strings = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  grid = data.split("\n").map { |line| line.split("") }
  nums = []
  visited = Set.new
  grid.each_with_index do |row, y|
    row.each_with_index do |col, x|
      next if col != "*"

      gears = []

      directions = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
      directions.each do |dx, dy|
        next if grid.dig(y + dy, x + dx).nil?
        next if visited.include?([y + dy, x + dx])
        next unless digit_strings.include?(grid.dig(y + dy, x + dx))

        visited.add([y + dy, x + dx])
        left = x + dx
        while digit_strings.include?(grid.dig(y + dy, left))
          left -= 1
          visited.add([y + dy, left])
        end
        right = x + dx
        while digit_strings.include?(grid.dig(y + dy, right))
          right += 1
          visited.add([y + dy, right])
        end

        num = grid[y + dy][left + 1...right].join("").to_i
        gears << num if num
      end

      next if gears.size != 2

      nums << gears[0] * gears[1]
    end
  end
  puts nums.sum
end

part2(data)
