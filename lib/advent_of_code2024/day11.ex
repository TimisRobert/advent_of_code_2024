defmodule AdventOfCode2024.Day11 do
  use AdventOfCode2024

  defp parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp blink(map) do
    Enum.reduce(map, Map.new(), fn
      {0, v}, map ->
        Map.update(map, 1, v, &(&1 + v))

      {k, v}, map ->
        digits = Integer.digits(k)
        len = length(digits)

        if rem(len, 2) == 0 do
          {left, right} = Enum.split(digits, div(len, 2))

          map
          |> Map.update(Integer.undigits(left), v, &(&1 + v))
          |> Map.update(Integer.undigits(right), v, &(&1 + v))
        else
          Map.update(map, k * 2024, v, &(&1 + v))
        end
    end)
  end

  def part_one(input) do
    input
    |> parse_input()
    |> Enum.frequencies()
    |> Stream.iterate(&blink/1)
    |> Enum.at(25)
    |> Map.values()
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> parse_input()
    |> Enum.frequencies()
    |> Stream.iterate(&blink/1)
    |> Enum.at(75)
    |> Map.values()
    |> Enum.sum()
  end
end
