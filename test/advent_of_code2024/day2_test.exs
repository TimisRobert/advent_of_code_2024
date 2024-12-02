defmodule AdventOfCode2024.Day2Test do
  use ExUnit.Case, async: true

  test "part_one/1" do
    input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    assert AdventOfCode2024.Day2.part_one(input) == 2
  end

  test "part_two/1" do
    input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    assert AdventOfCode2024.Day2.part_two(input) == 4
  end
end
