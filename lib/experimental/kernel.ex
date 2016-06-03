defmodule Experimental.Kernel do
  @doc """
  Returns the absolute difference between two numbers.

  It will return 0 or a positive number.

  ## Examples

      iex> delta(1, 5)
      4

      iex> delta(1, -5.0)
      6.0

      iex> delta(-10.5, -15.0)
      4.5

  """
  @spec delta(number, number) :: non_neg_integer | float
  def delta(number1, number2)
  def delta(a, b) when is_number(a) and is_number(b) and a < b,
    do: abs(b - a)
  def delta(a, b) when is_number(a) and is_number(b),
    do: abs(a - b)
end
