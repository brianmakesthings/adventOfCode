# frozen_string_literal: true

data = File.read("./input.txt")

NORTH_DELTA = [-1, 0].freeze
EAST_DELTA = [0, 1].freeze
SOUTH_DELTA = [1, 0].freeze
WEST_DELTA = [0, -1].freeze

DIRECTION_MAP = {
  "U" => NORTH_DELTA,
  "R" => EAST_DELTA,
  "D" => SOUTH_DELTA,
  "L" => WEST_DELTA,
}

def part1(data)
  instructions = data.split("\n").map { |line| line.split(" ") }
  coords = [[0, 0]]
  instructions.each do |instruction|
    direction, amount, colour = instruction
    amount = amount.to_i
    delta_x, delta_y = DIRECTION_MAP.fetch(direction)
    last_x, last_y = coords[-1]
    new_x = last_x + delta_x * amount
    new_y = last_y + delta_y * amount
    coords.push([new_x, new_y])
  end
  area, perimeter = shoelace(coords)
  puts "#{shoelace(coords)}"
  puts area + (perimeter / 2) + 1
end

def part2(data)
  instructions = data.split("\n").map { |line| line.split(" ") }
  num_to_direction = {
    "0" => EAST_DELTA,
    "1" => SOUTH_DELTA,
    "2" => WEST_DELTA,
    "3" => NORTH_DELTA,
  }
  coords = [[0, 0]]
  instructions.each do |instruction|
    _, _, colour = instruction
    delta_x, delta_y = num_to_direction.fetch(colour[-2])
    amount = colour[2..6].to_i(16)
    last_x, last_y = coords[-1]
    new_x = last_x + delta_x * amount
    new_y = last_y + delta_y * amount
    coords.push([new_x, new_y])
  end
  area, perimeter = shoelace(coords)
  puts "#{shoelace(coords)}"
  puts area + (perimeter / 2) + 1
end

def shoelace(coords)
  sum = 0
  perimeter = 0
  coords.each_cons(2) do |p1, p2|
    x1, y1 = p1
    x2, y2 = p2
    sum += (x1 * y2) - (x2 * y1)
    perimeter += ((y2 - y1) + (x2 - x1)).abs
  end
  [(sum / 2).abs, perimeter.abs]
end

test_data =
  <<~TEXT
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    D 2 (#d2c081)
    R 2 (#59c680)
    D 2 (#411b91)
    L 5 (#8ceee2)
    U 2 (#caa173)
    L 1 (#1b58a2)
    U 2 (#caa171)
    R 2 (#7807d2)
    U 3 (#a77fa3)
    L 2 (#015232)
    U 2 (#7a21e3)
  TEXT

# part1(test_data)
# part1(data)
# part2(test_data)
part2(data)
