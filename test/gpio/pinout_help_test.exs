defmodule PinoutHelpTest do
  use ExUnit.Case

  alias Breadboard.GPIO.PinoutHelp

  test "Obtain the correct pin number from label" do
    assert PinoutHelp.label_to_pin(:stub, :sysfs, "GPIO1") == 1
    assert PinoutHelp.label_to_pin(:stub, :sysfs, :gpio18) == 18
    assert PinoutHelp.label_to_pin(:stub, :sysfs, :pin1) == 1
    assert PinoutHelp.label_to_pin(:stub, :sysfs, 18) == 18
    assert PinoutHelp.label_to_pin(:sunxi, :sysfs, "PA1") == 1
    assert PinoutHelp.label_to_pin(:sunxi, :sysfs, :pa1) == 1
    assert PinoutHelp.label_to_pin(:sunxi, :sysfs, 11) == 1   #PA1
  end

  test "Obtain correct label from pin number" do
    assert PinoutHelp.pin_to_label(:stub, :pin1) == :gpio1
    assert PinoutHelp.pin_to_label(:stub, 1) == :gpio1
    assert PinoutHelp.pin_to_label(:sunxi, :pin11) == :pa1
    assert PinoutHelp.pin_to_label(:sunxi, :pin3) == :pa12
    assert PinoutHelp.pin_to_label(:sunxi, :pin38) == :pg6
  end

end
