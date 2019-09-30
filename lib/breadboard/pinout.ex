defmodule Breadboard.Pinout do

  @moduledoc """
  This module manage the pinout for the used platform defined into 'BROADCOM_PLATFORM' env variable.

  At the moment supported platform are:
  - 'stub' -> hardware abstraction layer on platforms without GPIO support
  - 'sunxi'-> ARM SoCs family from Allwinner Technology

  Note that accessing the GPIO pins through sysfs in some case (i.e. ARM SoCs family from Allwinner Technology) the pinout number/label may differ from real pin reference number.

  The real pin number using 'Circuits.GPIO.info' 'name' key

  """

  @doc """
  Get real pin reference from 'pinout label'.

  Returns the real pin number.

  ## Example for Allwinner platform calling 'Breadboard.Pinout.label_to_pin' with "PG8", :pg8, 32 the value returne is always 200 (the real reference for sysfs number)

      iex> Breadboard.set_platform(:sunxi)
      iex> Breadboard.Pinout.label_to_pin("PG8")
      200
      iex> Breadboard.Pinout.label_to_pin(:pg8)
      200
      iex> Breadboard.Pinout.label_to_pin(32)
      200
      iex> Breadboard.Pinout.label_to_pin(:pin32)
      200

  ## Examples (for the default 'stub' reference)

      iex> Breadboard.set_platform(:stub)
      iex> Breadboard.Pinout.label_to_pin("GPIO18")
      18
      iex> Breadboard.Pinout.label_to_pin(:gpio18)
      18
      iex> Breadboard.Pinout.label_to_pin(18)
      18
      iex> Breadboard.Pinout.label_to_pin(:pin18)
      18

  """
  def label_to_pin(label) do
    GenServer.call(Breadboard.GPIO.PinoutServer.server_name(), {:label_to_pin, label})
  end

  @doc """
  Get pinout label from the pinout number.

  Returns the pin label as atom.

  ## Examples (for the default 'stub' reference)

      iex> Breadboard.set_platform(:stub)
      iex> Breadboard.Pinout.pin_to_label(:pin18)
      :gpio18
      iex> Breadboard.Pinout.pin_to_label(18)
      :gpio18

  """
  def pin_to_label(pin) do
    GenServer.call(Breadboard.GPIO.PinoutServer.server_name(), {:pin_to_label, pin})
  end

end
