defmodule Breadboard.JoystickSupervisor do

  @moduledoc false

  # Automatically defines child_spec/1
  use DynamicSupervisor

  require Logger

  @me __MODULE__

  def start_link() do
    start_link(nil)
  end

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: @me)
  end

  @impl true
  def init(_init_arg) do
    Logger.debug("#{inspect(@me)} start")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # child api
  def start_joystick_server_child(options) do
    child_spec = %{ id: JoystickServer,
                    start: {Breadboard.Joystick.JoystickServer, :start_link, [options]},
                    restart: :temporary }
    DynamicSupervisor.start_child(@me, child_spec)
  end

  def stop_joystick_server_child(pid) do
    DynamicSupervisor.terminate_child(@me, pid)
  end


end

# SPDX-License-Identifier: Apache-2.0
