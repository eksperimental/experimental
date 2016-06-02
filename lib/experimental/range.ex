defmodule Experimental.Range do
  @doc """
  Returns a random integer within `range`.

  """
  def random(range)
  def random(first..first) when is_integer(first),
    do: first
  def random(first..last = range) when is_integer(first) and is_integer(last) do
    # we could replace this with Integer.random/1 once implemented in Elixir
    delta = first - last
    random_delta = :random.uniform( + 1) - 1

    if last > first do
      first + random_delta
    else
      first - random_delta
    end
  end


  @doc """
  Returns a list of random integer within `range` `length` items.

  """
  def random(range, length)
  def random(_.._, 0),
    do: []
  def random(first..first, length) when is_integer(first) and is_integer(length),
    do: Stream.cycle([first]) |> Enum.take(length)

  # def random(first..last = range, length) when is_integer(first) and is_integer(last) do
  #   # we could replace this with Integer.random/1 once implemented in Elixir
  #   random_delta = :random.uniform(delta(range) + 1) - 1

  #   if last > first do
  #     first + random_delta
  #   else
  #     first - random_delta
  #   end
  # end
end
