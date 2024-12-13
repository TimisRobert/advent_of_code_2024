defmodule AdventOfCode2024.Day13 do
  use AdventOfCode2024

  button =
    repeat(ignore(ascii_char([], not: ?X)))
    |> ignore(string("X+"))
    |> integer(min: 1)
    |> ignore(string(", Y+"))
    |> integer(min: 1)
    |> concat(ignore_whitespace())

  prize =
    repeat(ignore(ascii_char([], not: ?X)))
    |> ignore(string("X="))
    |> integer(min: 1)
    |> ignore(string(", Y="))
    |> integer(min: 1)
    |> concat(ignore_whitespace())

  defparsec :parse_input,
            repeat(
              choice([
                wrap(button)
                |> concat(wrap(button))
                |> concat(wrap(prize))
                |> wrap(),
                ignore_whitespace()
              ])
            )

  defp cost_formula([{a, b}, {c, d}, {e, f}]) do
    x = e * d - c * f
    y = a * f - e * b
    d = a * d - c * b

    if rem(x, d) == 0 and rem(y, d) == 0,
      do: div(x, d) * 3 + div(y, d),
      else: 0
  end

  defp to_tuples(line), do: Enum.map(line, &List.to_tuple/1)

  def part_one(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    input
    |> Enum.map(&to_tuples/1)
    |> Enum.map(&cost_formula/1)
    |> Enum.sum()
  end

  defp increment_prize([a, b, {e, f}]),
    do: [a, b, {e + 10_000_000_000_000, f + 10_000_000_000_000}]

  def part_two(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    input
    |> Enum.map(&to_tuples/1)
    |> Enum.map(&increment_prize/1)
    |> Enum.map(&cost_formula/1)
    |> Enum.sum()
  end
end
