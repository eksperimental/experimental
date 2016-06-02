defmodule Experimental.Range do
  @type t :: Range.t

  @doc """
  Returns the absolute difference between the `range` limits.

  ## Examples

      iex> Experimental.Range.delta(1..5)
      4

      iex> Experimental.Range.delta(1..-5)
      6

      iex> Experimental.Range.delta(-10..-15)
      5

  """
  @spec delta(t) :: integer
  def delta(range)
  def delta(first..first) when is_integer(first),
    do: 0
  def delta(first..last) when is_integer(first) and is_integer(last) and first < last,
    do: abs(last - first)
  def delta(first..last) when is_integer(first) and is_integer(last),
    do: abs(first - last)

  @doc """
  Returns a random integer within `range`.

  """
  def random(range)
  def random(first..first) when is_integer(first),
    do: first
  def random(first..last = range) when is_integer(first) and is_integer(last) do
    # we could replace this with Integer.random/1 once implemented in Elixir
    random_delta = :random.uniform(delta(range) + 1) - 1

    if last > first do
      first + random_delta
    else
      first - random_delta
    end
  end

  @doc """
  Returns a list of `count` random integers within `range`.

  """
  def random(range, count)
  def random(_.._, 0),
    do: []
  def random(first..first, count) when is_integer(first) and is_integer(count),
    do: Stream.cycle([first]) |> Enum.take(count)
  def random(first..last = range, count) when is_integer(first) and is_integer(last),
    do: do_random(range, count, [])

  defp do_random(_.._, 0, acc),
    do: acc
  defp do_random(_.._ = range, count, acc) when count > 0,
    do: do_random(range, count - 1, [random(range) | acc])
end
