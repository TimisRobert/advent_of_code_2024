defmodule AdventOfCode2024.Day3Test do
  use ExUnit.Case, async: true

  test "part_one/1" do
    input = """
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """

    assert AdventOfCode2024.Day3.part_one(input) == 161
  end

  test "part_two/1" do
    input = """
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """

    assert AdventOfCode2024.Day3.part_two(input) == 48
  end
end
