defmodule Advent.Day05 do
  def sample do
    """
    """
  end

  # FFFBBBFRRR
  # BBFFBBFRLL
  def input, do: File.read!("inputs/05.txt")

  def parse(data), do: data |> String.split() |> Enum.map(&parse_seat/1)

  @doc """
    iex> sample() |> parse() |> part1()
    0

    iex> input() |> parse() |> part1()
    998
  """
  def part1(data) do
    Enum.reduce(data, 0, fn {_, _, seat_id}, highest ->
      if seat_id > highest do
        seat_id
      else
        highest
      end
    end)
  end

  @doc """
    iex> sample() |> parse() |> part2()
    nil

    iex> input() |> parse() |> part2()
    676
  """
  def part2(data) do
    seats =
      data
      |> Enum.map(fn {_, _, seat_id} -> seat_id end)

    find_empty_seat(seats, seats)
  end

  defp find_empty_seat([seat | seats], all_seats) do
    cond do
      (seat + 2) in all_seats and (seat + 1) not in all_seats -> seat + 1
      (seat - 2) in all_seats and (seat - 1) not in all_seats -> seat - 1
      true -> find_empty_seat(seats, all_seats)
    end
  end

  defp find_empty_seat([], _), do: nil

  defp parse_seat(seat) do
    {row_instructions, column_instructions} = String.split(seat, "", trim: true) |> Enum.split(7)

    row = parse_instructions(row_instructions, "F", "B", 0..127)
    column = parse_instructions(column_instructions, "L", "R", 0..7)
    {row, column, row * 8 + column}
  end

  defp parse_instructions(instructions, front_character, back_character, range)
       when not is_list(range),
       do: parse_instructions(instructions, front_character, back_character, Enum.to_list(range))

  defp parse_instructions([instruction], front_character, back_character, range) do
    case instruction do
      ^front_character -> Enum.at(range, 0)
      ^back_character -> Enum.at(range, 1)
    end
  end

  defp parse_instructions([instruction | instructions], front_character, back_character, range) do
    new_range =
      case instruction do
        ^front_character ->
          Enum.slice(range, 0..(floor(length(range) / 2) - 1))

        ^back_character ->
          Enum.slice(range, ceil(length(range) / 2)..-1)
      end

    parse_instructions(instructions, front_character, back_character, new_range)
  end
end
