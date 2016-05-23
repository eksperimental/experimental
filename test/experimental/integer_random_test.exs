Code.require_file "../test_helper.exs", __DIR__

defmodule Experimental.IntegerRandomTest do
  use ExUnit.Case, async: true
  require Experimental.IntegerRandom, as: Integer
  doctest Experimental.IntegerRandom

  test "random" do
    assert Integer.random(0) === 0
    assert Integer.random(1) in [0, 1]

    sum =
      for _ <- 1..100 do
        Integer.random(1)
      end |> Enum.sum
    assert sum > 0

    assert Integer.random(99) in 0..99
  end


  test "random_digits" do
    for _ <- 1..100 do
      assert Integer.random_digits(2) in 0..99
    end
  end

  test "random_digits :positive :force_length" do
    for _ <- 1..100 do
      assert Integer.random_digits(10, [positive: true, force_length: true]) in 1000000000..9999999999
    end
  end

  test "random_digits :positive" do
    for _ <- 1..100 do
      assert Integer.random_digits(2, [positive: true, negative: true]) in -99..99
    end
  end

  test "random_digits :negative" do
    for _ <- 1..100 do
      assert Integer.random_digits(2, [negative: true]) in -99..0
    end
  end

end
