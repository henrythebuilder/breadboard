defmodule Breadboard.Joystick.JoystickServer do

  @moduledoc false

  use GenServer

  require Logger

  @me __MODULE__

  alias Circuits.I2C
  alias Breadboard.Joystick.JoystickServerCmd

  def start_link(init_arg) do
    GenServer.start_link(@me, init_arg)
  end

  def init(init_arg) do
    Process.flag(:trap_exit, true)
    {:ok, i2c_ref} = JoystickServerCmd.open_i2c_bus(init_arg[:i2c_bus_name])
    state = %{init_arg: init_arg,
              i2c_bus_name: init_arg[:i2c_bus_name],
              i2c_ref: i2c_ref
             }

    {:ok, state}
  end

  def terminate(reason, state) do
    JoystickServerCmd.terminate(state[:i2c_ref])
    Logger.debug("JoystickServer terminate: reason='#{inspect(reason)}', state='#{inspect(state)}'")
    state
  end

end

# SPDX-License-Identifier: Apache-2.0
