defmodule AdventOfCode2024.Day4 do
  use AdventOfCode2024

  def parse_input(input) do
    lines = String.split(input, "\n")

    for {line, y} <- Enum.with_index(lines),
        {letter, x} <- line |> String.graphemes() |> Enum.with_index(),
        reduce: Map.new() do
      map ->
        map
        |> Map.put({x, y}, letter)
        |> Map.update(:max_x, 0, &if(x > &1, do: x, else: &1))
        |> Map.update(:max_y, 0, &if(y > &1, do: y, else: &1))
    end
  end

  defp count_xmas(map, {x_start, y_start}) do
    directions = for x <- -1..1, y <- -1..1, do: {x, y}

    for {x_dir, y_dir} <- directions do
      for step <- 0..3, into: "" do
        Map.get(map, {x_dir * step + x_start, y_dir * step + y_start}, "")
      end
    end
    |> Enum.count(&(&1 in ~w(XMAS SAMX)))
  end

  def part_one(input) do
    map = parse_input(input)

    for {coordinates, letter} <- map, letter in ~w(X S), reduce: 0 do
      total -> total + count_xmas(map, coordinates) / 2
    end
    |> trunc()
  end

  defp x_mas?(<<"M", _, "S", _, "A", _, "M", _, "S">>), do: true
  defp x_mas?(<<"M", _, "M", _, "A", _, "S", _, "S">>), do: true
  defp x_mas?(<<"S", _, "M", _, "A", _, "S", _, "M">>), do: true
  defp x_mas?(<<"S", _, "S", _, "A", _, "M", _, "M">>), do: true
  defp x_mas?(_), do: false

  defp count_x_mas(map) do
    max_x = Map.fetch!(map, :max_x)
    max_y = Map.fetch!(map, :max_y)

    for y <- 0..(max_y - 2), x <- 0..(max_x - 2) do
      for y <- y..(y + 2), x <- x..(x + 2), into: "", do: Map.get(map, {x, y})
    end
    |> Enum.count(&x_mas?/1)
  end

  def part_two(input) do
    input
    |> parse_input()
    |> count_x_mas()
  end
end
