defmodule StubHalGPIOTest do
  use ExUnit.Case

  alias Breadboard.GPIO.StubHalGPIO

  test "Obtain the correct pin number from label for abstract chip" do
    assert StubHalGPIO.label_to_pin("GPIO0") == 0
    assert StubHalGPIO.label_to_pin("GPIO1") == 1
    assert StubHalGPIO.label_to_pin("GPIO18") == 18
    assert StubHalGPIO.label_to_pin(:gpio1) == 1
    assert StubHalGPIO.label_to_pin(:gpio18) == 18
    assert StubHalGPIO.label_to_pin(:pin1) == 1
    assert StubHalGPIO.label_to_pin(:pin18) == 18
    assert StubHalGPIO.label_to_pin(1) == 1
    assert StubHalGPIO.label_to_pin(18) == 18
    assert StubHalGPIO.label_to_pin(40) == 40
    assert StubHalGPIO.label_to_pin(63) == 63
  end

  test "Obtain correct label from pin number for abstract chips" do
    assert StubHalGPIO.pin_to_label(:pin0) == :gpio0
    assert StubHalGPIO.pin_to_label(:pin1) == :gpio1
    assert StubHalGPIO.pin_to_label(:pin18) == :gpio18
    assert StubHalGPIO.pin_to_label(1) == :gpio1
    assert StubHalGPIO.pin_to_label(18) == :gpio18
    assert StubHalGPIO.pin_to_label(40) == :gpio40
    assert StubHalGPIO.pin_to_label(63) == :gpio63
  end
end

# SPDX-License-Identifier: Apache-2.0
