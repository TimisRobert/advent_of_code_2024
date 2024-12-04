defmodule Mix.Tasks.Solve do
  use Mix.Task

  @impl true
  def run([day]) do
    {one, two} =
      day
      |> String.to_integer()
      |> AdventOfCode2024.solve_day()

    Mix.shell().info("Part one: #{one}")
    Mix.shell().info("Part two: #{two}")
  end
end
