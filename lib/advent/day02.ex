defmodule Advent.Day02 do
  def sample do
    """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """
  end

  def input, do: File.read!("inputs/02.txt")

  def parse(data), do: data |> String.split("\n", trim: true) |> Enum.map(&parse_password/1)

  @doc """
    iex> sample() |> parse() |> part1()
    2

    iex> input() |> parse() |> part1()
    556
  """
  def part1(data) do
    Enum.filter(data, fn {min, max, letter, password} ->
      count = Enum.filter(String.split(password, ""), &(letter == &1)) |> Enum.count()
      min <= count and count <= max
    end)
    |> Enum.count()
  end

  @doc """
    iex> sample() |> parse() |> part2()
    1

    iex> input() |> parse() |> part2()
    605
  """
  def part2(data) do
    Enum.filter(data, fn {index1, index2, letter, password} ->
      string1 = String.at(password, index1 - 1)
      string2 = String.at(password, index2 - 1)

      string1 != string2 and (string1 == letter or string2 == letter)
    end)
    |> Enum.count()
  end

  defp parse_password(password) do
    with [_, minString, maxString, letter, password] <-
           Regex.run(~r/(\d+)-(\d+) (\w): (\w+)/, password),
         {min, _} <- Integer.parse(minString),
         {max, _} <- Integer.parse(maxString) do
      {min, max, letter, password}
    end
  end
end
