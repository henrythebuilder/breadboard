defmodule Breadboard.Pinout do

  @moduledoc """
  This module manage the pinout for the supported platform.

  Note that accessing the GPIO pins through sysfs in some case (i.e. ARM SoCs family from Allwinner Technology) the pinout number/label may differ from real pin reference number.

  The real pin number using 'Circuits.GPIO.info' 'name' key

  """

  @doc """
  Get real pin reference from 'pinout label'.

  Returns the real pin number.

  ## Example for Allwinner platform calling 'Breadboard.Pinout.label_to_pin' with "PG8", :pg8, 32 the value returne is always 200 (the real reference for sysfs number)

      iex> if(Breadboard.get_platform()==:sunxi ) do
      iex> 200 = Breadboard.Pinout.label_to_pin("PG8")
      iex> 200 = Breadboard.Pinout.label_to_pin(:pg8)
      iex> 200 = Breadboard.Pinout.label_to_pin(32)
      iex> 200 = Breadboard.Pinout.label_to_pin(:pin32)
      iex> nil
      iex> end
      nil

  ## Examples (for the default 'stub' reference)

      iex> if(Breadboard.get_platform()==:stub ) do
      iex> 18 = Breadboard.Pinout.label_to_pin("GPIO18")
      iex> 18 = Breadboard.Pinout.label_to_pin(:gpio18)
      iex> 18 = Breadboard.Pinout.label_to_pin(18)
      iex> 18 = Breadboard.Pinout.label_to_pin(:pin18)
      iex> nil
      iex> end
      nil

  """
  def label_to_pin(label) do
    GenServer.call(Breadboard.GPIO.PinoutServer.server_name(), {:label_to_pin, label})
  end

  @doc """
  Get pinout label from the pinout number.

  Returns the pin label as atom.

  ## Examples (for the default 'stub' reference)

      iex> if(Breadboard.get_platform()==:stub ) do
      iex> :gpio18 = Breadboard.Pinout.pin_to_label(:gpio18)
      iex> :gpio18 = Breadboard.Pinout.pin_to_label("GPIO18")
      iex> :gpio18 = Breadboard.Pinout.pin_to_label(:pin18)
      iex> :gpio18 = Breadboard.Pinout.pin_to_label(18)
      iex> nil
      iex> end
      nil

  """
  def pin_to_label(pin) do
    GenServer.call(Breadboard.GPIO.PinoutServer.server_name(), {:pin_to_label, pin})
  end

end
