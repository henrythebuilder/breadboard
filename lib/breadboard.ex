defmodule Breadboard do

  @moduledoc """
  Breadboard High Level API.

  ## Platform
  Breadboarding platform isn't automatically detected.
  It may be defined by the key *"breadboard_platform"* in the application environment or in the system environment.
  The value is searching first in the application environment, then in the system environment and finally by the `Circuits.GPIO.info.name`

  At the moment supported platform are:
  - 'stub' -> hardware abstraction layer on platforms without GPIO support
  - 'sunxi'-> ARM SoCs family from Allwinner Technology

  """

  @platform_key "breadboard_platform"

  @doc """
  Set the platform in the Application environment

  """
  def set_platform(new_platform) do
    Application.put_env(:breadboard, @platform_key, new_platform)
    GenServer.call(Breadboard.GPIO.PinoutServer.server_name(), {:reload_state})
  end

  @doc """
  Get the current platform configured
  """
  def get_platform() do
    ( Application.get_env(:breadboard, @platform_key) ||
      System.get_env(to_string(@platform_key)) ||
      platform_by_gpio() )
    |> Breadboard.GPIO.Utils.to_key_label()
  end

  defp platform_by_gpio() do
    case gpio_info_name() do
      :stub ->
        :stub
      _ ->
        :unknown_platform
    end
  end

  @doc """
  Get the `name` from `Circuits.GPIO.info`
  """
  def gpio_info_name() do
    Circuits.GPIO.info.name
  end



  # @moduledoc """
  # Documentation for Breadboard.
  # """

  # @doc """
  # Hello world.

  # ## Examples

  #     iex> Breadboard.hello()
  #     :world

  # """
  # def hello do
  #   :world
  # end
end
