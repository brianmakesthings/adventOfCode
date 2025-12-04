# frozen_string_literal: true

data = File.read("input.txt")

def part1(data)
  command_sequence, maze = data.split("\n\n")
  maze = maze.split("\n").map { |line| line.split(" = ") }.map do |key, pair|
    [key, pair[1..-2].split(", ")]
  end.to_h
  print(maze)
  current = "AAA"
  count = 0
  while current != "ZZZ"
    left, right = maze[current]
    command = command_sequence[count % command_sequence.size]
    current = if command == "L"
      left
    else
      right
    end
    count += 1
  end

  puts count
end

require "parallel"

def part2(data)
  command_sequence, maze = data.split("\n\n")
  maze = maze.split("\n").map { |line| line.split(" = ") }.map do |key, pair|
    [key, pair[1..-2].split(", ")]
  end.to_h
  starting_points = maze.keys.select { |key| key[2] == "A" }

  first_zs = starting_points.map do |starting_point|
    current = starting_point
    count = 0
    while current[2] != "Z"
      left, right = maze[current]
      command = command_sequence[count % command_sequence.size]
      current = if command == "L"
        left
      else
        right
      end
      count += 1
    end
    count
  end
  print(first_zs.reduce(&:lcm))
end

def part2_graph(data)
  command_sequence, maze = data.split("\n\n")
  maze = maze.split("\n").map { |line| line.split(" = ") }.map do |key, pair|
    [key, pair[1..-2].split(", ")]
  end.to_h
  starting_points = maze.keys.select { |key| key[2] == "A" }

  # first_zs = starting_points.map do |starting_point|
  #   current = starting_point
  #   count = 0
  #   while current[2] != "Z"
  #     left, right = maze[current]
  #     command = command_sequence[count % command_sequence.size]
  #     current = if command == "L"
  #       left
  #     else
  #       right
  #     end
  #     count += 1
  #   end
  #   count
  # end
  # print(first_zs.reduce(&:lcm))
end

def find_cycle(starting_point, maze, command_sequence)
  slow = starting_point
  slow_count = 0
  fast = maze[starting_point][command_sequence[0] == "L" ? 0 : 1]
  fast_count = 1
  while slow != fast
    puts "#{slow}, #{fast}"
    slow_next = maze[slow][command_sequence[slow_count] == "L" ? 0 : 1]
    slow_count += 1
    fast_next = maze[fast][command_sequence[fast_count] == "L" ? 0 : 1]
    fast_count += 1
    fast_next = maze[fast_next][command_sequence[fast_count] == "L" ? 0 : 1]
    fast_count += 1

    slow = slow_next
    fast = fast_next
  end
  puts "#{slow}, #{fast}"
  puts("#{slow_count}, #{fast_count}")
end

# part1(data)
# part2(data)
# part2_graph(data)

find_cycle(
  "AAA",
  {
    "AAA" => ["BBB", "CCC"],
    "BBB" => ["DDD", "AAA"],
    "CCC" => ["BBB", "ZZZ"],
    "ZZZ" => ["AAA", "BBB"],
  },
  "RRRRRR",
)
