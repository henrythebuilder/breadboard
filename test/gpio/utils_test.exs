defmodule UtilsTest do
  use ExUnit.Case, async: false

  alias Breadboard.GPIO.Utils

  test "Pin to key" do
    assert Utils.to_pin_key("PRE", 12) == :pre12
    assert Utils.to_pin_key("GPIO", 18) == :gpio18
  end

  test "To key label" do
    assert Utils.to_key_label("GPIO12") == :gpio12
    assert Utils.to_key_label(:gpio12) == :gpio12
  end

  test "build pinout map" do
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

    assert Map.equal?(pinout_map, Utils.pinout_map_definition(pinout_info)) == true
  end

end
