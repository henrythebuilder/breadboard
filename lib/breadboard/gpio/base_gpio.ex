defmodule Breadboard.GPIO.BaseGPIO do

  @moduledoc false

  #
  # [pin: 3, sysfs: 12, pin_key: :pin3, pin_label: :pa12, pin_name: "PA12"]
  #
  @callback pinout_map() :: any

  defmacro __using__(_opts) do
    quote do

      @behaviour Breadboard.GPIO.BaseGPIO

      @after_compile __MODULE__

      def label_to_pin(label, mode \\ :sysfs)

      def label_to_pin(label, mode) do
        search_pin(label, mode)
      end

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
