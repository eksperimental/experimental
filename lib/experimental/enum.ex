defmodule Experimental.Enum do
  @type t :: Enumerable.t
  @type element :: any

  # @spec random(t) :: element | no_return
  # def random(enumerable) do
  #   case Enum.take_random(enumerable, 1) do
  #     [] -> raise Enum.EmptyError
  #     [e] -> e
  #   end
  # end

  @spec random(t, non_neg_integer) :: list | no_return
  def random(_enumerable, 0),
    do: []
  def random(_.._ = range, 1),
    do: [Experimental.Range.random(range)]
  def random(_.._ = range, count) when is_integer(count) and count > 1,
    do: do_random(range, count, [])

  def random(enumerable, count) do
    case Enum.take_random(enumerable, count) do
      [] -> raise Enum.EmptyError
      [e] -> e
    end
  end

  defp do_random(_.._, 0, acc),
    do: acc
  defp do_random(_.._ = range, count, acc) when count > 0,
    do: do_random(range, count - 1, [Experimental.Range.random(range) | acc])
end
