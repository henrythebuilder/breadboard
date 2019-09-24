defmodule BreadboardTest do
  use ExUnit.Case
  doctest Breadboard

  test "greets the world" do
    assert Breadboard.hello() == :world
  end
end
