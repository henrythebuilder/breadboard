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

end
