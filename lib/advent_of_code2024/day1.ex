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
            |> post_traverse(:zip)

  defp zip(rest, args, context, _line, _offset) do
    args =
      args
      |> Enum.reduce([[], []], fn [one, two], [left, right] ->
        [[one | left], [two | right]]
      end)
      |> Enum.map(&Enum.sort/1)

    {rest, args, context}
  end

  def part_one(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    input
    |> Enum.zip()
    |> Enum.reduce(0, fn {left, right}, acc -> abs(left - right) + acc end)
  end

  def part_two(input) do
    {:ok, [left, right], _, _, _, _} = parse_input(input)

    frequencies = Enum.frequencies(right)

    Enum.reduce(left, 0, fn elem, acc ->
      multiplier = frequencies[elem] || 0
      acc + elem * multiplier
    end)
  end
end
