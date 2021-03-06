defmodule PinoutCmdTest do
  use ExUnit.Case

  alias Breadboard.GPIO.PinoutCmd

  test "Obtain the correct pin number from label" do
    assert PinoutCmd.label_to_pin(:stub, :sysfs, "GPIO1") == 1
    assert PinoutCmd.label_to_pin(:stub, :sysfs, :gpio18) == 18
    assert PinoutCmd.label_to_pin(:stub, :sysfs, :pin1) == 1
    assert PinoutCmd.label_to_pin(:stub, :sysfs, 18) == 18
    assert PinoutCmd.label_to_pin(:sunxi, :sysfs, "PA1") == 1
    assert PinoutCmd.label_to_pin(:sunxi, :sysfs, :pa1) == 1
    # PA1
    assert PinoutCmd.label_to_pin(:sunxi, :sysfs, 11) == 1
  end

  test "Obtain correct label from pin number" do
    assert PinoutCmd.pin_to_label(:stub, :pin1) == :gpio1
    assert PinoutCmd.pin_to_label(:stub, 1) == :gpio1
    assert PinoutCmd.pin_to_label(:sunxi, :pin11) == :pa1
    assert PinoutCmd.pin_to_label(:sunxi, :pin3) == :pa12
    assert PinoutCmd.pin_to_label(:sunxi, :pin38) == :pg6
  end
end

# SPDX-License-Identifier: Apache-2.0
