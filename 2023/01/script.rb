# frozen_string_literal: true

data = File.read("input.txt").split("\n")

# data.map(&:to_i)

# first = data[0]
# puts first.split("").filter_map { |char| Integer(char) rescue false}.join("").to_i
def part_1(data)
  nums = data.map do |line|
    nums_in_line = line.split("").filter_map do |char|
      Integer(char)
    rescue StandardError
      false
    end
    first = nums_in_line[0]
    last = nums_in_line[-1]
    [first, last].join("").to_i
  end

  puts nums.sum
end

def part_2(data)
  digit_strings = [
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
  ]

  nums = data.map do |line|
    line_nums = []
    line.split("").each_with_index do |char, index|
      if (num = begin
        Integer(char)
      rescue StandardError
        false
      end)
        line_nums << num
      else
        digit_strings.each_with_index do |digit, digit_index|
          line_nums << digit_index if line[index..].start_with?(digit)
        end
      end
    end
    # line_nums.join("").to_i
    first = line_nums[0]
    last = line_nums[-1]
    [first, last].join("").to_i
  end

  puts nums.sum
end

part_1(data)
part_2(data)
