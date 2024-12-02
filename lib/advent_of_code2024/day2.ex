defmodule AdventOfCode2024.Day2 do
  use AdventOfCode2024

  defparsec :parse_input,
            repeat(
              lookahead_not(ascii_char([?\n]))
              |> repeat(
                integer(min: 1)
                |> ignore(ascii_char([?\s]))
              )
              |> integer(min: 1)
              |> ignore(ascii_char([?\n]))
              |> wrap()
            )

  defp safe?([one, two | _] = levels) do
    comparator = if one > two, do: &>/2, else: &</2

    levels
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> abs(a - b) in 1..3 and comparator.(a, b) end)
  end

  def part_one(input) do
    {:ok, input, _, _, _, _} = parse_input(input)
    Enum.count(input, &safe?/1)
  end

  def part_two(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    Enum.count(input, fn levels ->
      Enum.any?(0..length(levels), fn idx ->
        levels |> List.delete_at(idx) |> safe?()
      end)
    end)
  end
end
