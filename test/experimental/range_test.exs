defmodule Experimental.RangeTest do
  require Logger

  use ExUnit.Case, async: true
  doctest Experimental.Range, import: true

  test "at/3" do
    range = 100..109
    assert Experimental.Range.at(range, 0) == 100
    assert Experimental.Range.at(range, -10) == 100
    assert Experimental.Range.at(range, 8) == 108
    assert Experimental.Range.at(range, -2) == 108
    assert Experimental.Range.at(range, 10) == nil
    assert Experimental.Range.at(range, -11) == nil
    assert Experimental.Range.at(range, -11, :foo) == :foo

    # optimizations
    assert Experimental.Range.at(-1000..-1000, 0) == -1000
    assert Experimental.Range.at(-1000..-1000, -1) == -1000
    assert Experimental.Range.at(-1000..-1000, -2, :bar) == :bar
  end

  test "delta/1" do
    assert Experimental.Range.delta(100..100) == 0
    assert Experimental.Range.delta(101..100) == 1
    assert Experimental.Range.delta(100..101) == 1
    assert Experimental.Range.delta(100..-100) == 200
    assert Experimental.Range.delta(-100..100) == 200
    assert Experimental.Range.delta(-666..-555) == 111
    assert Experimental.Range.delta(-555..-666) == 111
  end

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
