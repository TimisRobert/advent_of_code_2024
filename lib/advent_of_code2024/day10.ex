defmodule AdventOfCode2024.Day10 do
  use AdventOfCode2024

  defp parse_input(input) do
    for {line, y} <- input |> String.split("\n") |> Enum.with_index(),
        {cell, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: Map.new(),
        do: {{x, y}, String.to_integer(cell)}
  end

  defp find_higher_slopes(map, {{x, y} = coords, cell}) do
    for {dx, dy} <- [{0, 1}, {0, -1}, {1, 0}, {-1, 0}],
        new_coords = {x + dx, y + dy},
        new_coords != coords,
        new_cell = Map.get(map, new_coords),
        new_cell == cell + 1,
        do: {new_coords, new_cell}
  end

  defp traverse_trailheads(map) do
    for {_, cell} = position <- map, cell == 0, do: traverse_trailhead(map, position, [position])
  end

  defp traverse_trailhead(_map, {_, 9}, acc), do: [acc]

  defp traverse_trailhead(map, position, acc) do
    map
    |> find_higher_slopes(position)
    |> Enum.flat_map(&traverse_trailhead(map, &1, [&1 | acc]))
  end

  def part_one(input) do
    input
    |> parse_input()
    |> traverse_trailheads()
    |> Enum.flat_map(fn trails ->
      trails
      |> Enum.group_by(&hd/1)
      |> Map.keys()
    end)
    |> Enum.count()
  end

  def part_two(input) do
    input
    |> parse_input()
    |> traverse_trailheads()
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end
end
