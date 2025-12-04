# frozen_string_literal: true

data = File.read("input.txt")

def find_differences(history)
  history.each_cons(2).map do |first, second|
    second - first
  end
end

def build_history(history)
  pyramid = [history]
  loop do
    pyramid.append(find_differences(pyramid.last))
    break if pyramid.last.all? { |x| x == 0 }
  end
  pyramid
end

def extrapolate_pyramid(pyramid)
  pyramid.reverse.reduce(0) do |acc, line|
    acc + line.last
  end
end

def part1(data)
  lines = data.split("\n").map { |x| x.split(" ").map(&:to_i) }
  lines.map do |line|
    history = build_history(line)
    extrapolate_pyramid(history)
  end.sum
end

def extrapolate_pyramid_prev(pyramid)
  print(pyramid)
  pyramid.reverse.reduce(0) do |acc, line|
    line.first - acc
  end
end

def part2(data)
  lines = data.split("\n").map { |x| x.split(" ").map(&:to_i) }
  lines.map do |line|
    history = build_history(line)
    extrapolate_pyramid_prev(history)
  end.sum
end

# puts part1(data)
puts part2(data)
