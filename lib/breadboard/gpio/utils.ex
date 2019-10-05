defmodule Breadboard.GPIO.Utils do
  @moduledoc false

  def to_pin_key(prefix, n) do
    "#{prefix}#{n}" |> to_key_label
  end

  def to_key_label(label) do
    label |> to_string |> String.downcase |> String.to_atom
  end

  def build_pinout_map(pinout_info, update_pin_fun) do
    pinout_info
    |> Enum.reduce([], update_pin_fun)
    |> pinout_map_definition
  end

  defp pinout_map_definition(pinout_info) do
    pinout_info
    |> Enum.reduce(%{}, fn (pin_info, pinout_map) ->
      pin_map = Enum.reduce(pin_info, %{}, fn (info, map) ->
        Map.put(map, info, pin_info)
      end)
      Map.merge(pinout_map, pin_map)
    end)
  end

end
