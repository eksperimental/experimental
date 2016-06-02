defmodule Experimental.RangeTest do
  require Logger

  use ExUnit.Case, async: true
  doctest Experimental.Range, import: true


  test "Range.random/1" do
    range = 1_000_000_345_670..1_000_000_345_679
    assert Experimental.Range.random(range) in range
    assert Experimental.Range.random(range) in range
    assert Experimental.Range.random(range) in range

    assert_raise FunctionClauseError, fn ->
      Experimental.Range.random(range, -1)
    end
  end

  test "Range.random/2" do
    range = 1_000_000..-1_000_000
    assert 10 == range |> Experimental.Range.random(10) |> length
    assert 1 == range |> Experimental.Range.random(1) |> length
    assert 0 == range |> Experimental.Range.random(0) |> length

    assert_raise FunctionClauseError, fn ->
      Experimental.Range.random(range, -1)
    end
  end
end
