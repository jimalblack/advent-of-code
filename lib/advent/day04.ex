defmodule Advent.Day04 do
  def sample do
    """
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """
  end

  def input, do: File.read!("inputs/04.txt")

  def parse(data), do: data |> String.split("\n\n") |> Enum.map(&parse_passport_string/1)

  @doc """
    iex> sample() |> parse() |> part1()
    2

    iex> input() |> parse() |> part1()
    196
  """

  def part1(data, valid_count \\ 0)

  def part1([passport | passports], valid_count) do
    if MapSet.subset?(
         MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]),
         MapSet.new(Map.keys(passport))
       ) do
      part1(passports, valid_count + 1)
    else
      part1(passports, valid_count)
    end
  end

  def part1([], valid_count), do: valid_count

  @doc """
    iex> sample() |> parse() |> part2()
    2

    iex> input() |> parse() |> part2()
    114
  """
  def part2(data, valid_count \\ 0)

  def part2([passport | passports], valid_count) do
    with {:ok, byr} <- Map.fetch(passport, "byr"),
         true <- String.to_integer(byr) in 1920..2002,
         {:ok, iyr} <- Map.fetch(passport, "iyr"),
         true <- String.to_integer(iyr) in 2010..2020,
         {:ok, eyr} <- Map.fetch(passport, "eyr"),
         true <- String.to_integer(eyr) in 2020..2030,
         {:ok, hgt} <- Map.fetch(passport, "hgt"),
         [_, size, measurement] <- Regex.run(~r/(\d+)(cm|in)/, hgt),
         true <-
           (case measurement do
              "cm" -> String.to_integer(size) in 150..193
              "in" -> String.to_integer(size) in 59..76
            end),
         {:ok, hcl} <- Map.fetch(passport, "hcl"),
         true <- Regex.match?(~r/#[a-f0-9]{6}/i, hcl),
         {:ok, ecl} <- Map.fetch(passport, "ecl"),
         true <- ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],
         {:ok, pid} <- Map.fetch(passport, "pid"),
         true <- Regex.match?(~r/^\d{9}$/, pid) do
      part2(passports, valid_count + 1)
    else
      _ ->
        part2(passports, valid_count)
    end
  end

  def part2([], valid_count), do: valid_count

  defp parse_passport_string(data) do
    String.split(data)
    |> Enum.reduce(%{}, fn kv_string, set ->
      [key, value] = String.split(kv_string, ":", trim: true)
      Map.put(set, key, value)
    end)
  end
end
