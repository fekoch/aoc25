
defmodule Task01 do
  def parse_rotation(rotation_string, previous_state) do
    case rotation_string do
      "R" <> amount ->
        previous_state + elem Integer.parse(amount), 0
      "L" <> amount ->
        previous_state - elem Integer.parse(amount), 0
      "\n" -> 
        nil
    end
  end

  def raw_rotations(filename) do
    filename |> File.stream!() |> Stream.map(&(Task01.parse_rotation(&1, 0))) |> Stream.reject(&is_nil/1)
  end

  def positions(filename) do
    50..50 |> Stream.concat(raw_rotations(filename)) |> Stream.scan(&rotate/2)
  end

  def rotate(position, amount) do
    new_position = position + amount
    cond do
      new_position < 0 -> rotate(100, new_position)
      new_position > 99 -> rotate(0, new_position - 100)
      true -> new_position
    end
  end

  def rotate_and_count(amount, %{:pos => position}) do
    rotate_and_count(position, amount, 0)
  end

  def rotate_and_count(amount, position) when is_number(position) do
    rotate_and_count(position, amount, 0)
  end

  def rotate_and_count(position, amount, n_zeros)  do 
    new = position + amount

    cond do
      new < 0 -> rotate_and_count(100, new, n_zeros + (if position != 0, do: 1, else: 0))
      new == 100 -> %{pos: 0, n_zeros: n_zeros + 1}
      new > 99 -> rotate_and_count(0, new - 100, n_zeros + 1)
      new == 0 -> %{pos: new, n_zeros: n_zeros + 1}
      true -> %{pos: new, n_zeros: n_zeros}
    end
  end

  def total_zero_count(filename) do
    raw_rotations(filename) |> Stream.scan(%{pos: 50, n_zeros: 0}, &rotate_and_count/2) |> dbg() |> Enum.reduce(
      0, fn %{n_zeros: n}, acc -> acc + n end 
    )
  end

  def get_password(filename) do
    positions(filename) |> Enum.count(&(&1 == 0))
  end
end
