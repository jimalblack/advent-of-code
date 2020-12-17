defmodule Advent.Day06 do
  def sample do
    """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """
  end

  def input, do: File.read!("inputs/06.txt")

  def parse(data), do: data |> String.split("\n\n", trim: true)

  @doc """
    iex> sample() |> parse() |> part1()
    nil

    iex> input() |> parse() |> part1()
    nil
  """
  def part1(data) do
    data
    |> Enum.map(fn group ->
      group
      |> String.split()
      |> Enum.reduce(MapSet.new(), fn answers, set ->
        Enum.reduce(String.graphemes(answers), MapSet.new(), fn answer, answer_set ->
          MapSet.put(answer_set, answer)
        end)
        |> MapSet.union(set)
      end)
    end)
    |> Enum.reduce(0, fn set, acc -> acc + MapSet.size(set) end)
  end

  @doc """
    iex> sample() |> parse() |> part2()
    nil

    iex> input() |> parse() |> part2()
    nil
  """
  def part2(data) do
    nil
  end
end
