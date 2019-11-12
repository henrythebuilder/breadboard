defmodule Breadboard.Joystick.JoystickServer do

  @moduledoc false

  use GenServer

  require Logger

  @me __MODULE__

  alias Breadboard.Joystick.JoystickServerCmd

  def start_link(init_arg) do
    GenServer.start_link(@me, init_arg)
  end

  @default_addr 0x48
  @default_gain 6144
  @default_x_in {:ain0, :gnd}
  @default_y_in {:ain1, :gnd}
  @default_push_button_in {:ain2, :gnd}

  def init(init_arg) do
    Process.flag(:trap_exit, true)
    Logger.debug("Init joystick with args: #{inspect(init_arg)}")
    state = make_init_state(init_arg)
    Logger.debug("state = #{inspect state}")
    {:ok, state}
  end

  defp make_init_state(init_arg) do
     state = %{ init_arg: init_arg,
                i2c_bus_name: init_arg[:i2c_bus_name],
                i2c_bus_addr: Keyword.get(init_arg, :i2c_bus_addr, @default_addr),
                i2c_bus_gain: Keyword.get(init_arg, :i2c_bus_addr, @default_gain),
                push_button_in: Keyword.get(init_arg, :push_button_in, @default_push_button_in),
                x_axis_in: Keyword.get(init_arg, :x_axis_in, @default_x_in),
                y_axis_in: Keyword.get(init_arg, :y_axis_in, @default_y_in),
              }

     conn = %{ i2c_ref: open_i2c_bus(state[:i2c_bus_name]) }
     Map.merge( state, conn )
  end

  defp open_i2c_bus(bus_name) do
    {:ok, i2c_ref} = JoystickServerCmd.open_i2c_bus(bus_name)
    i2c_ref
  end

  def handle_call(:get_values, _from, state) do
    {:reply,
     JoystickServerCmd.read_values(state),
     state}
  end

  def terminate(reason, state) do
    JoystickServerCmd.terminate(state[:i2c_ref])
    Logger.debug("JoystickServer terminate: reason='#{inspect(reason)}', state='#{inspect(state)}'")
    state
  end

end

# SPDX-License-Identifier: Apache-2.0
