# frozen_string_literal: true

data = File.read("input.txt")

class LightBeam
  attr_accessor :i, :j, :direction

  def initialize(i, j, direction)
    @i = i
    @j = j
    @direction = direction
  end

  def array_coords
    [i, j]
  end

  def set_key
    [i, j, direction]
  end

  def inspect
    "#{i}, #{j} #{direction}"
  end
end

def part1(data)
  grid = data.split("\n").map { |line| line.split("") }
  initial_beam = LightBeam.new(0, 0, :east)
  process_queue = [initial_beam]
  visited = Set.new # unique by [i, j, direction]
  until process_queue.empty?
    # print("#{process_queue}\n")
    beam = process_queue.shift
    process_beam(beam, grid, process_queue, visited)
  end

  annotated_grid = Array.new(grid.size) { Array.new(grid[0].size) { "." } }
  visited.each do |i, j, _direction|
    annotated_grid[i][j] = "#"
  end

  pretty_print_grid(annotated_grid)

  counts = annotated_grid.sum do |line|
    line.count("#")
  end
  puts counts
end

def part2(data)
  require "parallel"

  grid = data.split("\n").map { |line| line.split("") }

  initial_beams = []
    .concat((0...grid.size).map { |i| LightBeam.new(i, 0, :east) })
    .concat((0...grid.size).map { |i| LightBeam.new(i, grid[0].size - 1, :west) })
    .concat((0...grid[0].size).map { |j| LightBeam.new(0, j, :south) })
    .concat((0...grid[0].size).map { |j| LightBeam.new(grid.size - 1, j, :north) })

  counts = Parallel.map(initial_beams) do |initial_beam|
    process_queue = [initial_beam]
    visited = Set.new # unique by [i, j, direction]
    until process_queue.empty?
      # print("#{process_queue}\n")
      beam = process_queue.shift
      process_beam(beam, grid, process_queue, visited)
    end

    annotated_grid = Array.new(grid.size) { Array.new(grid[0].size) { "." } }
    visited.each do |i, j, _direction|
      annotated_grid[i][j] = "#"
    end

    # pretty_print_grid(annotated_grid)

    counts = annotated_grid.sum do |line|
      line.count("#")
    end
    counts
  end
  puts counts.max
end

def process_beam(beam, grid, queue, visited)
  return if visited.include?(beam.set_key)

  return if beam.array_coords.any?(&:negative?)

  coord_material = grid.dig(*beam.array_coords)
  return unless coord_material

  visited.add(beam.set_key)
  queue.concat(get_new_beams(beam, coord_material))
end

def get_new_beams(beam, material)
  case material
  when "."
    case beam.direction
    when :north
      [LightBeam.new(beam.i - 1, beam.j, :north)]
    when :east
      [LightBeam.new(beam.i, beam.j + 1, :east)]
    when :south
      [LightBeam.new(beam.i + 1, beam.j, :south)]
    when :west
      [LightBeam.new(beam.i, beam.j - 1, :west)]
    else
      raise "unknown direction #{beam}"
    end
  when "|"
    case beam.direction
    when :north
      [LightBeam.new(beam.i - 1, beam.j, :north)]
    when :east
      [LightBeam.new(beam.i - 1, beam.j, :north), LightBeam.new(beam.i + 1, beam.j, :south)]
    when :south
      [LightBeam.new(beam.i + 1, beam.j, :south)]
    when :west
      [LightBeam.new(beam.i - 1, beam.j, :north), LightBeam.new(beam.i + 1, beam.j, :south)]
    else
      raise "unknown direction #{beam}"
    end
  when "-"
    case beam.direction
    when :north
      [LightBeam.new(beam.i, beam.j + 1, :east), LightBeam.new(beam.i, beam.j - 1, :west)]
    when :east
      [LightBeam.new(beam.i, beam.j + 1, :east)]
    when :south
      [LightBeam.new(beam.i, beam.j + 1, :east), LightBeam.new(beam.i, beam.j - 1, :west)]
    when :west
      [LightBeam.new(beam.i, beam.j - 1, :west)]
    else
      raise "unknown direction #{beam}"
    end
  when "/"
    case beam.direction
    when :north
      [LightBeam.new(beam.i, beam.j + 1, :east)]
    when :east
      [LightBeam.new(beam.i - 1, beam.j, :north)]
    when :south
      [LightBeam.new(beam.i, beam.j - 1, :west)]
    when :west
      [LightBeam.new(beam.i + 1, beam.j, :south)]
    else
      raise "unknown direction #{beam}"
    end
  when "\\"
    case beam.direction
    when :north
      [LightBeam.new(beam.i, beam.j - 1, :west)]
    when :east
      [LightBeam.new(beam.i + 1, beam.j, :south)]
    when :south
      [LightBeam.new(beam.i, beam.j + 1, :east)]
    when :west
      [LightBeam.new(beam.i - 1, beam.j, :north)]
    else
      raise "unknown direction #{beam}"
    end
  else
    raise "unknown material #{coord_material}"
  end
end

def pretty_print_grid(grid, use_color: true)
  require "colorize"
  grid.each do |line|
    line.each do |char|
      unless use_color
        print(char)
        next
      end

      if char == "#"
        print(char.red)
      else
        print(char.green)
      end
    end
    puts
  end
end

part2(data)
