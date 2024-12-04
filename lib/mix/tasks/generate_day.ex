defmodule Mix.Tasks.GenerateDay do
  use Mix.Task

  @impl true
  def run([day]) do
    app_dir = Application.app_dir(:advent_of_code_2024)

    app_dir
    |> Path.join("/priv/day#{day}.txt")
    |> File.write!("")

    day_template =
      app_dir
      |> Path.join("/priv/day_template.eex")
      |> EEx.eval_file(day: day)

    day_test_template =
      app_dir
      |> Path.join("/priv/day_template_test.eex")
      |> EEx.eval_file(day: day)

    app_dir
    |> Path.join("../../../../lib/advent_of_code2024/day#{day}.ex")
    |> File.write!(day_template)

    app_dir
    |> Path.join("../../../../test/advent_of_code2024/day#{day}_test.exs")
    |> File.write!(day_test_template)
  end
end
