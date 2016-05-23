defmodule Experimental.IntegerRandom do

  @doc """
  Returns a random integer between 0 and `limit`.

  ## Examples

      Integer.random(10)
      #=> 7

      Integer.random(10)
      #=> 0

      Integer.random(-10)
      #=> -3

      iex> Integer.random(0)
      0

  """
  @spec random(integer) :: integer
  def random(limit) do
    random(0, limit)
  end

  @doc """
  Returns a random integer with the limits.

  ## Examples

      Integer.random(2, 16)
      #=> 7

      Integer.random(0, 1)
      #=> 0

      Integer.random(-10, 10)
      #=> -9

      Integer.random(10, -10)
      #=> -5

      iex> Integer.random(42, 42)
      42

  """
  @spec random(integer, integer) :: integer
  def random(lower_limit, upper_limit)
  def random(limit, limit) when is_integer(limit),
    do: limit
  def random(lower_limit, upper_limit) when is_integer(lower_limit) and is_integer(upper_limit) do
    do_random(lower_limit, upper_limit)
  end

  def do_random(lower_limit, upper_limit) when upper_limit > lower_limit,
    do: lower_limit + :random.uniform(upper_limit - lower_limit + 1) - 1
  def do_random(lower_limit, upper_limit),
    do: do_random(upper_limit, lower_limit)

  @doc """
  Returns a random integer of a certain `length`.

  It is a very efficient function for generating exceptionally large integers,
  for example a random integer of 100,000 digits: `Integer.random_digits(100_000)`.

  Options:
  - positive: boolean
  - negative: boolean
  - force_length: boolean

  If no options are given, only positive numbers will be returned.
  `:force_length` is set to `false` by default.

  ## Examples

      # only positive integers
      Integer.random_digits(20)
      #=> 57901764671769822086

      # only negatives integers
      Integer.random_digits(20, negative: true)
      #=> -92185616901087310291

      # negative or positive integers
      Integer.random_digits(20, positive: true, negative: true)
      #=> 48888679633798389284
      Integer.random_digits(20, positive: true, negative: true)
      #=> -80504687761381076044

      # force length is false (digits will range from 0 to 99999)
      Integer.random_digits(5, force_length: false)
      #=> 22

      # force length (digits will range from 10000 to 99999)
      Integer.random_digits(5, force_length: true)
      #=> 10347

  """
  @spec random_digits(pos_integer, list) :: integer
  def random_digits(length, opts \\ []) when is_integer(length) and length > 0 and is_list(opts) do
    force_length? = Keyword.get(opts, :force_length, false)

    pos = Keyword.get(opts, :positive)
    neg = Keyword.get(opts, :negative)
    {positive?, negative?} =
      cond do
        is_nil(pos) and is_nil(neg) ->
          {true, false}
        is_nil(neg) ->
          {pos, false}
        :otherwise ->
          {pos, neg}
      end

    random =
      if force_length? do
        do_random_digits(length - 1, [], :rand.uniform(9))
      else
        do_random_digits(length, [], 0)
      end

    cond do
      negative? and positive? ->
        case :rand.uniform(2) do
          1 -> random
          2 -> -(random)
        end

      positive? ->
        random

      negative? ->
        -(random)

      :otherwise ->
        raise ArgumentError, "at least option :positive or :negative must be set to true"
    end
  end

  defp do_random_digits(0, acc, first_digit) do
    [first_digit | acc] |> Enum.join |> String.to_integer
  end

  defp do_random_digits(length, acc, first_digit) when length > 0,
    do: do_random_digits(length - 1, [:rand.uniform(10) - 1 | acc], first_digit)
end
