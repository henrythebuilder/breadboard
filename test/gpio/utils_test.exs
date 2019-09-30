defmodule UtilsTest do
  use ExUnit.Case, async: true

  alias Breadboard.GPIO.Utils

  test "Pin to key" do
    assert Utils.to_pin_key("PRE", 12) == :pre12
    assert Utils.to_pin_key("GPIO", 18) == :gpio18
  end

  test "To key label" do
    assert Utils.to_key_label("GPIO12") == :gpio12
    assert Utils.to_key_label(:gpio12) == :gpio12
  end


end
