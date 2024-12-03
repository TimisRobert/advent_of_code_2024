defmodule AdventOfCode2024.Day3 do
  use AdventOfCode2024

  defparsec :parse_input,
            repeat(
              choice([
                ignore(string("mul"))
                |> ignore(ascii_char([?(]))
                |> integer(min: 1)
                |> ignore(ascii_char([?,]))
                |> integer(min: 1)
                |> ignore(ascii_char([?)]))
                |> wrap(),
                ignore(ascii_char([]))
              ])
            )

  defparsec :parse_input_two,
            repeat(
              choice([
                string("do()") |> replace(:do),
                string("don't()") |> replace(:dont),
                ignore(string("mul"))
                |> ignore(ascii_char([?(]))
                |> integer(min: 1)
                |> ignore(ascii_char([?,]))
                |> integer(min: 1)
                |> ignore(ascii_char([?)]))
                |> wrap(),
                ignore(ascii_char([]))
              ])
            )

  def part_one(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    input
    |> Enum.map(fn [one, two] -> one * two end)
    |> Enum.sum()
  end

  def part_two(input) do
    {:ok, input, _, _, _, _} = parse_input_two(input)

    input
    |> Enum.map_reduce(
      true,
      fn
        :do, _ -> {0, true}
        :dont, _ -> {0, false}
        [one, two], true -> {one * two, true}
        [_, _], false -> {0, false}
      end
    )
    |> then(&Enum.sum(elem(&1, 0)))
  end
end
