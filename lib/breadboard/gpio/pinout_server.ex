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
    state = %{gpio_info_name: Breadboard.GPIO.Utils.gpio_info_name(),
             platform: Breadboard.GPIO.Utils.get_platform()}
    Logger.info("PinoutServer started (#{inspect(self())}) with state: '#{inspect state}'")
    {:ok, state}
  end

  def handle_call({:label_to_pin, label}, _from, state) do
    pin = Breadboard.GPIO.PinoutHelp.label_to_pin(state.platform, state.gpio_info_name, label)
    { :reply, pin, state }
  end

  def handle_call({:pin_to_label, pin}, _from, state) do
    label = Breadboard.GPIO.PinoutHelp.pin_to_label(state.platform, pin)
    { :reply, label, state }
  end

end
