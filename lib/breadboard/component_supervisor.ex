defmodule Breadboard.ComponentSupervisor do

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

  def start_switch_server_child(options) do
    child_spec = %{ id: SwitchServer,
                    start: {Breadboard.Switch.SwitchServer, :start_link, [options]},
                    restart: :temporary }
    DynamicSupervisor.start_child(@me, child_spec)
  end

  def stop_joystick_server_child(pid) do
    DynamicSupervisor.terminate_child(@me, pid)
  end

  def stop_switch_server_child(pid) do
    DynamicSupervisor.terminate_child(@me, pid)
  end

  def stop_all() do
    stop_all_switch_server_child()
    stop_all_joystick_server_child()
  end

  def stop_all_switch_server_child() do
    stop_all_child(Breadboard.Switch.SwitchServer)
  end

  def stop_all_joystick_server_child() do
    stop_all_child(Breadboard.Joystick.JoystickServer)
  end

  defp stop_all_child(module) do
    Logger.debug("Disconnecting all open component '#{inspect(module)}' from Breadboard ...")
    DynamicSupervisor.which_children(@me)
    |> Enum.filter(fn ({_, _, _, [mod]}) ->
      mod == module
    end)
    |> Enum.map(fn ({_, pid, _, _}) ->
      DynamicSupervisor.terminate_child(@me, pid)
    end)
    |> Enum.all?(fn(r) -> r==:ok end)
  end
end
