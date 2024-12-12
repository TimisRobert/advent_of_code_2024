defmodule AdventOfCode2024.Day12 do
  use AdventOfCode2024

  defp parse_input(input) do
    for {line, y} <- input |> String.split("\n") |> Enum.with_index(),
        {cell, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: Map.new(),
        do: {{x, y}, cell}
  end

  defp neighbours(map, {{x, y}, cell}) do
    for {dx, dy} <- [{0, 1}, {0, -1}, {1, 0}, {-1, 0}],
        coords = {x + dx, y + dy},
        cell == Map.get(map, coords),
        do: {coords, cell}
  end

  defp find_regions(map) do
    list = Map.to_list(map)
    find_regions(map, list, [hd(list)], [[]], MapSet.new())
  end

  defp find_regions(_map, [], [], acc, _visited), do: acc

  defp find_regions(map, [head | rest], [], acc, visited) do
    if head in visited do
      find_regions(map, rest, [], acc, visited)
    else
      find_regions(map, rest, [head], [[] | acc], visited)
    end
  end

  defp find_regions(map, list, [head | rest] = stack, [first | last] = acc, visited) do
    if head in visited do
      find_regions(map, list, rest, acc, visited)
    else
      neighbours = neighbours(map, head)
      stack = stack ++ neighbours
      acc = [[head | first] | last]
      visited = MapSet.put(visited, head)

      find_regions(map, list, stack, acc, visited)
    end
  end

  defp calculate_perimeter(map, region) do
    region
    |> Enum.map(fn pos -> 4 - length(neighbours(map, pos)) end)
    |> Enum.sum()
  end

  defp calculate_sides(map, region) do
  end

  def part_one(input) do
    map = parse_input(input)

    map
    |> find_regions()
    |> Enum.map(fn region ->
      area = length(region)
      perimeter = calculate_perimeter(map, region)

      area * perimeter
    end)
    |> Enum.sum()
  end

  def part_two(input) do
    map = parse_input(input)

    map
    |> find_regions()
    |> Enum.filter(fn region -> Enum.all?(region, &(elem(&1, 1) == "V")) end)
    |> Enum.map(fn region ->
      [{_, letter} | _] = region

      area = length(region)
      sides = calculate_sides(map, region)

      IO.inspect(sides, label: letter)

      area * sides
    end)
    |> Enum.sum()
  end
end
