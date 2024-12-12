defmodule Mix.Tasks.GenerateDay do
  use Mix.Task
  alias Mix.Generator

  @impl true
  def run([day]) do
    app_dir = Application.app_dir(:advent_of_code_2024)

    Generator.create_file("priv/day#{day}.txt", "")

    template = Path.join(app_dir, "priv/day_template.eex")
    test_template = Path.join(app_dir, "priv/day_template_test.eex")

    Generator.copy_template(template, "lib/advent_of_code2024/day#{day}.ex", day: day)
    Generator.copy_template(test_template, "test/advent_of_code2024/day#{day}_test.exs", day: day)
  end
end
