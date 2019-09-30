defmodule Breadboard.GPIO.Utils do
  @moduledoc false

  def to_pin_key(prefix, n) do
    "#{prefix}#{n}" |> to_key_label
  end

  def to_key_label(label) do
    label |> to_string |> String.downcase |> String.to_atom
  end

  def get_platform() do
    get_env("breadboard_platform", :stub)
    |> to_key_label
  end

  def gpio_info_name() do
    (get_env("breadboard_gpio_info_name", Circuits.GPIO.info.name))
    |> to_key_label
  end

  defp get_env(key,  default \\ nil) do
    Application.get_env(:breadboard, key) ||
      System.get_env(to_string(key)) ||
        default
  end

  # defp get_system_env(key, default \\ nil) do
  #   System.get_env(to_string(key), default)
  # end

end
