defmodule BreadboardTest do
  use ExUnit.Case
  doctest Breadboard

  test "Get platform" do
    assert Breadboard.get_platform() != nil
  end

  test "Get GPIO info name" do
    assert Breadboard.gpio_info_name() != nil
  end

end
