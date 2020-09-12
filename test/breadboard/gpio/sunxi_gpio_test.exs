defmodule SunxiGpioTest do
  use ExUnit.Case

  alias Breadboard.GPIO.SunxiGPIO

  test "Obtain the correct number from label for Allwinner specific chip" do
    assert SunxiGPIO.label_to_pin("PA1") == 1
    assert SunxiGPIO.label_to_pin("PG8") == 200
    assert SunxiGPIO.label_to_pin(:pa1) == 1
    assert SunxiGPIO.label_to_pin(:pg8) == 200
    assert SunxiGPIO.label_to_pin(32) == 200
    # PA1
    assert SunxiGPIO.label_to_pin(11) == 1
    # PA3
    assert SunxiGPIO.label_to_pin(15) == 3
    # PD14
    assert SunxiGPIO.label_to_pin(12) == 110
    # PG7
    assert SunxiGPIO.label_to_pin(40) == 199
    # PC7
    assert SunxiGPIO.label_to_pin(18) == 71
  end

  test "Obtain correct label from pin number for Allwinner specific chip" do
    assert SunxiGPIO.pin_to_label(:pin11) == :pa1
    assert SunxiGPIO.pin_to_label(:pin32) == :pg8
    assert SunxiGPIO.pin_to_label(:pin8) == :pa13
    assert SunxiGPIO.pin_to_label(:pin18) == :pc7
    assert SunxiGPIO.pin_to_label(:pin3) == :pa12
    assert SunxiGPIO.pin_to_label(:pin12) == :pd14
    assert SunxiGPIO.pin_to_label(:pin18) == :pc7
    assert SunxiGPIO.pin_to_label(:pin38) == :pg6
    assert SunxiGPIO.pin_to_label(:pin37) == :pa20
    assert SunxiGPIO.pin_to_label(:pin7) == :pa6
  end
end

# SPDX-License-Identifier: Apache-2.0
