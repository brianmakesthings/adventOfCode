defmodule AdventOfCode2024.Day04 do
  @moduledoc """
  day 1 of advent of code
  """

  def part1 do
    grid =
      "./lib/day04/sample.txt"
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(fn line -> String.split(line, "", trim: true) end)

    word = ["X", "M", "A", "S"]
    seen = MapSet.new()

    {_, count} =
      Enum.reduce(0..(length(grid) - 1), {grid, 0}, fn row, {current_grid, total_count} ->
        Enum.reduce(
          0..(length(Enum.at(current_grid, 0)) - 1),
          {current_grid, total_count},
          fn col, {grid_acc, count_acc} ->
            [matcher | rest] = word
            val = Enum.at(Enum.at(grid_acc, row), col)

            case val do
              # matcher -> dfs()
              _ -> {grid_acc, count_acc}
            end
          end
        )
      end)

    IO.puts(count)
  end

  defp dfs(grid, row, col, visited) do
  end

  def part2 do
  end
end
