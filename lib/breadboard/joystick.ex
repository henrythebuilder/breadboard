defmodule Breadboard.Joystick do
  @moduledoc """
  Manage the 'Joystick' using the I2C protocol

  Joystick module refer to a simple hardware consisting of an *analog joystick* connected to an 'ADS1115' *analog to digital converter* using the I2C Interface.

  This hardware is tested on a [OrangePi board](http://www.orangepi.org/) (PC and PC2) by this default pins assignment:

  Analog Joystic | ADS1115 | OrangePi board
  -------------- | ------- | --------------
   5V            |         | pin 1 (+3.3V)
   GND           |         | pin 9 (Ground)
   VRx           |  an0    | _
   VRy           |  an1    | _
   SW            |  an2    | _
   _             |  VDD    | pin 1 (+3.3V)
   _             |  GND    | pin 9 (Ground)
   _             |  SCL    | pin 5 (TWI0_SCK)
   _             |  SDA    | pin 3 (TWI0_SDA)


   Note:

   - I2C Addressing by ADR pin >> 0x48 (1001000) ADR -> GND
   - Analog Inputs >> Single Ended type (Input Channel <-> GND)
   - Internally `Breadboard` use the `ADS1115` library to manage I2C protocol

  Any *Joystick* is supervised in the application, but if the *joystick* (*child*) process crashed is never restarted.

  """

  @typedoc "Options for `Breadboard.Joystick.connect/1`"
  @type connect_options ::
          {:i2c_bus_name, any()}
          | {:i2c_bus_addr, Circuits.I2C.address()}
          | {:i2c_bus_gain, ADS1115.Config.gain()}
          | {:push_button_in, ADS1115.Config.comparison()}
          | {:x_axis_in, ADS1115.Config.comparison()}
          | {:y_axis_in, ADS1115.Config.comparison()}

  @doc """
  Connect to a 'Joystick hardware'.

  Options:

  * `:i2c_bus_name` - any valid 'bus name' valid for the platform in the form "i2c-n" where "n" is the bus number (as defined in `Circuits.I2C`).
  * `:i2c_bus_addr` - address of the device, as defined in `Circuits.I2C` (`0x48`)
  * `:i2c_bus_gain` - range of the ADC scaling, as defined in `ADS1115` (`6144`)
  * `:push_button_in` - Input Channel for 'push button' (`{:ain2, :gnd}`)
  * `:x_axis_in` - Input Channel for the measurement of the X axis (`{:ain0, :gnd}`)
  * `:y_axis_in` - Input Channel for the measurement of the Y axis (`{:ain1, :gnd}`)

  Return values:
  On success the function returns `{:ok, joystick}`, where `joystick` is the PID of the supervised 'Joystick'
  """
  @spec connect(connect_options()) :: {:ok, reference()} | {:error, atom()}
  def connect(options) do
    Breadboard.Supervisor.Joystick.start_child(options)
  end

  @doc """
  Read the current state values of a joystick

  ## Examples

      > {:ok, joystick} = Joystick.connect([i2c_bus_name: "i2c-0"])
      {:ok, #PID<0.388.0>}
      > Joystick.get_values(joystick)
      [x_axis: 8940, y_axis: 8863, push_button: 17510]

  *any single value will be between -32,768 and 32,767*
  """
  @spec get_values(reference()) :: nonempty_list(any())
  def get_values(joystick) do
    GenServer.call(joystick, :get_values)
  end

  @doc """
  Disconnect the joystick from the 'breadboard'
  """
  @spec disconnect(reference()) :: :ok | {:error, :not_found}
  def disconnect(joystick) do
    Breadboard.Supervisor.Joystick.stop_child(joystick)
  end
end

# SPDX-License-Identifier: Apache-2.0
