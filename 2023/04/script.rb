# frozen_string_literal: true

data = File.read("input.txt")

def part1(data)
  data.split("\n").map do |line|
    winning_nums, card =  line.split(":")[1].split("|").map { |x| x.split(" ") }
    matches = (card & winning_nums)
    if matches.empty?
      0
    else
      2**(matches.length - 1)
    end
  end.sum
end

def part2(data)
  lines = data.split("\n")
  counts = Array.new(lines.length, 1)
  lines.map do |line|
    game, rest = line.split(":")
    id = game.split(" ")[1].to_i
    winning_nums, card = rest.split("|").map { |x| x.split(" ") }
    matches = (card & winning_nums)
    (1..matches.length).each do |i|
      index = id - 1
      if counts.dig(index + 1)
        counts[index + i] += counts[index]
      end
    end
  end
  puts counts.sum
end

part1(data)
part2(data)
