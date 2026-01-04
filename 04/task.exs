defmodule Task04 do
  def neighbours({x, y}) do
    for ox <- -1..1,
        oy <- -1..1,
        {ox, oy} != {0, 0},
        {x, y} = {x + ox, y + oy},
        x >= 0,
        y >= 0 do
      {x, y}
    end
  end

  def at(map, x, y) when y < length(map) and x < length(hd(map)) do
    map |> Enum.at(y) |> Enum.at(x)
  end

  def at(_map, _x, _y) do
    "."
  end

  def parse(filename) do
    f = File.stream!(filename)

    f
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.codepoints/1)
  end

  def width(map) do
    map |> hd() |> length()
  end

  def height(map) do
    length(map)
  end

  def accessible_positions(map) do
    height = height(map)
    width = width(map)

    for y <- 0..(height - 1), x <- 0..(width - 1) do
      at(map, x, y) == "@" and
        neighbours({x, y})
        |> Enum.map(fn {x, y} -> at(map, x, y) end)
        |> Enum.filter(&(&1 == "@"))
        |> Enum.count() <
          4
    end
  end

  def print_map(map) do
    map
    |> Enum.map(fn row -> Enum.reduce(row, &(&1 <> &2)) end)
    |> Enum.map(&IO.puts/1)
  end

  def visualize(input) do
    accessible_positions(parse(input))
    |> Enum.map(
      &if &1 do
        "X"
      else
        "."
      end
    )
    |> Enum.chunk_every(width(parse(input)))
    |> Enum.map(fn row -> Enum.reduce(row, &(&2 <> &1)) end)
    |> Enum.each(&IO.puts(&1))
  end

  def count_valid_positions(input) do
    accessible_positions(parse(input))
    |> Enum.count(& &1)
  end

  def remove_positions(map, map_mask) do
    height = height(map)
    width = width(map)

    for y <- 0..(height - 1), x <- 0..(width - 1) do
      if Enum.at(map_mask, y * height + x) do
        "."
      else
        at(map, x, y)
      end
    end
    |> Enum.chunk_every(width)
  end

  def count_true_valid_positions(input) do
    map = parse(input)
    height = height(map)
    width = width(map)

    count_true_valid_positions(map, width, height, 0)
  end

  def count_true_valid_positions(map, width, height, total_removed) do
    print_map(map)
    accessible = accessible_positions(map)
    count = accessible |> Enum.count(& &1)
    IO.puts("Accessible positions: #{count}")

    if count > 0 do
      new_map = remove_positions(map, accessible)
      count_true_valid_positions(new_map, width, height, count + total_removed)
    else
      total_removed
    end
  end
end
