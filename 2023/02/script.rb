# frozen_string_literal: true

data = File.read("input.txt").split("\n")

def parse_line(line)
  _, id, *rest = line.split(" ")
  game = rest.join(" ").split(";")
  sets = game.map { |x| x.split(", ") }
  [id.to_i, sets]
  # print game
  #     .map { |x| x.tr(",;", "")}
  #     .each_slice(2).each do |count, colour|
  #     res[colour] = res.fetch(colour, 0) + count.to_i
  # end
  # res["id"] = id.to_i
  # res
end

def sets_max_counts(sets)
  max_red = 0
  max_green = 0
  max_blue = 0

  sets.each do |set|
    drawn_counts = {}
    set.each do |draw|
      count, colour = draw.split(" ")
      drawn_counts[colour] = drawn_counts.fetch(colour, 0) + count.to_i
    end
    max_red = [drawn_counts.fetch("red", 0), max_red].max
    max_green = [drawn_counts.fetch("green", 0), max_green].max
    max_blue = [drawn_counts.fetch("blue", 0), max_blue].max
  end
  [max_red, max_green, max_blue]
end

def part1(data)
  data.filter_map do |line|
    id, sets = parse_line(line)
    max_red, max_green, max_blue = sets_max_counts(sets)

    next if max_red > 12 || max_green > 13 || max_blue > 14

    id
  end.sum
end

def part2(data)
  data.filter_map do |line|
    _, sets = parse_line(line)
    max_red, max_green, max_blue = sets_max_counts(sets)

    power = max_red * max_green * max_blue

    power
  end.sum
end

# print parse_line(data[0])
puts part1(data)
puts part2(data)
