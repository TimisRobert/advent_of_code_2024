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

  defp different_neighbours(map, {{x, y}, cell}) do
    for {dx, dy} <- [{0, 1}, {0, -1}, {1, 0}, {-1, 0}],
        coords = {x + dx, y + dy},
        cell != Map.get(map, coords),
        do: {coords, Map.get(map, coords)}
  end

  defp direction({x, _}, {ox, _}) when x - ox == 1, do: :left
  defp direction({x, _}, {ox, _}) when x - ox == -1, do: :right
  defp direction({_, y}, {_, oy}) when y - oy == 1, do: :top
  defp direction({_, y}, {_, oy}) when y - oy == -1, do: :bottom

  defp calculate_sides(map, region) do
    region
    |> Enum.flat_map(fn {coords, _} = cell ->
      map
      |> different_neighbours(cell)
      |> Enum.map(&{elem(&1, 0), direction(coords, elem(&1, 0))})
    end)
    |> Enum.group_by(&elem(&1, 1))
    |> Map.values()
    |> Enum.flat_map(fn cells ->
      cells
      |> Enum.group_by(
        fn
          {{_, y}, dir} when dir in ~w(top bottom)a -> y
          {{x, _}, dir} when dir in ~w(left right)a -> x
        end,
        &elem(&1, 0)
      )
      |> Map.values()
      |> Enum.flat_map(&Enum.sort/1)
      |> Enum.chunk_while(
        [],
        fn
          elem, [] ->
            {:cont, [elem]}

          {x, y} = elem, [{x, oy} | _] = acc when abs(y - oy) == 1 ->
            {:cont, [elem | acc]}

          {x, y} = elem, [{ox, y} | _] = acc when abs(x - ox) == 1 ->
            {:cont, [elem | acc]}

          elem, acc ->
            {:cont, acc, [elem]}
        end,
        fn acc -> {:cont, acc, []} end
      )
    end)
    |> Enum.count()
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
    |> Enum.map(fn region ->
      area = length(region)
      sides = calculate_sides(map, region)

      area * sides
    end)
    |> Enum.sum()
  end
end
