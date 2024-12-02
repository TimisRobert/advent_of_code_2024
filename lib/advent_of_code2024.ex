defmodule AdventOfCode2024 do
  defmacro __using__(_opts) do
    quote do
      import NimbleParsec
      import AdventOfCode2024
    end
  end

  import NimbleParsec

  def whitespace() do
    ascii_char([?\s, ?\t, ?\n])
  end

  def ignore_whitespace() do
    whitespace()
    |> lookahead()
    |> repeat(ignore(whitespace()))
  end

  for day <- 1..1 do
    def solve_day(unquote(day) = day) do
      input =
        Application.app_dir(:advent_of_code_2024)
        |> Path.join("/priv/day#{day}.txt")
        |> File.read!()

      module = Module.concat(["AdventOfCode2024", "Day#{day}"])
      {module.part_one(input), module.part_two(input)}
    end
  end
end
