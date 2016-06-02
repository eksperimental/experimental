defmodule Experimental.EnumTest do
  require Logger

  use ExUnit.Case, async: true
  # doctest Experimental.Kernel.IsKind, import: true

  test "range" do
    range = 1_000_000..-1_000_000
    assert 10 == range |> Experimental.Enum.random(10) |> length
    assert 1 == range |> Experimental.Enum.random(1) |> length
    assert 0 == range |> Experimental.Enum.random(0) |> length

    assert_raise FunctionClauseError, fn ->
      Experimental.Enum.random(range, -1)
    end
  end
end
