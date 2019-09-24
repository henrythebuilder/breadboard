defmodule Breadboard.GPIO.Utils do

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
    get_env_variable("BREADBOARD_PLATFORM")
    |> String.downcase()
    |> String.to_atom()
  end
end
