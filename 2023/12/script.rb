# frozen_string_literal: true

data = File.read("input.txt")

def part1(data)
  lines = data.split("\n").map { |line| line.split(" ") }
  parsed_lines = lines.map do |route, count|
    [route.split(""), count.split(",").map(&:to_i)]
  end
  line_counts = parsed_lines.map do |route, counts|
    results = []
    question_indices = get_question_indices(route)
    recursive_solve(route, counts, question_indices, question_indices.size - 1)
  end
  puts "#{line_counts.sum}"

  # question_indices = get_question_indices(parsed_lines[0][0])
  # route = parsed_lines[0][0]
  # counts = parsed_lines[0][1]
  # p(recursive_solve(route, counts, question_indices, question_indices.size - 1))
end

def get_question_indices(route)
  route.join("").split("").filter_map.with_index do |char, i|
    i if char == "?"
  end
end

# // .??..??...?##. [1 1 3]
def recursive_solve(route, counts, question_indices, index)
  print("#{route}\n")
  if index == -1
    return satisfies_counts(route, counts) ? 1 : 0
  end

  hash_route = route.dup
  hash_route[question_indices[index]] = "#"
  dot_route = route.dup
  dot_route[question_indices[index]] = "."
  recursive_solve(hash_route, counts, question_indices, index - 1) +
    recursive_solve(dot_route, counts, question_indices, index - 1)
end

def part1_alt(data)
  lines = data.split("\n").map { |line| line.split(" ") }
  parsed_lines = lines.map do |route, count|
    [route.split(""), count.split(",").map(&:to_i)]
  end
  line_counts = parsed_lines.map do |route, counts|
    num_sols(route.push("."), counts, cache: {})
  end
  puts "#{line_counts.sum}"
end

def num_sols(route, counts, num_in_group: 0, cache: nil)
  if route.empty?
    return counts.empty? && num_in_group == 0 ? 1 : 0
  end

  num_sols = 0
  next_char_possibilities = route[0] == "?" ? ["#", "."] : [route[0]]
  next_char_possibilities.each do |next_char|
    if next_char == "#"
      num_sols += cache&.dig([route[1..], counts, num_in_group + 1]) ||
        num_sols(route[1..], counts, num_in_group: num_in_group + 1, cache: cache)
    elsif num_in_group > 0
      if !counts.empty? && counts[0] == num_in_group
        num_sols += cache&.dig([route[1..], counts, 0]) ||
          num_sols(route[1..], counts[1..], num_in_group: 0, cache: cache)
      end
    else
      num_sols += cache&.dig(route[1..], counts, 0) ||
        num_sols(route[1..], counts, num_in_group: 0, cache: cache)
    end
  end

  if cache
    cache[[route, counts, num_in_group]] = num_sols
  end
  num_sols
end

def satisfies_counts(route, counts)
  route.join("").split(".").filter_map do |str|
    next if str.empty?

    str.size
  end == counts
end

def backtrack(route, counts, route_start, index, results)
  # puts "#{route} #{route_start} #{index} #{results}"
  if route_start == route.size
    results.push(route.join("")) if counts.size == index
    return
  end

  # if route[route_start] != "?"
  #   backtrack(route.dup, counts, route_start + 1, index, results)
  #   return
  # end

  before_not_hash = route_start == 0 || route[route_start - 1] != "#"
  # binding.irb if counts == [1, 1, 3] && route.size == 14
  end_range = counts[index] ? route_start + counts[index] - 1 : route.size - 1
  after_not_hash = end_range + 1 > route.length - 1 || route[end_range + 1] != "#"
  # binding.irb if route_start == 13 && index == 1
  if end_range >= route.size
    # binding.irb
    return
  end

  # end_range = [end_range, route.size].min
  all_continguous = route[route_start...end_range].all? { |x| x == "?" || x == "#" }
  all_hash = route[route_start...end_range].all?("#")

  if before_not_hash && after_not_hash && all_continguous
    new_route = route.dup
    (route_start..end_range).each do |i|
      new_route[i] = "#"
    end
    backtrack(new_route, counts, end_range + 1, index + 1, results)
  end

  new_route = route.dup
  # (route_start...end_range).each do |i|
  #   new_route[i] = "."
  # end
  new_route[route_start] = "." if new_route[route_start] == "?"
  backtrack(new_route, counts, route_start + 1, index, results)
end

def part2(data)
  lines = data.split("\n").map { |line| line.split(" ") }
  parsed_lines = lines.map do |route, count|
    big_route = ((route.split("") + ["?"]) * 4) + route.split("")
    [big_route, count.split(",").map(&:to_i) * 5]
  end
  line_counts = parsed_lines.map do |route, counts|
    num_sols(route.push("."), counts, cache: {})
  end
  puts "#{line_counts.sum}"

  # question_indices = get_question_indices(parsed_lines[0][0])
  # route = parsed_lines[0][0]
  # counts = parsed_lines[0][1]
  # p(recursive_solve(route, counts, question_indices, question_indices.size - 1))
end

def better_recursive_solve(split_route, count)
  split_route.count("?") == count[2]
end

# part1(data)
part2(data)
# part1_alt(data)
