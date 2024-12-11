defmodule AdventOfCode2024.Day11 do
  use AdventOfCode2024

  defp parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp blink(list) when is_list(list), do: blink(Enum.frequencies(list))

  defp blink(map) do
    Enum.reduce(map, map, fn
      {_, 0}, map ->
        map

      {k, v}, map ->
        Enum.reduce(0..(v - 1), map, fn _, map ->
          cond do
            k == 0 ->
              map
              |> Map.update(0, 0, &(&1 - 1))
              |> Map.update(1, 1, &(&1 + 1))

            k |> Integer.digits() |> length() |> rem(2) == 0 ->
              int = Integer.to_string(k)

              {left, right} =
                int
                |> String.split_at(div(String.length(int), 2))

              left = String.to_integer(left)
              right = String.to_integer(right)

              map
              |> Map.update(k, 0, &(&1 - 1))
              |> Map.update(left, 1, &(&1 + 1))
              |> Map.update(right, 1, &(&1 + 1))

            true ->
              map
              |> Map.update(k, 0, &(&1 - 1))
              |> Map.update(k * 2024, 1, &(&1 + 1))
          end
        end)
    end)
    |> Enum.reject(fn {_, v} -> v == 0 end)
    |> Map.new()
  end

  def part_one(input) do
    input
    |> parse_input()
    |> Stream.iterate(&blink/1)
    |> Enum.at(25)
    |> Map.values()
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> parse_input()
    |> Stream.iterate(&blink/1)
    |> Enum.at(75)
    |> Map.values()
    |> Enum.sum()
  end
end
