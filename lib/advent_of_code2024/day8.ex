defmodule AdventOfCode2024.Day8 do
  use AdventOfCode2024

  defp parse_input(input) do
    for {line, y} <- input |> String.split("\n") |> Enum.with_index(),
        {cell, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: Map.new() do
      {{x, y}, cell}
    end
  end

  defp find_antinodes(map) do
    {max_y, max_x} = Enum.max(Map.keys(map))

    map
    |> Enum.reject(fn {_, cell} -> cell == "." end)
    |> Enum.flat_map(fn {{start_x, start_y} = start, start_cell} ->
      map
      |> Enum.filter(fn {mid, mid_cell} -> start != mid and start_cell == mid_cell end)
      |> Enum.map(fn {{x, y}, _} -> {x + (x - start_x), y + (y - start_y)} end)
    end)
    |> Enum.filter(fn {x, y} -> x <= max_x and x >= 0 and y <= max_y and y >= 0 end)
    |> MapSet.new()
  end

  defp find_resonance_antinodes(map) do
    {max_y, max_x} = Enum.max(Map.keys(map))

    map
    |> Enum.reject(fn {_, cell} -> cell == "." end)
    |> Enum.flat_map(fn {{start_x, start_y} = start, start_cell} ->
      map
      |> Enum.filter(fn {mid, mid_cell} -> start != mid and start_cell == mid_cell end)
      |> Enum.flat_map(fn {{x, y} = mid, _} ->
        d_x = x - start_x
        d_y = y - start_y

        mid
        |> Stream.iterate(fn {x, y} -> {x + d_x, y + d_y} end)
        |> Enum.take_while(fn {x, y} -> x <= max_x and x >= 0 and y <= max_y and y >= 0 end)
      end)
    end)
    |> MapSet.new()
  end

  def part_one(input) do
    input
    |> parse_input()
    |> find_antinodes()
    |> MapSet.size()
  end

  def part_two(input) do
    input
    |> parse_input()
    |> find_resonance_antinodes()
    |> MapSet.size()
  end
end
