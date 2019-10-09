defmodule Breadboard.GPIO.SunxiPin do

  @moduledoc false

  use Breadboard.GPIO.BaseGPIOHelper

  #  [sysfs: 12, pin_key: :pin3, pin_label: :pa12, pin_name: "PA12", pin: 3]
  @pinout_map %{
    3 => [pin_name: "PA12", mux2_label: "TWIO_SDA"],
    5 => [pin_name: "PA11"],
    7 => [pin_name: "PA6"],
    8 => [pin_name: "PA13"],
    10 => [pin_name: "PA14"],
    11 => [pin_name: "PA1"],
    12 => [pin_name: "PD14"],
    13 => [pin_name: "PA0"],
    15 => [pin_name: "PA3"],
    16 => [pin_name: "PC4"],
    18 => [pin_name: "PC7"],
    19 => [pin_name: "PC0"],
    21 => [pin_name: "PC1"],
    22 => [pin_name: "PA2"],
    23 => [pin_name: "PC2"],
    24 => [pin_name: "PC3"],
    26 => [pin_name: "PA21"],
    28 => [pin_name: "PA18"],
    29 => [pin_name: "PA7"],
    31 => [pin_name: "PA8"],
    32 => [pin_name: "PG8"],
    33 => [pin_name: "PA9"],
    35 => [pin_name: "PA10"],
    36 => [pin_name: "PG9"],
    37 => [pin_name: "PA20"],
    38 => [pin_name: "PG6"],
    40 => [pin_name: "PG7"],
  }

  def pinout_definition(), do: @pinout_map

  def pin_to_sysfs_pin(_pin_number, info) do
    label_to_sysfs_pin(info[:pin_name])
  end

  # https://linux-sunxi.org/GPIO
  # To obtain the correct number you have to calculate it from the pin name (like PH18):
  # (position of letter in alphabet - 1) * 32 + pin number
  # E.g for PH18 this would be ( 8 - 1) * 32 + 18 = 224 + 18 = 242 (since 'h' is the 8th letter).
  defp label_to_sysfs_pin(_label=<<"P", base::utf8, num::binary>>) do
    (base - ?A) * 32 + String.to_integer(num)
  end

end


defmodule Breadboard.GPIO.SunxiGPIO do

  @moduledoc """
  Manage the pinout of GPIOs in **sunxi** hardware layer for platforms **ARM SoCs family from Allwinner Technology**.

  For this platform there isn't a simple mapping (ono to one) as explained in the [linux-sunxi community](https://linux-sunxi.org/GPIO#Accessing_the_GPIO_pins_through_sysfs_with_mainline_kernel), for example the pin number 3 (`PA12`) is classified as:

  ```
  [pin: 3, sysfs: 12, pin_key: :pin3, pin_label: :pa12, pin_name: "PA12"]
  ```

  so the complete pinout map is in the form:

  ```
  %{
    {:pin, 3}           => [pin: 3, sysfs: 12, pin_key: :pin3, pin_label: :pa12, pin_name: "PA12"],
    {:sysfs, 3}         => [pin: 3, sysfs: 12, pin_key: :pin3, pin_label: :pa12, pin_name: "PA12"],
    {:pin_key, :pin3}   => [pin: 3, sysfs: 12, pin_key: :pin3, pin_label: :pa12, pin_name: "PA12"],
    {:pin_label, :pa12} => [pin: 3, sysfs: 12, pin_key: :pin3, pin_label: :pa12, pin_name: "PA12"],
    {:pin_name, "PA12"} => [pin: 3, sysfs: 12, pin_key: :pin3, pin_label: :pa12, pin_name: "PA12"],
    ...
    {:pin, 32}          => [pin: 32, sysfs: 200, pin_key: :pin32, pin_label: :pg8, pin_name: "PG8"],
    {...}               => ...
    ...
    {:pin, 40}          => [pin: 40, sysfs: 199, pin_key: :pin40, pin_label: :pg7, pin_name: "PG7"],
    {...}               => ...
  }
  ```
  """


  @pinout_map Breadboard.GPIO.SunxiPin.build_pinout_map()

  use Breadboard.GPIO.BaseGPIO

  def pinout_map(), do: @pinout_map

end
