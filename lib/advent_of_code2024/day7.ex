defmodule AdventOfCode2024.Day7 do
  use AdventOfCode2024

  defparsec :parse_input,
            repeat(
              integer(min: 1)
              |> ignore(ascii_char([?:]))
              |> wrap(
                repeat(
                  ignore(ascii_char([?\s]))
                  |> integer(min: 1)
                )
              )
              |> ignore(ascii_char([?\n]))
              |> wrap()
            )

  defp equation?(operands, target, total \\ 0)

  defp equation?([], target, total), do: total == target

  defp equation?([head | tail], target, total) do
    equation?(tail, target, total + head) or equation?(tail, target, total * head)
  end

  def part_one(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    input
    |> Enum.filter(fn [target, operands] -> equation?(operands, target) end)
    |> Enum.map(fn [target, _] -> target end)
    |> Enum.sum()
  end

  defp equation_concat?(operands, target, total \\ 0)

  defp equation_concat?([], target, total), do: total == target

  defp equation_concat?([head | tail], target, total) do
    equation_concat?(tail, target, total + head) or equation_concat?(tail, target, total * head) or
      equation_concat?(tail, target, String.to_integer("#{total}#{head}"))
  end

  def part_two(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    input
    |> Enum.filter(fn [target, operands] -> equation_concat?(operands, target) end)
    |> Enum.map(fn [target, _] -> target end)
    |> Enum.sum()
  end
end
