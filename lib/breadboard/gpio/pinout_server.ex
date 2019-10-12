defmodule Breadboard.GPIO.PinoutServer do

  @moduledoc false

  use GenServer

  require Logger

  @me __MODULE__

  def server_name(), do: @me

  def start_link() do
    GenServer.start_link(@me, nil, name: server_name())
  end

  def init(_) do
    state = load_state()
    Logger.debug("PinoutServer started (#{inspect(self())}) with state: '#{inspect state}'")
    {:ok, state}
  end

  def handle_call({:label_to_pin, label}, _from, state) do
    pin = Breadboard.GPIO.PinoutCmd.label_to_pin(state.platform, state.gpio_info_name, label)
    { :reply, pin, state }
  end

  def handle_call({:pin_to_label, pin}, _from, state) do
    label = Breadboard.GPIO.PinoutCmd.pin_to_label(state.platform, pin)
    { :reply, label, state }
  end

  def handle_call({:reload_state}, _from, state) do
    new_state = load_state()
    Logger.debug("PinoutServer state updated from: '#{inspect state}' to '#{inspect new_state}'")
    {:reply, :ok, new_state}
  end

  defp load_state() do
    %{gpio_info_name: Breadboard.ApplicationHelper.gpio_info_name(),
       platform: Breadboard.ApplicationHelper.get_platform()}
  end
end
