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

  @moduledoc false

  @pinout_map Breadboard.GPIO.StubHalGPIOPinDefiner.pin_definition()

  use Breadboard.GPIO.BaseGPIO

  def pinout_map(), do: @pinout_map

end
