defmodule Experimental.Range do
  @type t :: Range.t

  @doc """
  Returns the integer found at the given `index` (zero-based).

  Returns `default` if `index` is out of bounds.

  A negative `index` can be passed, which means the `range` is counted from the end (e.g.
  `-1` finds the last element).

  """
  @spec at(t, integer, any) :: integer | any
  def at(range, index, default \\ nil)
  def at(first..first, index, _default) when index in [0, -1],
    do: first
  def at(first..first, index, default) when is_integer(index),
    do: default
  def at(first..last = range, index, default) when first > last,
    do:  at(last..first, Enum.count(range) - index, default)

  def at(first.._last = range, index, default) when is_integer(index) and index < 0 do
    case Enum.count(range) + index do
      i when i < 0 ->
        default
      i ->
        first + i
    end
  end

  def at(first..last, index, default) when is_integer(index) do
    case first + index do
      result when result > last ->
        default
      result ->
        result
    end
  end

  @doc """
  Returns the absolute difference between the `range` limits.

  It will return 0 or a positive integer.

  ## Examples

      iex> Experimental.Range.delta(1..5)
      4

      iex> Experimental.Range.delta(5..5)
      0

      iex> Experimental.Range.delta(1..-5)
      6

      iex> Experimental.Range.delta(-10..-15)
      5

  """
  @spec delta(t) :: non_neg_integer
  def delta(range)
  def delta(first..first) when is_integer(first),
    do: 0
  def delta(first..last) when is_integer(first) and is_integer(last),
    do: Experimental.Kernel.delta(first, last)

  @doc """
  Returns a random integer within `range`.

  """
  def random(range)
  def random(first..first) when is_integer(first),
    do: first
  def random(first..last = range) when is_integer(first) and is_integer(last) and last > first,
    do: first + (range |> Experimental.Range.delta |> Experimental.Integer.random)
  def random(first..last = range) when is_integer(first) and is_integer(last),
    do: first - (range |> Experimental.Range.delta |> Experimental.Integer.random)

  @doc """
  Returns a list of `count` random integers within `range`.

  It's worth noting that integers may be repeated. If you want unique integers,
  please use `Enum.take_random/2`.

  """
  def random(range, count)
  def random(_.._, 0),
    do: []
  def random(first..first, 1) when is_integer(first),
    do: [first]
  def random(first..first, count) when is_integer(first) and is_integer(count) and count > 1,
    do: Stream.cycle([first]) |> Enum.take(count)
  def random(first..last = range, count) when is_integer(first) and is_integer(last) and count > 0,
    do: do_random(range, count, [])

  defp do_random(_.._, 0, acc),
    do: acc
  defp do_random(_.._ = range, count, acc) when count > 0,
    do: do_random(range, count - 1, [random(range) | acc])
end
