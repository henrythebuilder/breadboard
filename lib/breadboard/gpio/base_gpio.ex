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
  * `:pin_name` if missing is build as "GPIOn" (n='pin number')
  * `:pin_key` if missing is build as :pinN (N='pin number)
  * `:pin_label` if missing is build from 'pin name' as lowercase atom

  """

  @doc """
  Return the the pin number in user space using sysfs
  """
  @callback pin_to_sysfs_pin(non_neg_integer(), list()) :: non_neg_integer()

  @doc """
  Return the the basic pinout definition map for all pins number.

  The keys of the map are the real pin number and the value must contains at least the pin number as key in the form:
  ```
  %{
    1 => [pin_name: "GPIO1"],
    ...
   }
  ```
  """
  @callback pinout_definition() :: map()

  defmacro __using__(_opts) do
    quote do

      @behaviour Breadboard.GPIO.BaseGPIOHelper

      def build_pinout_map() do
        pinout_definition()
        |> Enum.reduce([], &update_pin_info/2)
        |> Breadboard.GPIO.Utils.expand_map_with_value
      end

      defp update_pin_info({pin_number, info}, pins) do
        pin_name = Keyword.get(info, :pin_name, Breadboard.GPIO.Utils.to_pin_name("GPIO", pin_number))
        pin_info = info
        |> Keyword.put_new(:sysfs, pin_to_sysfs_pin(pin_number, info))
        |> Keyword.put_new(:pin_key, Breadboard.GPIO.Utils.to_pin_key("pin", pin_number))
        |> Keyword.put_new(:pin_label, Breadboard.GPIO.Utils.to_key_label(pin_name))
        |> Keyword.put_new(:pin_name, pin_name)
        |> Keyword.put(:pin, pin_number) # pin is unique as the original map pin_number
        [pin_info | pins]
      end

    end

  end

end


defmodule Breadboard.GPIO.BaseGPIO do

  @moduledoc """
  Define the behaviour to handle GPIOs pinout mapping for a specific platform.

  In order to support a Pinout mapping for a specific platform this `behaviours` can be referenced by modules implementing `c:pinout_map/0` function.
  This function must return a map with the GPIOs pinout information.
  Any element must support the keys:

  * `:pin` - the pin number ()
  * `:sysfs` - the pin number in user space using sysfs
  * `:pin_key` - key to identify the pin as atom
  * `:pin_label` - an atom to identify the pin label
  * `:pin_name` - the name of the pin

  As convention all values are defined lowercase except for `pin_name`.

  Any pin is classified with a keyword list with the above keys.

  For example the pin number 1 in the stub hardware abstraction is classified as:

  ```
  [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"]
  ```

  so in the complete pinout map for this pin it will be generate the corrispondend key/value pair for any single item:

  ```
  %{
     {:pin, 1}            => [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:sysfs, 1}          => [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:pin_key, :pin1}    => [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:pin_label, :gpio1} => [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:pin_name, "GPIO1"} => [pin: 1, sysfs: 1, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"]
  }
  ```

  and so on for any single pin to build the entire pinout map.


  Reference: `Breadboard.GPIO.StubHalGPIO`, `Breadboard.GPIO.SunxiGPIO`
  """

  @typedoc "Pin single information"
  @type pinout_item_info :: {:pin, non_neg_integer()} | {:sysfs, non_neg_integer()} | {:pin_key, atom()} | {:pin_label, atom()} | {:pin_name, String.t()}

  @typedoc "Complete Pinout information"
  @type pinout_item :: [pinout_item_info]

  @doc """
  Return the complete pinout map for a specific platform
  """
  @callback pinout_map() :: [pinout_item()]

  defmacro __using__(_opts) do
    quote do

      @behaviour Breadboard.GPIO.BaseGPIO

      @after_compile __MODULE__

      @doc"""
      Get real pin reference from 'pinout label'.

      Returns the real pin number (default for `sysfs` user space)
      """
      def label_to_pin(label, mode \\ :sysfs)
      def label_to_pin(label, :stub), do: label_to_pin(label, :sysfs)
      def label_to_pin(label, mode) do
        search_pin(label, mode)
      end

      @doc """
      Get pinout label from the pinout number.

      Returns the pin label as atom.
      """
      def pin_to_label(pin) do
        search_pin(pin, :pin_label)
      end

      defp search_pin(value, key) do
        pin_info = Map.get(pinout_map(), {:pin_key, value}) ||
          Map.get(pinout_map(), {:pin_label, value}) ||
          Map.get(pinout_map(), {:pin, value}) ||
          Map.get(pinout_map(), {:pin_name, value})

        Keyword.get(pin_info, key)
      end

      defp check_pinout_map_definition() do
        true = Enum.all?(pinout_map(),
          fn {{key, val}, info} ->
            keys = Keyword.keys(info)
            Keyword.equal?( keys, [:sysfs, :pin_key, :pin_label, :pin_name, :pin])
            ^val = Keyword.get(info, key, nil)
          end
        )
      end

      def __after_compile__(_env, _bytecode) do
        check_pinout_map_definition()
      end

    end

  end

end
