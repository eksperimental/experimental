Code.require_file "../test_helper.exs", __DIR__

defmodule Experimental.KernelTest do
  use ExUnit.Case, async: true
  doctest Experimental.Kernel, import: true

  test "delta/1" do
    assert Experimental.Kernel.delta(100, 100) == 0
    assert Experimental.Kernel.delta(100.5, 100) == 0.5
    assert Experimental.Kernel.delta(100, 100.5) == 0.5
    assert Experimental.Kernel.delta(101, 100) == 1
    assert Experimental.Kernel.delta(100, 101) == 1
    assert Experimental.Kernel.delta(100, -100) == 200
    assert Experimental.Kernel.delta(-100, 100) == 200
    assert Experimental.Kernel.delta(-100.123, 100.123) == 200.246
    assert Experimental.Kernel.delta(-666, -555) == 111
    assert Experimental.Kernel.delta(-555, -666) == 111
  end
end
