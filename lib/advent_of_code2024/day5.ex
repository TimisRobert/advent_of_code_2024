defmodule AdventOfCode2024.Day5 do
  use AdventOfCode2024

  ordering_rule =
    integer(min: 1)
    |> ignore(ascii_char([?|]))
    |> integer(min: 1)
    |> concat(ignore_whitespace())
    |> wrap()

  update =
    lookahead_not(ascii_char([?\n]))
    |> repeat(
      integer(min: 1)
      |> ignore(optional(ascii_char([?,])))
    )
    |> concat(ignore_whitespace())
    |> wrap()

  defparsec :parse_input,
            lookahead_not(ascii_char([?\n]))
            |> repeat(ordering_rule)
            |> wrap()
            |> wrap(repeat(update))

  defp ordered?(updates, rules) do
    updates
    |> Enum.with_index(1)
    |> Enum.reduce(Map.new(), fn {elem, idx}, acc ->
      Map.put(acc, elem, Enum.slice(updates, 0, idx - 1))
    end)
    |> Enum.all?(fn {k, v} ->
      MapSet.intersection(MapSet.new(v), MapSet.new(Map.get(rules, k, [])))
      |> MapSet.size() == 0
    end)
  end

  def part_one(input) do
    {:ok, [ordering_rules, updates], _, _, _, _} = parse_input(input)

    rules = Enum.group_by(ordering_rules, &List.first/1, &List.last/1)

    updates
    |> Enum.filter(&ordered?(&1, rules))
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end

  def part_two(input) do
    {:ok, [ordering_rules, updates], _, _, _, _} = parse_input(input)

    rules = Enum.group_by(ordering_rules, &List.first/1, &List.last/1)

    updates
    |> Enum.reject(&ordered?(&1, rules))
    |> Enum.map(&Enum.sort(&1, fn left, right -> right in Map.get(rules, left, []) end))
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end
end
