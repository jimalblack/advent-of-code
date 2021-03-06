defmodule Advent do
  @template_path "lib/day.template"
  @test_path "test/advent_test.exs"

  def generate(num) do
    day = String.pad_leading(num, 2, "0")
    if File.exists?("lib/advent/day#{day}.ex"), do: raise("File already exists")

    code = File.read!(@template_path) |> String.replace("{{NUM}}", day)
    File.write!("lib/advent/day#{day}.ex", code)

    File.write!("inputs/#{day}.txt", "")

    tests =
      File.read!(@test_path)
      |> String.replace("end", "  doctest Advent.Day#{day}, import: true\nend")

    File.write!(@test_path, tests)
  end

  def run(day, part) do
    day = String.pad_leading(day, 2, "0")
    run(day, part, :sample)
    run(day, part, :input)
  end

  def run(day, part, input) do
    module = String.to_atom("#{__MODULE__}.Day#{day}")
    inp = apply(module, input, [])
    parsed = apply(module, :parse, [inp])
    result = apply(module, part, [parsed])
    IO.puts("Day#{day}.#{part}(#{input}) = #{inspect(result)}")
  end
end
