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
    |> Enum.map(fn {left, right} -> abs(left - right) end)
    |> Enum.sum()
  end

  def part_two(input) do
    {:ok, [left, right], _, _, _, _} = parse_input(input)

    frequencies = Enum.frequencies(right)

    left
    |> Enum.map(&(&1 * (frequencies[&1] || 0)))
    |> Enum.sum()
  end
end
