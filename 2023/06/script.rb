# frozen_string_literal: true

require "parallel"

data = File.read("input.txt")

def part1(data)
  races = data.split("\n").map { |line| line.split(":") }
    .map do |_label, values|
      values.split(" ").map(&:to_i)
    end
    .transpose

  ways_to_win = races.map do |time, distance|
    (0..time).select do |wait|
      (time - wait) * wait > distance
    end.count
  end

  puts ways_to_win.reduce(&:*)

  # puts "#{races}"
end

def part2(data)
  race = data.split("\n").map { |line| line.split(":") }
    .map do |_label, values|
      values.split(" ").join("").to_i
    end

  time, distance = race
  ways_to_win = Parallel.map(0..time) do |wait|
    (time - wait) * wait > distance
  end

  puts ways_to_win.count(true)
end

def part2_efficient(data)
  race = data.split("\n").map { |line| line.split(":") }
    .map do |_label, values|
      values.split(" ").join("").to_i
    end

  time, distance = race
  start = 0.upto(time).find do |wait|
    wins_race(time, distance, wait)
  end

  last = time.downto(0).find do |wait|
    wins_race(time, distance, wait)
  end

  puts start, last
  puts (last + 1) - start
end

def wins_race(time, distance, wait)
  (time - wait) * wait > distance
end

def part2_binary(data)
  race = data.split("\n").map { |line| line.split(":") }
    .map do |_label, values|
      values.split(" ").join("").to_i
    end

  time, distance = race
  binary_search_range(time, distance)
end

def binary_search_range(time, distance)
  left = 0
  right = time

  while left < right
    mid = left + (right - left) / 2
    puts mid
    if wins_race(time, distance, mid)
      right = mid
    else
      left = mid + 1
    end
  end

  left
end

def part2_math(data)
  race = data.split("\n").map { |line| line.split(":") }
    .map do |_label, values|
      values.split(" ").join("").to_i
    end

  time, distance = race

  # (time - wait) * wait > distance
  # time*wait - wait^2 - distance > 0
  # -x^2 + time*x - distance
  root1 = (-time + Math.sqrt(time * time - (4 * -1 * -distance))) / (2 * -1)
  root2 = (-time - Math.sqrt(time * time - (4 * -1 * -distance))) / (2 * -1)
  puts root1.ceil, root2.floor
  puts root2.floor + 1 - root1.ceil
end

# part1(data)
# part2(data)
# part2_efficient(data)
# part2_binary(data)
part2_math(data)
