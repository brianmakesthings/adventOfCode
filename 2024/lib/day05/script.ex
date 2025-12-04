defmodule AdventOfCode2024.Day05 do
  @moduledoc """
  day 1 of advent of code
  """

  def part1 do
    [raw_rules, raw_instructions] =
      "./lib/day05/input.txt"
      |> File.read!()
      |> String.split("\n\n")

    # |> IO.inspect(charlists: :as_lists)
    rules = tokenize_rules(raw_rules) |> parse_rules

    tokenize_instructions(raw_instructions)
    |> IO.inspect(charlists: :as_lists)
    |> Enum.filter(fn x -> validate(x, rules) end)
    |> Enum.map(fn x -> Enum.at(x, div(length(x), 2)) end)
    |> Enum.sum()
    |> IO.inspect(charlists: :as_lists)
  end

  def tokenize_rules(rules) do
    rules
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split("|")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def parse_rules(rules) do
    rules
    |> Enum.reduce(Map.new(), fn [pre, post], acc ->
      acc
      |> Map.get_and_update(pre, fn val ->
        case val do
          nil -> {val, MapSet.new() |> MapSet.put(post)}
          _ -> {val, MapSet.put(val, post)}
        end
      end)
      |> elem(1)
    end)
  end

  def tokenize_instructions(instructions) do
    instructions
    |> String.split("\n")
    |> IO.inspect()
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def validate(instructions, rules) do
    instructions
    |> Enum.reverse()
    |> IO.inspect()
    |> Enum.reduce({true, MapSet.new()}, fn instruction, {status, bad_list} ->
      bad_list |> IO.inspect()

      case status do
        false ->
          {false, bad_list}

        true ->
          if MapSet.member?(bad_list, instruction) do
            {false, bad_list}
          else
            {true, MapSet.union(bad_list, Map.get(rules, instruction, MapSet.new()))}
          end
      end
    end)
    |> elem(0)
  end

  def part2 do
    [raw_rules, raw_instructions] =
      "./lib/day05/input.txt"
      |> File.read!()
      |> String.split("\n\n")

    # |> IO.inspect(charlists: :as_lists)
    rules = tokenize_rules(raw_rules) |> parse_rules

    tokenize_instructions(raw_instructions)
    |> IO.inspect(charlists: :as_lists)
    |> Enum.filter(fn x -> !validate(x, rules) end)
    |> Enum.map(fn x -> fix(x, rules) end)
    |> Enum.map(fn x -> Enum.at(x, div(length(x), 2)) end)
    |> Enum.sum()
    |> IO.inspect(charlists: :as_lists)
  end

  def fix(instructions, rule) do
  end
end
