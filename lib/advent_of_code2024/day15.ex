defmodule AdventOfCode2024.Day15 do
  use AdventOfCode2024

  defp parse_map(map) do
    for {line, y} <- map |> String.split("\n") |> Enum.with_index(),
        {cell, x} <- line |> String.graphemes() |> Enum.with_index(),
        into: Map.new(),
        do: {{x, y}, cell}
  end

  defp parse_input(input) do
    [map, movements] = String.split(input, "\n\n")
    movements = movements |> String.split() |> Enum.flat_map(&String.graphemes/1)
    {parse_map(map), movements}
  end

  defp find_robot(map) do
    Enum.find_value(map, fn {coords, cell} -> if cell == "@", do: coords end)
  end

  defp shift_direction({x, y}, "^"), do: {x, y - 1}
  defp shift_direction({x, y}, ">"), do: {x + 1, y}
  defp shift_direction({x, y}, "<"), do: {x - 1, y}
  defp shift_direction({x, y}, "v"), do: {x, y + 1}

  defp move_cell(map, position, movement) do
    new_position = shift_direction(position, movement)

    case Map.get(map, new_position) do
      "." ->
        {map |> Map.put(position, ".") |> Map.put(new_position, "@"), new_position}

      "#" ->
        {map, position}

      "O" ->
        new_position
        |> Stream.iterate(&shift_direction(&1, movement))
        |> Stream.map(&{&1, Map.get(map, &1)})
        |> Enum.find(&(elem(&1, 1) in ~w(. #)))
        |> case do
          {_, "#"} ->
            {map, position}

          {cell_position, "."} ->
            {map
             |> Map.put(position, ".")
             |> Map.put(cell_position, "O")
             |> Map.put(new_position, "@"), new_position}
        end
    end
  end

  defp gps_coordinates(map), do: for({{x, y}, "O"} <- map, do: 100 * y + x)

  def part_one(input) do
    {map, movements} = parse_input(input)
    position = find_robot(map)

    {map, _} =
      Enum.reduce(movements, {map, position}, fn movement, {map, position} ->
        move_cell(map, position, movement)
      end)

    map
    |> gps_coordinates()
    |> Enum.sum()
  end

  defp scale_map(map) do
    map
    |> Enum.sort()
    |> Enum.reduce(Map.new(), fn
      {{x, y}, "#"}, map ->
        coords = {x * 2, y}
        map |> Map.put(coords, "#") |> Map.put(shift_direction(coords, ">"), "#")

      {{x, y}, "O"}, map ->
        coords = {x * 2, y}
        map |> Map.put(coords, "[") |> Map.put(shift_direction(coords, ">"), "]")

      {{x, y}, "."}, map ->
        coords = {x * 2, y}
        map |> Map.put(coords, ".") |> Map.put(shift_direction(coords, ">"), ".")

      {{x, y}, "@"}, map ->
        coords = {x * 2, y}
        map |> Map.put(coords, "@") |> Map.put(shift_direction(coords, ">"), ".")
    end)
  end

  defp move_boxes(map, position, movement) do
    new_position = shift_direction(position, movement)

    case collect_boxes(map, new_position, movement) do
      :stop ->
        {map, position}

      boxes ->
        {boxes
         |> Enum.flat_map(&Tuple.to_list/1)
         |> Enum.sort(if movement == "^" or movement == "<", do: :asc, else: :desc)
         |> Enum.reduce(map, fn {position, cell}, map ->
           map
           |> Map.put(position, ".")
           |> Map.put(shift_direction(position, movement), cell)
         end)
         |> Map.put(position, ".")
         |> Map.put(new_position, "@"), new_position}
    end
  end

  defp near_box_cells({{{lx, ly}, _}, _}, "<"), do: [{lx - 1, ly}]
  defp near_box_cells({_, {{rx, ry}, _}}, ">"), do: [{rx + 1, ry}]
  defp near_box_cells({{{lx, ly}, _}, {{rx, ry}, _}}, "^"), do: [{lx, ly - 1}, {rx, ry - 1}]
  defp near_box_cells({{{lx, ly}, _}, {{rx, ry}, _}}, "v"), do: [{lx, ly + 1}, {rx, ry + 1}]

  defp box_cell({{x, y}, "["}), do: {{{x, y}, "["}, {{x + 1, y}, "]"}}
  defp box_cell({{x, y}, "]"}), do: {{{x - 1, y}, "["}, {{x, y}, "]"}}

  defp box_neighbours(map, movement, cell) do
    for position <- near_box_cells(cell, movement),
        sym = Map.get(map, position),
        sym in ~w(# [ ]),
        cell = {position, sym},
        uniq: true,
        do: if(sym == "#", do: cell, else: box_cell(cell))
  end

  defp collect_boxes(map, position, movement) do
    cell = {position, Map.get(map, position)} |> box_cell()
    collect_boxes(map, movement, [cell], MapSet.new())
  end

  defp collect_boxes(_map, _, [], visited), do: MapSet.to_list(visited)
  defp collect_boxes(_map, _, [{_, "#"} | _], _visited), do: :stop

  defp collect_boxes(map, movement, [box | rest], visited) do
    if box in visited do
      collect_boxes(map, movement, rest, visited)
    else
      visited = MapSet.put(visited, box)
      neighbours = box_neighbours(map, movement, box)
      stack = neighbours ++ rest
      collect_boxes(map, movement, stack, visited)
    end
  end

  defp move_cell_warehouse(map, position, movement) do
    new_position = shift_direction(position, movement)

    case Map.get(map, new_position) do
      "." -> {map |> Map.put(position, ".") |> Map.put(new_position, "@"), new_position}
      "#" -> {map, position}
      sym when sym in ~w([ ]) -> move_boxes(map, position, movement)
    end
  end

  defp gps_coordinates_warehouse(map), do: for({{x, y}, "["} <- map, do: 100 * y + x)

  def part_two(input) do
    {map, movements} = parse_input(input)
    map = scale_map(map)
    position = find_robot(map)

    {map, _} =
      Enum.reduce(movements, {map, position}, fn movement, {map, position} ->
        move_cell_warehouse(map, position, movement)
      end)

    map
    |> gps_coordinates_warehouse()
    |> Enum.sum()
  end
end
