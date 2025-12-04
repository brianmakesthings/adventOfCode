# frozen_string_literal: true

class Solution
  def initialize(data)
    @data = data
  end

  def part1
    instructions = @data.split(",")
    hashed_strings = instructions.map { |x| hash_string(x) }
    print(hashed_strings.sum)
  end

  def hash_string(string)
    value = 0
    string.each_byte do |char|
      value += char
      value *= 17
      value &= 255
    end
    value
  end

  def part2
    hashmap = Array.new(256) { {} }
    instructions = @data.split(",")
    instructions.each do |instruction|
      if instruction.include?("=")
        register, value = instruction.split("=")
        hash = hash_string(register)
        hashmap[hash][register] = Integer(value)
      elsif instruction.include?("-")
        register = instruction.split("-").first
        hash = hash_string(register)
        hashmap[hash].delete(register)
      end
    end

    sum = hashmap.map.each_with_index do |map, i|
      map.to_a.each.with_index.reduce(0) do |acc, ((_key, value), j)|
        acc + (i + 1) * (j + 1) * value
      end
    end
    puts sum.sum
  end
end

puts Solution.new("").hash_string("rn")
Solution.new(File.read("input.txt")).part2
