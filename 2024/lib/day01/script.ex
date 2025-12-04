defmodule AdventOfCode2024.Day01 do
  @moduledoc """
  day 1 of advent of code
  """

  def part1 do
    {:ok, data} = File.read("./lib/day01/input.txt")
    lines = String.split(data, "\n")

    parsed_lines =
      lines
      |> Enum.map(&parse_line/1)
      |> Enum.zip(0..length(lines))
      |> Enum.map(fn {[l, r], pos} -> {{l, pos}, {r, pos}} end)

    left_line = parsed_lines |> Enum.map(fn x -> elem(x, 0) end) |> Enum.sort()
    right_line = parsed_lines |> Enum.map(fn x -> elem(x, 1) end) |> Enum.sort()

    # IO.inspect(left_line)
    # IO.inspect(right_line)

    Enum.zip(left_line, right_line)
    |> Enum.map(fn {l, r} -> abs(elem(l, 0) - elem(r, 0)) end)
    |> Enum.sum()
  end

  def part2 do
    {:ok, data} = File.read("./lib/day01/input.txt")
    lines = String.split(data, "\n")
    parsed_lines = lines |> Enum.map(&parse_line/1)
    left_line = parsed_lines |> Enum.map(fn [l, _] -> l end)
    right_line = parsed_lines |> Enum.map(fn [_, r] -> r end)

    right_counts =
      right_line
      |> Enum.reduce(Map.new(), fn x, acc ->
        {_, new} =
          Map.get_and_update(acc, x, fn cur ->
            case cur do
              nil -> {cur, 1}
              _ -> {cur, cur + 1}
            end
          end)

        new
      end)

    left_line
    |> Enum.map(fn x -> {x, Map.get(right_counts, x)} end)
    |> Enum.filter(fn {_, count} -> count != nil end)
    |> Enum.map(fn {x, count} -> x * count end)
    |> Enum.sum()
  end

  defp parse_line(line) do
    split_line = line |> String.split("   ")

    split_line
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn x -> elem(x, 0) end)
  end
end
