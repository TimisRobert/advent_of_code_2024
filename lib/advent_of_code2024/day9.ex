defmodule AdventOfCode2024.Day9 do
  use AdventOfCode2024

  defp create_files(list, acc \\ {[], 0})

  defp create_files([{size, idx} | t], {list, id}) when rem(idx, 2) == 0 do
    create_files(t, {List.duplicate(id, size) ++ list, id + 1})
  end

  defp create_files([{size, _} | t], {list, id}) do
    create_files(t, {List.duplicate(nil, size) ++ list, id})
  end

  defp create_files([], {list, _}), do: Enum.reverse(list)

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> create_files()
  end

  defp reorder_files(list), do: reorder_files(list, Enum.reverse(list), {[], 0, length(list)})
  defp reorder_files(_, _, {list, one, one}), do: Enum.reverse(list)
  defp reorder_files(t, [nil | l], {acc, one, two}), do: reorder_files(t, l, {acc, one, two - 1})

  defp reorder_files([nil | t], [f | l], {acc, one, two}),
    do: reorder_files(t, l, {[f | acc], one + 1, two - 1})

  defp reorder_files([h | t], l, {acc, one, two}),
    do: reorder_files(t, l, {[h | acc], one + 1, two})

  def part_one(input) do
    input
    |> parse_input()
    |> reorder_files()
    |> Enum.with_index()
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end

  defp reorder_block({block, block_idx}, chunks) do
    chunks
    |> Enum.find(fn {chunk, _} -> Enum.count(chunk, &is_nil/1) >= length(block) end)
    |> case do
      {_, chunk_idx} when chunk_idx < block_idx ->
        chunks
        |> List.update_at(chunk_idx, fn {chunk, idx} ->
          {_, list} =
            Enum.reduce(chunk, {block, []}, fn
              nil, {[h | t], acc} -> {t, [h | acc]}
              elem, {block, acc} -> {block, [elem | acc]}
            end)

          {Enum.reverse(list), idx}
        end)
        |> List.replace_at(block_idx, {List.duplicate(nil, length(block)), block_idx})

      _ ->
        chunks
    end
  end

  def part_two(input) do
    chunks =
      input
      |> parse_input()
      |> Enum.chunk_by(& &1)
      |> Enum.with_index()

    chunks
    |> Enum.filter(&Enum.all?(elem(&1, 0)))
    |> Enum.reverse()
    |> Enum.reduce(chunks, &reorder_block/2)
    |> Enum.flat_map(&elem(&1, 0))
    |> Enum.with_index()
    |> Enum.reject(&is_nil(elem(&1, 0)))
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end
end
