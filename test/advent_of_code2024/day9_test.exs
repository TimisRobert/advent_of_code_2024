defmodule AdventOfCode2024.Day9Test do
  use ExUnit.Case, async: true

  test "part_one/1" do
    input = "2333133121414131402"

    assert AdventOfCode2024.Day9.part_one(input) == 1928
  end

  test "part_two/1" do
    input = "2333133121414131402"

    assert AdventOfCode2024.Day9.part_two(input) == 2858
  end
end
