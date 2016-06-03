defmodule Experimental.Enum do
  @type t :: Enumerable.t
  @type element :: any
  @type default :: any

  @doc """
  Finds the element at the given `index` (zero-based).

  Returns `default` if `index` is out of bounds.

  A negative `index` can be passed, which means the `enumerable` is
  enumerated once and the `index` is counted from the end (e.g.
  `-1` finds the last element).

  Note this operation takes linear time. In order to access
  the element at index `index`, it will need to traverse `index`
  previous elements.

  ## Examples

      iex> Experimental.Enum.at([2, 4, 6], 0)
      2

      iex> Experimental.at([2, 4, 6], 2)
      6

      iex> Experimental.Enum.at([2, 4, 6], 4)
      nil

      iex> Experimental.Enum.at([2, 4, 6], 4, :none)
      :none

  """
  @spec at(t, integer, default) :: element | default
  def at(enumerable, index, default \\ nil)
  def at(_.._ = range, index, default),
    do: Experimental.Range.at(range, index, default)
  def at(enumerable, index, default) do
    case Enum.fetch(enumerable, index) do
      {:ok, h} -> h
      :error   -> default
    end
  end

  @doc """
  Returns a random element of an enumerable.

  Raises `Enum.EmptyError` if `enumerable` is empty.

  This function uses Erlang's `:rand` module to calculate
  the random value. Check its documentation for setting a
  different random algorithm or a different seed.

  The implementation is based on the
  [reservoir sampling](https://en.wikipedia.org/wiki/Reservoir_sampling#Relation_to_Fisher-Yates_shuffle)
  algorithm.
  It assumes that the sample being returned can fit into memory;
  the input `enumerable` doesn't have to, as it is traversed just once.

  ## Examples

      # Although not necessary, let's seed the random algorithm
      iex> :rand.seed(:exsplus, {1, 2, 3})
      iex> Enum.random([1, 2, 3])
      2
      iex> Enum.random([1, 2, 3])
      1

  """
  @spec random(t) :: element | no_return
  def random(enumerable) do
    case Enum.count(enumerable) do
      0 ->
        raise Enum.EmptyError
      count ->
        Enum.at(enumerable, Experimental.Integer.random(count - 1))
    end
  end

  @doc """
  """
  @spec random(t, non_neg_integer) :: list | no_return
  def random(enumerable, count)
  def random(_enumerable, 0),
    do: []
  def random(_.._ = range, count) when is_integer(count) and count > 0,
    do: Experimental.Range.random(range, count)

  def random(enumerable, 1),
    do: Enum.at(enumerable, Experimental.Integer.random(Enum.count(enumerable) - 1))

  def random(enumerable, count) when is_integer(count) and count > 1,
    do: do_random(enumerable, count, [])

  defp do_random(_, 0, acc),
    do: acc
  # REVIEW: I think this could be optimized.
  # We can create a temporary map with all the randomly generated indexes,
  # and access them as needed.
  # currently this code becomes slow when count > 100_000
  defp do_random(enumerable, count, acc) when count > 0 do
    random_index = Enum.count(enumerable) - 1 |> Experimental.Integer.random
    do_random(enumerable, count - 1, [Enum.at(enumerable, random_index) | acc])
  end

  # TODO Once this PR is implemented.
  # Optimize take_random when dealing with count=1, just call `Enum.random/1`
end
