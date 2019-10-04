defmodule Breadboard.GPIO.PinoutCmd do
  @moduledoc false

  @platform_pinout %{
    stub: Breadboard.GPIO.StubHalGPIO,
    sunxi: Breadboard.GPIO.SunxiGPIO
  }

  def label_to_pin(platform, mode, label) do
    apply(@platform_pinout[platform], :label_to_pin, [label, mode])
  end

  def pin_to_label(platform, pin) do
    apply(@platform_pinout[platform], :pin_to_label, [pin])
  end

end
