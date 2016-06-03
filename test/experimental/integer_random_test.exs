Code.require_file "../test_helper.exs", __DIR__

defmodule Experimental.IntegerTest do
  use ExUnit.Case, async: true
  require Experimental.Integer, as: Integer
  doctest Experimental.Integer

  test "random" do
    assert Integer.random(0) === 0
    assert Integer.random(1) in [0, 1]

    sum =
      for _ <- 1..1000 do
        Integer.random(1)
      end |> Enum.sum
    assert sum > 0

    assert Integer.random(99) in 0..99
  end

  test "pad_random errors" do
    assert_raise ArgumentError,
      "unknown :return value, got: :foo",
      fn ->
        Experimental.Integer.pad_random(10, return: :foo)
      end

    assert_raise FunctionClauseError,
      ~R/no function clause matching in/,
      fn ->
        Experimental.Integer.pad_random(0)
      end

    assert_raise FunctionClauseError,
      ~R/no function clause matching in/,
      fn ->
        Experimental.Integer.pad_random(1.2)
      end
  end

  test "pad_random" do
    for _ <- 1..1000 do
      assert Integer.pad_random(2) in 0..99
    end
  end

  test "pad_random return: :integer" do
    for _ <- 1..1000 do
      assert Integer.pad_random(2, [return: :integer]) in -99..99
    end
  end

  test "pad_random return: :zero_or_positive, force_size: true" do
    for _ <- 1..1000 do
      assert Integer.pad_random(10, [return: :zero_or_positive, force_size: true]) in 1000000000..9999999999
    end

    for _ <- 1..1000 do
      assert Integer.pad_random(2, [return: :zero_or_positive, force_size: true]) in 10..99
    end
  end

  test "pad_random return: :zero_or_positive, force_size: false" do
    for _ <- 1..100 do
      assert Integer.pad_random(1, return: :zero_or_positive, force_size: false) in 0..9
    end
  end

  test "pad_random return: :zero_or_negative" do
    for _ <- 1..1000 do
      assert Integer.pad_random(2, [return: :zero_or_negative]) in -99..0
    end
  end

  test "pad_random return: :negative" do
    for _ <- 1..1000 do
      assert Integer.pad_random(2, [return: :negative]) in -99..-1
    end
  end

  test "pad_random return: :positive" do
    for _ <- 1..1000 do
      assert Integer.pad_random(2, [return: :positive]) in 1..99
    end
  end

  test "pad_random size: 1" do
    for _ <- 1..500 do
      assert Integer.pad_random(1, return: :integer) in -9..9
      assert Integer.pad_random(1, return: :integer, force_size: true) in -9..9
    end

    for _ <- 1..500 do
      assert Integer.pad_random(1, return: :positive) in 1..9
      assert Integer.pad_random(1, return: :positive, force_size: true) in 1..9
    end

    for _ <- 1..500 do
      assert Integer.pad_random(1, return: :negative) in -9..-1
      assert Integer.pad_random(1, return: :negative, force_size: true) in -9..-1
    end

    for _ <- 1..500 do
      assert Integer.pad_random(1, return: :zero_or_positive) in 0..9
      assert Integer.pad_random(1, return: :zero_or_positive, force_size: true) in 0..9
    end

    for _ <- 1..500 do
      assert Integer.pad_random(1, return: :zero_or_negative) in -9..0
      assert Integer.pad_random(1, return: :zero_or_negative, force_size: true) in -9..0
    end
  end

  test "pad_random size: 2" do
    for _ <- 1..1000 do
      assert Integer.pad_random(2, return: :integer) in -99..99
      assert Integer.pad_random(2, return: :integer, force_size: true) in (Enum.to_list(-99..-10) ++ Enum.to_list(10..99))
    end

    for _ <- 1..1000 do
      assert Integer.pad_random(2, return: :positive) in 1..99
      assert Integer.pad_random(2, return: :positive, force_size: true) in 10..99
    end

    for _ <- 1..1000 do
      assert Integer.pad_random(2, return: :negative) in -99..-10
      assert Integer.pad_random(2, return: :negative, force_size: true) in -99..-10
    end

    for _ <- 1..1000 do
      assert Integer.pad_random(2, return: :zero_or_positive) in 0..99
      assert Integer.pad_random(2, return: :zero_or_positive, force_size: true) in 0..99
    end

    for _ <- 1..1000 do
      assert Integer.pad_random(2, return: :zero_or_negative) in -99..0
      assert Integer.pad_random(2, return: :zero_or_negative, force_size: true) in -99..0
    end
  end
end
