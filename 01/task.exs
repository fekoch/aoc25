
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

  def get_password(filename) do
    positions(filename) |> Enum.count(&(&1 == 0))
  end
end
