defmodule AdventOfCode2024.Day14 do
  use AdventOfCode2024

  signed_integer =
    optional(string("-"))
    |> integer(min: 1)
    |> post_traverse(:add_sign)

  defp add_sign(rest, [number], context, _line, _offset), do: {rest, [number], context}
  defp add_sign(rest, [number, "-"], context, _line, _offset), do: {rest, [-number], context}

  defparsec :parse_input,
            repeat(
              wrap(
                ignore(string("p="))
                |> concat(signed_integer)
                |> ignore(string(","))
                |> concat(signed_integer)
              )
              |> wrap(
                ignore(string(" v="))
                |> concat(signed_integer)
                |> ignore(string(","))
                |> concat(signed_integer)
                |> ignore(string("\n"))
              )
              |> wrap()
            )

  def wrap_int(int, max) when int < 0, do: max + int
  def wrap_int(int, max) when int >= max, do: abs(max - int)
  def wrap_int(int, _max), do: int

  defp move_robots(robots, {max_x, max_y}) do
    for {{x, y}, {xs, ys} = speed} <- robots,
        do: {{wrap_int(x + xs, max_x), wrap_int(y + ys, max_y)}, speed}
  end

  defp to_tuples(line), do: line |> Enum.map(&List.to_tuple/1) |> List.to_tuple()

  defp generate_quadrants({max_x, max_y}) do
    rem_x = rem(max_x, 2)
    rem_y = rem(max_y, 2)

    for range_y <- [
          0..(div(max_y - rem_y, 2) - rem_y),
          (div(max_y - rem_y, 2) + rem_y)..(max_y - 1)
        ],
        range_x <- [
          0..(div(max_x - rem_x, 2) - rem_x),
          (div(max_x - rem_x, 2) + rem_x)..(max_x - 1)
        ],
        do: {range_x, range_y}
  end

  def part_one(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    size = {101, 103}
    quadrants = generate_quadrants(size)

    robots =
      input
      |> Enum.map(&to_tuples/1)
      |> Stream.iterate(&move_robots(&1, size))
      |> Enum.at(100)

    quadrants
    |> Enum.map(fn {range_x, range_y} ->
      Enum.count(robots, fn {{x, y}, _} -> x in range_x and y in range_y end)
    end)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def percentage_neighbour(robots) do
    positions = MapSet.new(robots, &elem(&1, 0))

    count =
      Enum.count(robots, fn {{x, y}, _} ->
        Enum.any?([{x + 1, y}, {x - 1, y}, {x, y - 1}, {x, y + 1}], &(&1 in positions))
      end)

    div(count * 100, length(robots))
  end

  def part_two(input) do
    {:ok, input, _, _, _, _} = parse_input(input)

    size = {101, 103}

    input
    |> Enum.map(&to_tuples/1)
    |> Stream.iterate(&move_robots(&1, size))
    |> Stream.with_index()
    |> Stream.drop_while(&(percentage_neighbour(elem(&1, 0)) < 51))
    |> Enum.at(0)
    |> then(&elem(&1, 1))
  end
end
