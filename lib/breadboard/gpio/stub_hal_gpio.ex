defmodule Breadboard.GPIO.StubHalGPIOPin do

  @moduledoc false

  # pin item info:
  # [sysfs: 3, pin_key: :pin3, pin_label: :gpio3, pin_name: "GPIO3", pin: 3]

  use Breadboard.GPIO.BaseGPIOHelper

  # %{
  #   0 => [pin_name: "GPIO0"],
  #   1 => [pin_name: "GPIO1"],
  #   2 => [pin_name: "GPIO2"],
  #   ...
  #   63 => [pin_name: "GPIO63"]
  #  }
  def pinout_definition() do
    (0..63)
    |> Enum.reduce(%{}, fn (n, map) ->
      Map.put(map, n, [pin_name: "GPIO#{n}"])
    end)
  end

  def pin_to_sysfs_pin(pin_number, _info) do
    pin_number
  end

end


defmodule Breadboard.GPIO.StubHalGPIO do

  @moduledoc """
  Manage the pinout of gpio in "stub" hardware abstraction layer for platforms without GPIO support.

  Handle the GPIOs as defined in `Circuits.GPIO`.

  There are 64 GPIOs where:

  * pin 0 is GPIO0, pin 1 is GPIO1, pin 2 is GPIO2 ...
  * sysfs pin number is mapped to the same pin number

  and the complete pinout map is in the form:

  ```
  %{
     {:pin, 0}            => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:sysfs, 0}          => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:pin_key, :pin0}    => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:pin_label, :gpio0} => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:pin_name, "GPIO0"} => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
      ...
     {:pin, 31}           => [pin: 31, sysfs: 31, pin_key: :pin31, pin_label: :gpio31, pin_name: "GPIO31"],
     {...}                => ...
      ...
     {:pin, 63}           => [pin: 63, sysfs: 63, pin_key: :pin63, pin_label: :gpio63, pin_name: "GPIO63"],
     {...}                => ...
  }
  ```
  """


  @pinout_map Breadboard.GPIO.StubHalGPIOPin.build_pinout_map()

  use Breadboard.GPIO.BaseGPIO

  def pinout_map(), do: @pinout_map

end
