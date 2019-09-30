defmodule Breadboard.GPIO.Utils do
  @moduledoc false

  def to_pin_key(prefix, n) do
    "#{prefix}#{n}" |> to_key_label
  end

  def to_key_label(label) do
    label |> to_string |> String.downcase |> String.to_atom
  end

  def get_env_variable(key, default \\ nil) do
    System.get_env(to_string(key), default)
  end

  def get_platform() do
    get_env_variable("BREADBOARD_PLATFORM", "stub")
    |> String.downcase()
    |> String.to_atom()
  end

  def gpio_info_name() do
    (get_env_variable("BREADBOARD_GPIO_INFO_NAME") || Circuits.GPIO.info.name)
    |> to_string()
    |> String.downcase()
    |> String.to_atom()
  end

end
