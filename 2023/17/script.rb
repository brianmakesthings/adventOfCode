# frozen_string_literal: true

require "algorithms"
require "debug"

data = File.read("./input.txt")

class Vertex
  attr_accessor :coords, :neighbours

  def initialize(coords, neighbours = [])
    @coords = coords
    @neighbours = neighbours
  end

  def inspect
    "Vertex<coords: #{coords}, neighbours: #{neighbours.map { |nb, weight| [nb.coords, weight].to_s }}>"
  end
end

class WeightedGraph
  attr_accessor :vertices

  def initialize(vertices = [])
    @vertices = vertices
  end

  def add_vertex(vertex)
    vertices << vertex
  end

  def find_vertex(coords)
    vertices.find do |vertex|
      vertex.coords == coords
    end
  end
end

def reverse_direction(direction)
  {
    initial: nil,
    north: :south,
    east: :west,
    south: :north,
    west: :east,
  }.fetch(direction)
end

def part1(data)
  grid = data.split("\n").map { |line| line.split("") }
  graph = build_graph(grid)
  puts "constructed graph of size #{graph.vertices.size}"
  distances, previous = djikstra(graph)
  source = graph.vertices.find { |v| v.coords[2] == :initial }
  targets = graph.vertices.select { |v| v.coords[0..1] == [grid.size - 1, grid[0].size - 1] }
  # sequence = find_path(previous, source, target)
  target_distances = targets.map { |t| distances[t] }
  puts target_distances.min
end

def find_path(previous, source, target)
  sequence = []
  u = target
  while previous[u]
    sequence.unshift(u)
    u = previous[u]
  end
  sequence
end

def djikstra(graph)
  distances = {}
  # queue = Set.new([graph.vertices.first])
  queue = Containers::PriorityQueue.new
  queue.push(graph.vertices.first, 0)
  previous = {}

  graph.vertices.each do |vertex|
    next if vertex == graph.vertices.first

    distances[vertex] = Float::INFINITY
    previous[vertex] = nil
    queue.push(vertex, -distances[vertex])
  end
  distances[graph.vertices.first] = 0

  until queue.empty?
    # u, _ = distances.sort_by { |_key, value| value }.select { |key, _value| queue.include?(key) }.first
    puts queue.size if queue.size % 1000 == 0
    # u = queue.sort_by { |v| distances[v] }.first
    u = queue.pop
    # queue.delete(u)
    # binding.break if u.coords[0..1] == [1, 1]

    u.neighbours.each do |neighbour, weight|
      alt = distances[u] + weight
      # binding.break if neighbour.coords == [0, 1, :east, 0]
      next unless alt < distances[neighbour]

      distances[neighbour] = alt
      previous[neighbour] = u
      queue.delete(neighbour)
      queue.push(neighbour, -distances[neighbour])
    end

  end

  [distances, previous]
end

NORTH_DELTA = [-1, 0].freeze
EAST_DELTA = [0, 1].freeze
SOUTH_DELTA = [1, 0].freeze
WEST_DELTA = [0, -1].freeze
DIRECTIONS = [:north, :east, :south, :west]

DIRECTION_DELTA = {
  north: NORTH_DELTA,
  east: EAST_DELTA,
  south: SOUTH_DELTA,
  west: WEST_DELTA,
}

def build_graph(grid)
  initial_vertex = Vertex.new([0, 0, :initial, 0])
  graph = WeightedGraph.new([initial_vertex])
  queue = [[initial_vertex]]
  visited = { initial_vertex.coords => initial_vertex }
  level = 0
  until queue.empty?
    frontier = queue.shift
    next_frontier = []
    frontier.each do |vertex|
      i, j, prev_direction, prev_step = vertex.coords
      # binding.break if [i, j] == [3, 1]
      # we visited [3,1] twice with differnt steps

      DIRECTIONS.each do |direction|
        next if direction == reverse_direction(prev_direction)

        delta_i, delta_j = DIRECTION_DELTA.fetch(direction)
        step = direction == prev_direction ? prev_step + 1 : 0
        next if step >= 10

        new_grid_coords = [i + delta_i, j + delta_j]
        next if new_grid_coords.any?(&:negative?)

        new_coords = new_grid_coords + [direction, step]

        weight = grid.dig(*new_grid_coords)
        next if weight.nil?

        # next if visited.include?(new_coords)

        existing_vertex = visited[new_coords]
        new_vertex = existing_vertex || Vertex.new(new_coords)
        vertex.neighbours << [new_vertex, Integer(weight)]
        graph.add_vertex(new_vertex) unless existing_vertex
        next_frontier.append(new_vertex) unless existing_vertex

        visited[new_coords] = new_vertex
      end
    end
    queue.append(next_frontier) unless next_frontier.empty?
    level += 1
  end
  binding.break
  graph
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

# part1(data)
# part1(<<~TEXT,
#   199
#   111
#   919
#   111
# TEXT
#      )
part1(<<~TEXT,
  2413432311323
  3215453535623
  3255245654254
  3446585845452
  4546657867536
  1438598798454
  4457876987766
  3637877979653
  4654967986887
  4564679986453
  1224686865563
  2546548887735
  4322674655533
TEXT
     )
