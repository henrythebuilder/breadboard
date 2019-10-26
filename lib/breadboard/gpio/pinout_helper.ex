defmodule Breadboard.GPIO.PinoutHelper do
  @moduledoc false

  def to_pin_key(prefix, n) do
    to_pin_name(prefix, n) |> to_label_key
  end

  def to_label_key(label) do
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

# SPDX-License-Identifier: Apache-2.0
