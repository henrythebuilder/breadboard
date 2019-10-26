defmodule Breadboard.SwitchSupervisor do

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
    Logger.debug("Breadboard DynamicSupervisor start")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # child api
  def start_switch_server_child(options) do
    child_spec = %{ id: SwitchServer,
                    start: {Breadboard.Switch.SwitchServer, :start_link, [options]},
                    restart: :temporary }
    DynamicSupervisor.start_child(@me, child_spec)
  end

  def stop_switch_server_child(pid) do
    DynamicSupervisor.terminate_child(@me, pid)
  end

  def which_switch() do
    DynamicSupervisor.which_children(@me)
    |> Enum.reduce([], fn ({_, pid, _, _}, acc) ->
      [{pid, Breadboard.Switch.pin_label(pid)} | acc]
    end)
  end

  def stop_all_switch_server_child() do
    Logger.debug("Disconnecting all open Switch from Breadboard ...")
    DynamicSupervisor.which_children(@me)
    |> Enum.map(fn ({_, pid, _, _}) ->
      stop_switch_server_child(pid)
    end)
    |> Enum.all?(fn(r) -> r==:ok end)
  end

end

# SPDX-License-Identifier: Apache-2.0
