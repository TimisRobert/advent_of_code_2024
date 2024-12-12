defmodule AdventOfCode2024.Day1 do
  use AdventOfCode2024

  defparsec :parse_input,
            repeat(
              integer(min: 1)
              |> concat(ignore_whitespace())
              |> integer(min: 1)
              |> concat(optional(ignore_whitespace()))
              |> wrap()
            )

  defp into_lists(input) do
    input
    |> Enum.map(&List.to_tuple/1)
    |> Enum.unzip()
    |> Tuple.to_list()
    |> Enum.map(&Enum.sort/1)
  end

  def part_one(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    input
    |> into_lists()
    |> Enum.zip()
    |> Enum.map(fn {left, right} -> abs(left - right) end)
    |> Enum.sum()
  end

  def part_two(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    [left, right] = into_lists(input)
    frequencies = Enum.frequencies(right)

    left
    |> Enum.map(&(&1 * Map.get(frequencies, &1, 0)))
    |> Enum.sum()
  end
end
