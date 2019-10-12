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

  """

  @doc """
  Set the platform in the Application environment

  """
  def set_platform(new_platform) do
    Breadboard.ApplicationHelper.set_platform(new_platform)
  end

  @doc """
  Get the current platform configured
  """
  def get_platform() do
    Breadboard.ApplicationHelper.get_platform()
  end


  @doc """
  Get the `name` from `Circuits.GPIO.info/0`
  """
  def gpio_info_name() do
     Breadboard.ApplicationHelper.gpio_info_name()
  end

end
