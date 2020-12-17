defmodule Advent.Day03 do
  def sample do
    """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """
  end

  def input, do: File.read!("inputs/03.txt")

  def parse(data),
    do: data |> String.split() |> Enum.map(&parse_map_line/1)

  @doc """
    iex> sample() |> parse() |> part1()
    7

    iex> input() |> parse() |> part1()
    292
  """
  def part1(data) do
    navigate_to_bottom(data, {3, 1})
  end

  @doc """
    iex> sample() |> parse() |> part2()
    336

    iex> input() |> parse() |> part2()
    9354744432
  """
  def part2(data) do
    navigate_to_bottom(data, {1, 1}) * navigate_to_bottom(data, {3, 1}) *
      navigate_to_bottom(data, {5, 1}) * navigate_to_bottom(data, {7, 1}) *
      navigate_to_bottom(data, {1, 2})
  end

  defp parse_map_line(line) do
    line
    |> String.split("", trim: true)
    |> Enum.map(fn char ->
      case char do
        "." -> :open
        "#" -> :tree
      end
    end)
  end

  defp create_localized_map(template, {x, y}) do
    # Get 5 Tiles in all directions
    [first_row | _] = template
    range = 5
    min_pos = {x - range, max(0, y - range)}

    template_vertical = Enum.slice(template, max(0, y - range), range * 2 + 1)

    width = length(first_row)
    position_in_row = rem(x, width)
    # IO.inspect({:position, position_in_row, width, range})

    Enum.reduce(0..(length(template_vertical) - 1), %{}, fn level, terrain ->
      left_pad =
        if position_in_row - range < 0 do
          Enum.slice(Enum.at(template_vertical, level), (position_in_row - range)..-1)
        else
          []
        end

      right_pad =
        if position_in_row + range > width do
          Enum.slice(Enum.at(template_vertical, level), 0, range - (width - position_in_row))
        else
          []
        end

      row =
        left_pad ++
          Enum.slice(
            Enum.at(template_vertical, level),
            max(0, position_in_row - range),
            range + 1
          ) ++ right_pad

      Map.merge(
        terrain,
        Enum.reduce(Enum.with_index(row), %{}, fn {value, offset}, set ->
          {min_x, min_y} = min_pos
          Map.put(set, {min_x + offset, min_y + level}, value)
        end)
      )
    end)
  end

  defp navigate_to_bottom(template, {slope_x, slope_y}, trees_hit \\ 0, {x, y} \\ {0, 0}) do
    new_x = x + slope_x
    new_y = y + slope_y
    map = create_localized_map(template, {new_x, new_y})

    cond do
      new_y >= length(template) ->
        trees_hit

      Map.fetch!(map, {new_x, new_y}) == :tree ->
        navigate_to_bottom(template, {slope_x, slope_y}, trees_hit + 1, {new_x, new_y})

      true ->
        navigate_to_bottom(template, {slope_x, slope_y}, trees_hit, {new_x, new_y})
    end
  end
end
