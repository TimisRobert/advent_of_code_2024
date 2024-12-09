defmodule AdventOfCode2024.Day9 do
  use AdventOfCode2024

  defp create_files({0, _}, acc), do: acc

  defp create_files({size, idx}, {list, id, tot}) when rem(idx, 2) == 0,
    do: {Enum.reduce(0..(size - 1), list, fn _, list -> [id | list] end), id + 1, tot + size}

  defp create_files({size, _}, {list, id, tot}),
    do: {Enum.reduce(0..(size - 1), list, fn _, list -> [nil | list] end), id, tot}

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce({[], 0, 0}, &create_files/2)
  end

  defp reorder_files(list, tot), do: reorder_files(Enum.reverse(list), list, [], tot)
  defp reorder_files(_, _, acc, 0), do: Enum.reverse(acc)
  defp reorder_files(t, [nil | l], acc, tot), do: reorder_files(t, l, acc, tot)
  defp reorder_files([nil | t], [f | l], acc, tot), do: reorder_files(t, l, [f | acc], tot - 1)
  defp reorder_files([h | t], l, acc, tot), do: reorder_files(t, l, [h | acc], tot - 1)

  def part_one(input) do
    {list, _, tot} = parse_input(input)

    list
    |> reorder_files(tot)
    |> Enum.with_index()
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end

  defp create_blocks(list), do: create_blocks(list, [])
  defp create_blocks([h | t], [[f | _] = c | l]) when h == f, do: create_blocks(t, [[h | c] | l])
  defp create_blocks([nil | t], acc), do: create_blocks(t, acc)
  defp create_blocks([h | t], l), do: create_blocks(t, [[h] | l])
  defp create_blocks([], acc), do: Enum.reverse(acc)

  defp reorder_blocks(list, tot), do: reorder_blocks(Enum.reverse(list), list, [], tot)
  defp reorder_blocks(_, _, acc, 0), do: Enum.reverse(acc)
  defp reorder_blocks(t, [nil | l], acc, tot), do: reorder_blocks(t, l, acc, tot)
  defp reorder_blocks([nil | t], [f | l], acc, tot), do: reorder_blocks(t, l, [f | acc], tot - 1)
  defp reorder_blocks([h | t], l, acc, tot), do: reorder_blocks(t, l, [h | acc], tot - 1)

  def part_two(input) do
    {list, _, tot} = parse_input(input)
    blocks = create_blocks(list)

    list
    |> reorder_blocks(tot)
    |> Enum.with_index()
    |> Enum.reject(&is_nil(elem(&1, 0)))
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end
end
