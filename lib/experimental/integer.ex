defmodule Experimental.Integer do
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
  Returns a random integer of a certain `size`.

  It is a very efficient function for generating exceptionally large integers,
  for example a random integer of 100,000 digits: `Integer.pad_random(100_000)`.

  Options:
  - force_size: true | false
  - return: :integer | :positive | :negative | :zero_or_positive | :zero_or_negative

  Defaults options are `force_size: true`, `return: :zero_or_positive.

  ## Examples

      # only positive integers
      Integer.pad_random(20)
      #=> 57901764671769822086

      # only negatives integers
      Integer.pad_random(20, return: :negative)
      #=> -92185616901087310291

      # negative or positive integers
      Integer.pad_random(20, return: :integer)
      #=> 48888679633798389284
      Integer.pad_random(20, return: :integer)
      #=> -80504687761381076044

      # force size is false (digits will range from 0 to 99999)
      Integer.pad_random(5, force_size: false)
      #=> 22

      # force size (digits will range from 10000 to 99999)
      Integer.pad_random(5, force_size: true)
      #=> 10347

  """
  @spec pad_random(pos_integer, list) :: integer
  def pad_random(size, opts \\ []) when is_integer(size) and size > 0 and is_list(opts) do
    force_size? = Keyword.get(opts, :force_size, false)
    return = Keyword.get(opts, :return, :zero_or_positive)

    first_digit =
      if (force_size? and size > 1) or (return in [:positive, :negative]) do
        :rand.uniform(9)
      else
        :rand.uniform(10) - 1
      end

    bare_random = do_pad_random(size - 1, [], first_digit)

    case return do
      :integer ->
        case :rand.uniform(2) do
          1 -> bare_random
          2 -> -(bare_random)
        end

      x when x in [:zero_or_positive, :positive] ->
        bare_random

      x when x in [:negative, :zero_or_negative] ->
        -(bare_random)

      _ ->
        # raise ArgumentError, "#{__MODULE__}.pad_random/2 expects known :return value, got: #{inspect return}"
        raise ArgumentError, "unknown :return value, got: #{inspect return}"
    end
  end

  defp do_pad_random(0, acc, first_digit),
    do: [first_digit | acc] |> Enum.join |> String.to_integer
  defp do_pad_random(size, acc, first_digit) when size > 0,
    do: do_pad_random(size - 1, [:rand.uniform(10) - 1 | acc], first_digit)
end
