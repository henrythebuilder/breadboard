defmodule Breadboard.GPIO.BaseGPIO do

  @moduledoc """
  Define the behaviour to handle GPIOs pinout mapping for a specific platform.

  In order to support a Pinout mapping for a specific platform this `behaviours` can be referenced by modules implementing `c:pinout_map/0` function.
  This function must return a list with GPIOs pinout information, and any element must support the keys:

  * `:pin` - the pin number ()
  * `:sysfs` - the pin number in user space using sysfs
  * `:pin_key` - key to identify the pin as atom
  * `:pin_label` - an atom to identify the pin label
  * `:pin_name` - the name of the pin

  As convention all values are defined lowercase except for `pin_name`

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

      defp search_pin(label, key) do
        pin_info = Enum.find(pinout_map(),
          fn (info) ->
            pin_info_has_value?(info, label)
          end)
        Keyword.get(pin_info, key)
      end

      defp pin_info_has_value?(info, value) do
        (info[:pin_key] == value) ||
        (info[:pin_label] == value) ||
        (info[:pin] == value) ||
        (info[:pin_name] == value)
      end

      defp check_pinout_map_definition() do
        true = Enum.all?(pinout_map(),
          fn info ->
            keys = Keyword.keys(info)
            Keyword.equal?( keys, [:sysfs, :pin_key, :pin_label, :pin_name, :pin])
          end
        )
      end

      def __after_compile__(_env, _bytecode) do
        check_pinout_map_definition()
      end

    end

  end

end
