defmodule PinoutHelperTest do
  use ExUnit.Case

  alias Breadboard.GPIO.PinoutHelper

  test "Pin to key" do
    assert PinoutHelper.to_pin_key("PRE", 12) == :pre12
    assert PinoutHelper.to_pin_key("GPIO", 18) == :gpio18
  end

  test "To key label" do
    assert PinoutHelper.to_label_key("GPIO12") == :gpio12
    assert PinoutHelper.to_label_key(:gpio12) == :gpio12
  end

  test "To pin name" do
    assert PinoutHelper.to_pin_name("GPIO", 12) == "GPIO12"
    assert PinoutHelper.to_pin_name("PIN", 18) == "PIN18"
    assert PinoutHelper.to_pin_name("gpio", 12) == "gpio12"
  end

  test "expand map with value" do
    pinout_info = [
      [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
      [pin: 32, sysfs: 32, pin_key: :pin32, pin_label: :gpio32, pin_name: "GPIO32"]
    ]
    pinout_map =  %{
     {:pin, 1}            => [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:sysfs, 1}          => [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:pin_key, :pin1}    => [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:pin_label, :gpio1} => [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:pin_name, "GPIO1"} => [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:pin, 32}           => [pin: 32, sysfs: 32, pin_key: :pin32, pin_label: :gpio32, pin_name: "GPIO32"],
     {:sysfs, 32}         => [pin: 32, sysfs: 32, pin_key: :pin32, pin_label: :gpio32, pin_name: "GPIO32"],
     {:pin_key, :pin32}   => [pin: 32, sysfs: 32, pin_key: :pin32, pin_label: :gpio32, pin_name: "GPIO32"],
     {:pin_label, :gpio32}=> [pin: 32, sysfs: 32, pin_key: :pin32, pin_label: :gpio32, pin_name: "GPIO32"],
     {:pin_name, "GPIO32"}=> [pin: 32, sysfs: 32, pin_key: :pin32, pin_label: :gpio32, pin_name: "GPIO32"]
    }

    assert Map.equal?(pinout_map, PinoutHelper.expand_map_with_value(pinout_info)) == true
  end

end

# SPDX-License-Identifier: Apache-2.0
