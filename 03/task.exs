defmodule Task03 do

  @total_digits 12

  def parse_line(string) do
    string |> String.codepoints() |> Enum.map(fn c -> elem(Integer.parse(c), 0) end)
  end

  def parse(input_file) do
    File.stream!(input_file) |> Stream.map(&String.trim/1) |> Stream.map(&parse_line/1)
  end

  def split_search_sequence(joltages, 1) do
    [Enum.max(joltages) | []]
  end

  def split_search_sequence(joltages, digits) do
    subsequence = Enum.take(joltages, length(joltages) - (digits-1))
    max = Enum.max(subsequence)
    max_index = Enum.find_index(subsequence, &(&1 == max))
    leftover =Enum.slice(joltages, (max_index+1)..-1//1 )

    [max | split_search_sequence(leftover, digits-1)]
  end

  def max_joltage(joltages) do
    dbg(joltages)

    max_values = split_search_sequence(joltages, @total_digits)
    dbg(max_values, charlists: :as_lists)

    join_digits(max_values)
  end

  def join_digits(digits) do
    digits |> Enum.reverse() |> Enum.map(&("#{&1}")) |> Enum.reduce(&<>/2) |>  Integer.parse() |> elem(0)
  end

  def max_joltages(input_file) do
    parse(input_file) |> Enum.map(&max_joltage/1) 
  end

  def total_output(input_file) do
    max_joltages(input_file) |> Enum.sum() |> dbg()
  end
end

