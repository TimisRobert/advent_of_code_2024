defmodule AdventOfCode2024.Day6 do
  use AdventOfCode2024

  defp parse_input(input) do
    for {line, y} <- input |> String.split("\n") |> Enum.with_index(),
        {cell, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: Map.new() do
      {{x, y}, cell}
    end
  end

  defp direction("^"), do: :up
  defp direction(">"), do: :right
  defp direction("<"), do: :left
  defp direction("v"), do: :down

  defp find_guard(map) do
    Enum.find_value(map, fn {coords, direction} ->
      if direction in ~w(^ > < v), do: {coords, direction(direction)}
    end)
  end

  defp turn(:up), do: :right
  defp turn(:right), do: :down
  defp turn(:left), do: :up
  defp turn(:down), do: :left

  defp move(:up, {x, y}), do: {x, y - 1}
  defp move(:right, {x, y}), do: {x + 1, y}
  defp move(:left, {x, y}), do: {x - 1, y}
  defp move(:down, {x, y}), do: {x, y + 1}

  defp move_guard(map, {coords, direction}) do
    new_coords = move(direction, coords)
    map = Map.put(map, coords, ".")

    case Map.get(map, new_coords) do
      nil -> :done
      "." -> {map, {new_coords, direction}}
      "#" -> {map, {coords, turn(direction)}}
    end
  end

  defp traverse_map(map, {coords, _} = position, visited \\ MapSet.new()) do
    visited = MapSet.put(visited, coords)

    case move_guard(map, position) do
      :done -> visited
      {map, new_position} -> traverse_map(map, new_position, visited)
    end
  end

  def part_one(input) do
    map = parse_input(input)
    position = find_guard(map)

    map
    |> traverse_map(position)
    |> MapSet.size()
  end

  defp is_loop?(map, position, visited \\ MapSet.new()) do
    visited = MapSet.put(visited, position)

    case move_guard(map, position) do
      :done -> false
      {map, new_position} -> new_position in visited || is_loop?(map, new_position, visited)
    end
  end

  def part_two(input) do
    map = parse_input(input)
    position = find_guard(map)
    {max_x, max_y} = Enum.max(Map.keys(map))

    for y <- 0..max_y, x <- 0..max_x, Map.get(map, {x, y}) == "." do
      Map.put(map, {x, y}, "#")
    end
    |> Task.async_stream(&is_loop?(&1, position), ordered: false)
    |> Stream.filter(&match?({:ok, true}, &1))
    |> Enum.count()
  end
end
