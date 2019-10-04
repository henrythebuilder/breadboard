defmodule Breadboard.GPIO.StubHalGPIOPinDefiner do

  @moduledoc false

  # from: 3
  # to:   [sysfs: 3, pin_key: :pin3, pin_label: :gpio3, pin_name: "GPIO3", pin: 3]
  def pin_definition() do
    (0..63) |> Enum.reduce([], &update_pin/2)
  end

  defp update_pin(n, pins) do
    pin = Breadboard.GPIO.Utils.to_pin_key("pin", n)
    gpio = Breadboard.GPIO.Utils.to_pin_key("gpio", n)
    pin_info = [sysfs: n]
    |> Keyword.merge([pin_key: pin])
    |> Keyword.merge([pin: n])
    |> Keyword.merge([pin_label: gpio])
    |> Keyword.merge([pin_name: "GPIO#{n}"])
    [pin_info | pins]
  end
end


defmodule Breadboard.GPIO.StubHalGPIO do

  @moduledoc """
  Manage the pinout of gpio in "stub" hardware abstraction layer for platforms without GPIO support.
  Handle GPIOs as supported in `Circuits.GPIO`

  There are 64 GPIOs where:

  * pin 1 is GPIO1, pin 2 is GPIO2 ...
  * sysfs is mapped to the same pin number

  so the complete pinout map is in the form:

  ```
  [
    [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
    ...
    [pin: 32, sysfs: 32, pin_key: :pin32, pin_label: :gpio32, pin_name: "GPIO32"],
    ...
    [pin: 64, sysfs: 64, pin_key: :pin64, pin_label: :gpio64, pin_name: "GPIO64"]
  ]
  ```
  """


  @pinout_map Breadboard.GPIO.StubHalGPIOPinDefiner.pin_definition()

  use Breadboard.GPIO.BaseGPIO

  def pinout_map(), do: @pinout_map

end
