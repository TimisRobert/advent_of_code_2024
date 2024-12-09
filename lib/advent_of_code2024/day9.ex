defmodule AdventOfCode2024.Day9 do
  use AdventOfCode2024

  defp create_files({0, _}, acc), do: acc

  defp create_files({size, idx}, {list, id}) when rem(idx, 2) == 0 do
    {List.duplicate(id, size) ++ list, id + 1}
  end

  defp create_files({size, _}, {list, id}) do
    {List.duplicate(nil, size) ++ list, id}
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce({[], 0}, &create_files/2)
    |> then(&elem(&1, 0))
  end

  defp reorder_files(list, tot), do: reorder_files(Enum.reverse(list), list, [], tot)
  defp reorder_files(_, _, acc, 0), do: Enum.reverse(acc)
  defp reorder_files(t, [nil | l], acc, tot), do: reorder_files(t, l, acc, tot)
  defp reorder_files([nil | t], [f | l], acc, tot), do: reorder_files(t, l, [f | acc], tot - 1)
  defp reorder_files([h | t], l, acc, tot), do: reorder_files(t, l, [h | acc], tot - 1)

  def part_one(input) do
    list = parse_input(input)
    tot = Enum.count(list, & &1)

    list
    |> reorder_files(tot)
    |> Enum.with_index()
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end

  defp create_blocks(list), do: create_blocks(list, [])
  defp create_blocks([h | t], [[h | _] = c | l]), do: create_blocks(t, [[h | c] | l])
  defp create_blocks([nil | t], acc), do: create_blocks(t, acc)
  defp create_blocks([h | t], l), do: create_blocks(t, [[h] | l])
  defp create_blocks([], acc), do: Enum.reverse(acc)

  defp skip_nils(list), do: skip_nils(list, 0)
  defp skip_nils([nil | r], acc), do: skip_nils(r, acc + 1)
  defp skip_nils(list, acc), do: {list, acc}

  defp reorder_blocks(list, blocks), do: reorder_blocks(Enum.reverse(list), blocks, [], nil)

  defp reorder_blocks([nil | _] = list, [f | l] = b, acc, nil) do
    if hd(f) in acc do
      reorder_blocks(Enum.reverse(acc) ++ list, l, [], nil)
    else
      {list, nils} = skip_nils(list)

      if length(f) <= nils do
        reorder_blocks(list, l, List.duplicate(nil, nils - length(f)) ++ f ++ acc, List.first(f))
      else
        reorder_blocks(list, b, List.duplicate(nil, nils) ++ acc, nil)
      end
    end
  end

  defp reorder_blocks([], [_ | l], acc, _), do: reorder_blocks(Enum.reverse(acc), l, [], nil)
  defp reorder_blocks([h | t], b, acc, h), do: reorder_blocks(t, b, [nil | acc], h)
  defp reorder_blocks([h | t], b, acc, del), do: reorder_blocks(t, b, [h | acc], del)
  defp reorder_blocks(_, [], acc, _), do: Enum.reverse(acc)

  def part_two(input) do
    list = parse_input(input)
    blocks = create_blocks(list)

    list
    |> reorder_blocks(blocks)
    |> Enum.with_index()
    |> Enum.reject(&is_nil(elem(&1, 0)))
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end
end
