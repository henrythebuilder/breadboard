defmodule Breadboard.GPIO.Utils do
  @moduledoc false

  def to_pin_key(prefix, n) do
    to_pin_name(prefix, n) |> to_key_label
  end

  def to_key_label(label) do
    label |> to_string |> String.downcase |> String.to_atom
  end

  def to_pin_name(prefix, n) do
    "#{prefix}#{n}"
  end

  def expand_map_with_value(map_info) do
    map_info
    |> Enum.reduce(%{}, fn (pin_info, pinout_map) ->
      pin_map = Enum.reduce(pin_info, %{}, fn (info, map) ->
        Map.put(map, info, pin_info)
      end)
      Map.merge(pinout_map, pin_map)
    end)
  end

end
