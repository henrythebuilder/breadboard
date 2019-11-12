defmodule Breadboard.Joystick.JoystickServerCmd do

  @moduledoc false

  require Logger

  alias Circuits.I2C

  def open_i2c_bus(bus_name) do
    open_i2c = I2C.open(bus_name)
    Logger.debug("JoystickServer open I2C bus #{inspect(bus_name)} with result: '#{inspect(open_i2c)}'")
    open_i2c
  end

  def terminate(i2c_ref) do
    close_i2c = I2C.close(i2c_ref)
    Logger.debug("JoystickServer close I2C bus #{inspect(i2c_ref)} with result: '#{inspect(close_i2c)}'")
    close_i2c
  end

  def read_values(state) do
    {:ok , x} = ADS1115.read( state[:i2c_ref],
      state[:i2c_bus_addr],
      state[:x_axis_in], state[:i2c_bus_gain]
    )
    {:ok , y} = ADS1115.read( state[:i2c_ref],
      state[:i2c_bus_addr],
      state[:y_axis_in], state[:i2c_bus_gain]
    )
    {:ok , btn} = ADS1115.read( state[:i2c_ref],
      state[:i2c_bus_addr],
      state[:push_button_in], state[:i2c_bus_gain]
    )
    [ x_axis: x, y_axis: y, push_button: btn ]
  end

end

# SPDX-License-Identifier: Apache-2.0
