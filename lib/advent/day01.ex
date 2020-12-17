defmodule Advent.Day01 do
  def sample do
    """
    1721
    979
    366
    299
    675
    1456
    """
  end

  def input, do: File.read!("inputs/01.txt")

  def parse(data),
    do:
      String.split(data)
      |> Enum.map(fn str ->
        {num, _} = Integer.parse(str)
        num
      end)
      |> MapSet.new()

  @doc """
    iex> sample() |> parse() |> part1()
    514579

    iex> input() |> parse() |> part1()
    1019571
  """
  def part1(data) do
    val =
      data
      |> Enum.find(fn val -> MapSet.member?(data, 2020 - val) end)

    (2020 - val) * val
  end

  @doc """
    iex> sample() |> parse() |> part2()
    241861950

    iex> input() |> parse() |> part2()
    100655544
  """
  def part2(data) do
    [val1, val2] =
      Enum.find_value(data, fn num1 ->
        num2 = Enum.find(data, fn num2 -> MapSet.member?(data, 2020 - (num1 + num2)) end)

        if num2 do
          [num1, num2]
        else
          nil
        end
      end)

    val1 * val2 * (2020 - (val1 + val2))
  end
end
