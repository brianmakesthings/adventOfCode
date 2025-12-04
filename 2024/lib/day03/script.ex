defmodule AdventOfCode2024.Day03 do
  @moduledoc """
  day 1 of advent of code
  """

  def part1 do
    string =
      "./lib/day03/input.txt"
      |> File.read!()

    Regex.scan(~r/mul\((\d+),(\d+)\)/, string)
    |> IO.inspect()
    |> Enum.map(fn [_, x, y] -> String.to_integer(x) * String.to_integer(y) end)
    |> Enum.sum()
  end

  def part2 do
    string =
      "./lib/day03/input.txt"
      |> File.read!()

    Regex.scan(~r/mul\((\d+),(\d+)\)|don\'t|do/, string)
    |> Enum.map(fn capture ->
      case capture do
        ["do"] -> :do
        ["don't"] -> :dont
        [_, x, y] -> String.to_integer(x) * String.to_integer(y)
      end
    end)
    |> IO.inspect()
    |> Enum.reduce({:do, 0}, fn val, {status, sum} ->
      case {val, {status, sum}} do
        {:do, _} -> {:do, sum}
        {:dont, _} -> {:dont, sum}
        {_, {:do, _}} -> {:do, sum + val}
        {_, {:dont, _}} -> {:dont, sum}
      end
    end)
  end
end
