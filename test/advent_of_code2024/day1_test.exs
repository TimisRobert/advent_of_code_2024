defmodule AdventOfCode2024.Day1Test do
  use ExUnit.Case, async: true

  test "part_one/1" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert AdventOfCode2024.Day1.part_one(input) == 11
  end

  test "part_two/1" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert AdventOfCode2024.Day1.part_two(input) == 31
  end
end
