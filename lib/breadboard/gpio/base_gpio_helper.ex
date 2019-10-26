defmodule Breadboard.GPIO.BaseGPIOHelper do

  @moduledoc """
  Define an 'helper' behaviour to define a complete map of GPIOs pinout for a specific platform from a small set of informations.

  Implementing the defined callback the result is obtained from `build_pinout_map/0` funcion, starting for example from:

  ```
  %{
     0 => [pin_name: "GPIO0"],
     1 => [pin_name: "GPIO1"],
     2 => [pin_name: "GPIO2"],
     ...
     63 => [pin_name: "GPIO63"]
    }
  ```

  for any item is build a new extended item in the form:

  ```
  [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"]
  ```


  and finally the complete map for any key:

  ```
  %{
     {:pin, 0}            => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:sysfs, 0}          => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:pin_key, :pin0}    => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:pin_label, :gpio0} => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:pin_name, "GPIO0"} => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
       ...
   }
  ```

  as requested from `Breadboard.GPIO.BaseGPIO` module


  Note:

  for values in the exended item the requested key/value pairs are used if present where:

  * `:pin` value is forced to the original pin number
  * `:pin_name` if missing is build as "GPIO***n***" (n='pin number')
  * `:pin_key` if missing is build as :pin***n*** (n='pin number)
  * `:pin_label` if missing is build from 'pin name' as lowercase atom

  """

  @doc """
  Return the basic pinout definition map for all pins number to build the complete pinout map through `build_pinout_map`

  The keys of the map are the real pin number and the value (keyword list) must contains at least the pin name as key in the form:
  ```
  %{
    1 => [pin_name: "GPIO1"],
    ...
   }
  ```
  """
  @callback pinout_definition() :: map()

  @doc """
  Return the the pin number in user space using sysfs .

  Argument come from the item from `pinout_definition`
  - first argument: pin number
  - second argument: available pin information
  """
  @callback pin_to_sysfs_pin(non_neg_integer(), list()) :: non_neg_integer()

  defmacro __using__(_opts) do
    quote do

      @behaviour Breadboard.GPIO.BaseGPIOHelper

      alias Breadboard.GPIO.PinoutHelper

      def build_pinout_map() do
        pinout_definition()
        |> Enum.reduce([], &update_pin_info/2)
        |> PinoutHelper.expand_map_with_value()
      end

      defp update_pin_info({pin_number, info}, pins) do
        pin_name = Keyword.get(info, :pin_name, PinoutHelper.to_pin_name("GPIO", pin_number))
        pin_info = info
        |> Keyword.put_new(:sysfs, pin_to_sysfs_pin(pin_number, info))
        |> Keyword.put_new(:pin_key, PinoutHelper.to_pin_key("pin", pin_number))
        |> Keyword.put_new(:pin_label, PinoutHelper.to_label_key(pin_name))
        |> Keyword.put_new(:pin_name, pin_name)
        |> Keyword.put(:pin, pin_number) # pin is unique as the original map pin_number
        [pin_info | pins]
      end

    end

  end

end

# SPDX-License-Identifier: Apache-2.0
