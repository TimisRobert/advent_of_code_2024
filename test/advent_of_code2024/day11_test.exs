defmodule AdventOfCode2024.Day11Test do
  use ExUnit.Case, async: true

  test "part_one/1" do
    input = """
    125 17
    """

    assert AdventOfCode2024.Day11.part_one(input) == 55312
  end

  # test "part_two/1" do
  #   input = """
  #   125 17
  #   """
  #
  #   assert AdventOfCode2024.Day11.part_two(input) == 0
  # end
end
