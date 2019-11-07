defmodule BreadboardTest do
  use ExUnit.Case
  doctest Breadboard

  test "Get platform" do
    assert Breadboard.get_platform() != nil
    assert Breadboard.get_platform() != ""
  end

end

# SPDX-License-Identifier: Apache-2.0
