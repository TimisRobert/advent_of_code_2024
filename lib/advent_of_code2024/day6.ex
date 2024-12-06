defmodule AdventOfCode2024.Day6 do
  use AdventOfCode2024

  defp parse_input(input) do
    for {line, y} <- input |> String.split("\n") |> Enum.with_index(),
        {cell, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: Map.new() do
      {{x, y}, cell}
    end
  end

  defp find_guard(map) do
    Enum.find_value(map, fn
      {coords, "^"} -> {coords, :up}
      {coords, ">"} -> {coords, :right}
      {coords, "<"} -> {coords, :left}
      {coords, "v"} -> {coords, :down}
      _ -> false
    end)
  end

  defp turn_right(:up), do: :right
  defp turn_right(:right), do: :down
  defp turn_right(:left), do: :up
  defp turn_right(:down), do: :left

  defp move_guard(map, {{x, y}, direction}) do
    coords =
      case direction do
        :up -> {x, y - 1}
        :right -> {x + 1, y}
        :left -> {x - 1, y}
        :down -> {x, y + 1}
      end

    map = Map.put(map, {x, y}, ".")

    case Map.get(map, coords) do
      nil -> :done
      "." -> {map, coords, direction}
      "#" -> {map, {x, y}, turn_right(direction)}
    end
  end

  defp traverse_map(map, {coords, _} = position, visited \\ []) do
    case move_guard(map, position) do
      :done -> [coords | visited]
      {map, coords, direction} -> traverse_map(map, {coords, direction}, [coords | visited])
    end
  end

  def part_one(input) do
    map = parse_input(input)
    position = find_guard(map)

    traverse_map(map, position)
    |> Enum.uniq()
    |> length()
  end

  defp is_loop?(map, position, visited \\ []) do
    case move_guard(map, position) do
      :done ->
        false

      {map, coords, direction} ->
        new_position = {coords, direction}

        if new_position in visited do
          true
        else
          is_loop?(map, new_position, [position | visited])
        end
    end
  end

  def part_two(input) do
    map = parse_input(input)
    position = find_guard(map)
    {max_x, max_y} = Enum.max(Map.keys(map))

    maps =
      for y <- 0..max_y,
          x <- 0..max_x,
          Map.get(map, {x, y}) == ".",
          do: Map.put(map, {x, y}, "#")

    maps
    |> Task.async_stream(&is_loop?(&1, position))
    |> Enum.count()
  end
end
