defmodule Mix.Tasks.Solve do
  use Mix.Task

  @impl true
  def run([day]) do
    day
    |> String.to_integer()
    |> AdventOfCode2024.solve_day()
    |> IO.inspect()
  end
end
