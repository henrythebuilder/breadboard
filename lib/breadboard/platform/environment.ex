defmodule Breadboard.Platform.Environment do
  @moduledoc false

  @platform_key :breadboard_platform

  def set_platform(new_platform) do
    Application.put_env(:breadboard, @platform_key, new_platform)
  end

  def get_platform() do
    (Application.get_env(:breadboard, @platform_key) ||
       System.get_env(to_string(@platform_key)) ||
       System.get_env(String.upcase(to_string(@platform_key))) ||
       platform_by_gpio())
    |> Breadboard.GPIO.PinoutHelper.to_label_key()
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
    Circuits.GPIO.info().name
  end
end

# SPDX-License-Identifier: Apache-2.0
