defmodule Breadboard do
  @moduledoc false

  def set_platform(new_platform) do
    Application.put_env(:breadboard, "breadboard_platform", new_platform)
    GenServer.call(Breadboard.GPIO.PinoutServer.server_name(), {:reload_state})
  end
  # @moduledoc """
  # Documentation for Breadboard.
  # """

  # @doc """
  # Hello world.

  # ## Examples

  #     iex> Breadboard.hello()
  #     :world

  # """
  # def hello do
  #   :world
  # end
end
