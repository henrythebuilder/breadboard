defmodule Breadboard.Supervisor.Base do

  @moduledoc false

  defmacro __using__(opts) do
    child_module = Keyword.get(opts, :child_module)

    quote do

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

      def start_child(options) do
        child_spec = %{ id: unquote(child_module),
                        start: {unquote(child_module), :start_link, [options]},
                        restart: :temporary }
        DynamicSupervisor.start_child(@me, child_spec)
      end

      def stop_child(pid) do
        DynamicSupervisor.terminate_child(@me, pid)
      end

      def stop_all_child() do
        Logger.debug("Stop all child of '#{inspect(@me)}' from Breadboard ...")
        DynamicSupervisor.which_children(@me)
        |> Enum.map(fn ({_, pid, _, _}) ->
          DynamicSupervisor.terminate_child(@me, pid)
        end)
        |> Enum.all?(fn(r) -> r==:ok end)
      end

    end
  end

end
