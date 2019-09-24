defmodule Breadboard.GPIO.PinoutServer do

  @moduledoc false

  use GenServer

  require Logger

  @me __MODULE__

  def start_link() do
    GenServer.start_link(@me, nil)
  end

  def init(_) do
    state = [gpio_info: Circuits.GPIO.info,
             platform: Breadboard.GPIO.Utils.get_platform()]
    Logger.info("PinoutServer start with state=#{inspect state}")
    {:ok, state}
  end

  def handle_call({:label_to_pin, label}, _from, [gpio_info: gpio_info, platform: platform] = state) do
    pin = Breadboard.GPIO.PinoutHelp.label_to_pin(platform, gpio_info.name, label)
    { :reply, pin, state }
  end

end
