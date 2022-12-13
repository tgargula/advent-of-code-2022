defmodule Solve do
  def read_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.filter(fn line -> line !== "" end)
    |> Stream.map(&Poison.decode!/1)
  end

  def detach_heads({left, right}) do
    [left, right]
    |> Enum.map(fn list -> {List.first(list), List.delete_at(list, 0)} end)
    |> List.to_tuple()
  end

  def tuples_length({left, right}) do
    [left, right]
    |> Enum.map(&Enum.count/1)
    |> List.to_tuple()
  end

  def compare({left, right}) when is_nil(left) and is_nil(right) do
    0
  end

  def compare({_, right}) when is_nil(right) do
    -1
  end

  def compare({left, _}) when is_nil(left) do
    1
  end

  def compare({left, right}) when is_integer(left) and is_integer(right) do
    right - left
  end

  def compare({left, right}) when is_list(left) and is_integer(right) do
    Solve.compare({left, [right]})
  end

  def compare({left, right}) when is_integer(left) and is_list(right) do
    Solve.compare({[left], right})
  end

  def compare({left, right}) when is_list(left) and is_list(right) do
    {{hleft, tleft}, {hright, tright}} =
      {left, right}
      |> Solve.detach_heads()

    {hleft, hright}
    |> Solve.compare()
    |> Solve.manage_comparator({tleft, tright})
  end

  def manage_comparator(compare_result, tails) do
    case compare_result do
      0 ->
        case Solve.tuples_length(tails) do
          {0, 0} -> 0
          _ -> Solve.compare(tails)
        end

      _ ->
        compare_result
    end
  end

  def apply_index(result, index) do
    cond do
      result > 0 -> index
      true -> 0
    end
  end

  def check_pair({{left, right}, index}) do
    {left, right}
    |> Solve.compare()
    |> apply_index(index)
  end

  def add_markers(lines) do
    [[[6]] | [[[2]] | lines]]
  end

  def get_decoder_key(lines) do
    a = lines |> Enum.find_index(&(&1 == [[2]]))
    b = lines |> Enum.find_index(&(&1 == [[6]]))
    (a + 1) * (b + 1)
  end

  def main do
    step = 2
    filename = "data/input.txt"

    case step do
      1 ->
        filename
        |> Solve.read_file()
        |> Enum.chunk_every(2)
        |> Stream.map(&List.to_tuple/1)
        |> Enum.with_index(1)
        |> Stream.map(&Solve.check_pair/1)
        |> Enum.sum()

      2 ->
        filename
        |> Solve.read_file()
        |> Enum.to_list()
        |> Solve.add_markers()
        |> Enum.sort(fn a, b -> compare({a, b}) > 0 end)
        |> Solve.get_decoder_key()
    end
  end
end
