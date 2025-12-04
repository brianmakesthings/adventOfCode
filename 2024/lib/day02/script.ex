defmodule AdventOfCode2024.Day02 do
  @moduledoc """
  day 1 of advent of code
  """

  def part1 do
    "./lib/day02/input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, " ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(&is_safe?/1)
    |> Enum.count(fn x -> x end)
    |> IO.inspect()
  end

  def part2 do
    "./lib/day02/input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, " ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn line ->
      is_safe?(line) || brute_force_is_safe_2?(line)
    end)
    # |> Enum.to_list()
    # |> Enum.count(fn {status, valid} -> valid end)
    |> Enum.count(fn x -> x end)
    |> IO.inspect()
  end

  defp is_safe?(report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [x, y] -> x - y end)
    |> then(fn line ->
      Enum.all?(line, fn x -> x <= -1 && x >= -3 end) ||
        Enum.all?(line, fn x -> x >= 1 && x <= 3 end)
    end)
  end

  # defp is_safe_2?(report) do
  #   deltas =
  #     report
  #     |> Enum.chunk_every(2, 1, :discard)
  #     |> IO.inspect()
  #     |> Enum.map(fn [x, y] -> y - x end)
  #     |> Enum.chunk_every(2, 1, :discard)
  #     |> Enum.map(fn [x, y] -> y + x end)
  #     |> IO.inspect()
  # end

  defp brute_force_is_safe_2?(report) do
    0..(length(report) - 1)
    |> Enum.map(fn to_remove -> List.delete_at(report, to_remove) end)
    |> Enum.any?(&is_safe?/1)
  end
end
