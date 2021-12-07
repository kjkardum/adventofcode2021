{:ok, data} = File.read("input.txt")
sorted = data
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.sort

defmodule Day7 do
  def findMiddle(l) do
    len = length(l)
    len2 = trunc(len/2)
    case rem(len,2) do
      0 ->
        (Enum.at(l, len2 - 1) + Enum.at(l, len2)) / 2
      1 ->
        Enum.at(l, len2)
    end
  end
  def totalDistanceFromMiddle(l, middle) do
    Enum.map(l, fn(x) -> abs(x - middle) end)
    |> Enum.sum
    |> trunc
  end
  def solve(input) do
    l = input
    middle = findMiddle(l)
    totalDistanceFromMiddle(l, middle)
  end

  def totalDistancePart2(l, middle) do
    Enum.map(l, fn(x) -> abs(x - middle)*(abs(x - middle)+1)/2 end)
    |> Enum.sum
    |> trunc
  end
  def solve2(input) do
    l = input
    Enum.to_list(0..2000)
      |> Enum.map(fn(x) -> totalDistancePart2(l, x) end)
      |> Enum.min
  end
end

IO.inspect(Day7.solve(sorted))
IO.inspect(Day7.solve2(sorted))
