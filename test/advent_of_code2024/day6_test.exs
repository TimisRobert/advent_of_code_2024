defmodule AdventOfCode2024.Day6Test do
  use ExUnit.Case, async: true

  test "part_one/1" do
    input = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    assert AdventOfCode2024.Day6.part_one(input) == 41
  end

  test "part_two/1" do
    input = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    assert AdventOfCode2024.Day6.part_two(input) == 6
  end
end
