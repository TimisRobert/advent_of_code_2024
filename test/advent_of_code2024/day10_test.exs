defmodule AdventOfCode2024.Day10Test do
  use ExUnit.Case, async: true

  test "part_one/1" do
    input = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    assert AdventOfCode2024.Day10.part_one(input) == 36
  end

  test "part_two/1" do
    input = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    assert AdventOfCode2024.Day10.part_two(input) == 81
  end
end
