defmodule AdventOfCode2024.Day12Test do
  use ExUnit.Case, async: true

  test "part_one/1" do
    input = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

    assert AdventOfCode2024.Day12.part_one(input) == 1930
  end

  test "part_two/1" do
    input = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

    assert AdventOfCode2024.Day12.part_two(input) == 1206
  end
end
