defmodule Breadboard.GPIO.PinoutHelp do

  def label_to_pin(:stub, mode, label), do: Breadboard.GPIO.StubHalGPIO.label_to_pin(label, mode)
  def label_to_pin(:sunxi, mode, label), do: Breadboard.GPIO.SunxiGPIO.label_to_pin(label, mode)

  def pin_to_label(:stub, pin), do: Breadboard.GPIO.StubHalGPIO.pin_to_label(pin)
  def pin_to_label(:sunxi, pin), do: Breadboard.GPIO.SunxiGPIO.pin_to_label(pin)

end
