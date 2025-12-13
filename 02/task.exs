defmodule Task02 do
  def parse(input_file) do
    File.read!(input_file) |> String.trim() |> String.split(",") |> Stream.map(&parse_range/1)
  end

  def parse_range(range_string) do
    [a, b] = String.split(range_string, "-")
    Range.new(elem(Integer.parse(a), 0), elem(Integer.parse(b),0))
  end

  def half_string(string) do
    String.split_at(string, div(String.length(string), 2))
  end

  def invalid_simple?(num) do
    {first, second} = half_string("#{num}")
    first == second
  end

  def invalid?(num) do
    string = "#{num}"

    String.match?(string, ~r/^(.+)\1+$/)
  end

  def all_ids(input_file) do
    parse(input_file) |> Stream.concat()
  end

  def invalid_ids(input_file) do
    all_ids(input_file) |> Stream.filter(&invalid?/1)
  end

  def sum_of_invalid(input_file) do
    invalid_ids(input_file) |> Enum.sum()
  end

end
