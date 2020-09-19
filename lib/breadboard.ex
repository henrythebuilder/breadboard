defmodule Breadboard do
  @moduledoc """
  Breadboard High Level API.

  ## Reference platform
  Breadboarding platform isn't automatically detected.

  It may be defined by the key "`breadboard_platform`" in the application environment or in the system environment.

  The value is searching first in the application environment, then in the system environment and finally by the `Circuits.GPIO.info/0` (to check the *stub* context from the `name` key)

  At the moment supported platform are:
  - ***stub*** -> hardware abstraction layer on platforms without GPIO support
  - ***sunxi***-> ARM SoCs family from Allwinner Technology

  ### "Runtime Configuration" Application sample:

      iex> current_platform = Breadboard.get_platform()
      iex> Breadboard.set_platform(:stub)
      iex> :stub = Breadboard.get_platform()
      iex> Breadboard.set_platform(:sunxi)
      iex> :sunxi = Breadboard.get_platform()
      iex> Breadboard.set_platform(current_platform)
      iex> nil

  """

  @doc """
  Set the platform in the Application environment

  """
  def set_platform(new_platform) do
    Breadboard.Platform.Environment.set_platform(new_platform)
    GenServer.call(Breadboard.GPIO.PinoutServer.server_name(), {:reload_state})
  end

  @doc """
  Get the current platform configured
  """
  def get_platform() do
    Breadboard.Platform.Environment.get_platform()
  end

  @doc """
  Disconnect all components from Breadboard
  """
  def disconnect_all_components() do
    Breadboard.Supervisor.Switch.stop_all_child()
    Breadboard.Supervisor.Joystick.stop_all_child()
  end
end

# SPDX-License-Identifier: Apache-2.0
