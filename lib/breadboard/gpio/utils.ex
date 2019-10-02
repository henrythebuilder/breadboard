defmodule Breadboard.GPIO.Utils do
  @moduledoc false

  def to_pin_key(prefix, n) do
    "#{prefix}#{n}" |> to_key_label
  end

  def to_key_label(label) do
    label |> to_string |> String.downcase |> String.to_atom
  end

  def get_platform() do
    key = "breadboard_platform"
    ( Application.get_env(:breadboard, key) ||
      System.get_env(to_string(key)) ||
      platform_by_gpio() )
    |> to_key_label()
  end

  defp platform_by_gpio() do
    case gpio_info_name() do
      :stub ->
        :stub
      _ ->
        :unknown_platform
    end
  end

  def gpio_info_name() do
    Circuits.GPIO.info.name
  end

end
