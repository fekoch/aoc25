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

  def at(map, x, y) when y < tuple_size(map) and x < tuple_size(elem(map, 0)) do
    map |> elem(y) |> elem(x)
  end

  def at(_map, _x, _y) do
    "."
  end

  def parse(filename) do
    f = File.stream!(filename)

    f
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

  def width(map) do
    map |> elem(0) |> tuple_size()
  end

  def check_positions(filename) do
    f = parse(filename)
    height = f |> tuple_size()
    width = width(f)

    for y <- 0..(height - 1), x <- 0..(width - 1) do
      at(f, x, y) == "@" and
        neighbours({x, y})
        |> Enum.map(fn {x, y} -> at(f, x, y) end)
        |> Enum.filter(&(&1 == "@"))
        |> Enum.count() <
          4
    end
  end

  def visualize(input) do
    check_positions(input)
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
    check_positions(input)
    |> Enum.count(& &1)
  end
end
