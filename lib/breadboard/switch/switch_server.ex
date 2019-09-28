defmodule Breadboard.Switch.SwitchServer do

  @moduledoc false

  use GenServer

  require Logger

  @me __MODULE__

  alias Breadboard.Pinout

  def start_link(init_arg) do
    GenServer.start_link(@me, init_arg)
  end

  def init(init_arg) do
    Process.flag(:trap_exit, true)
    {:ok, gpio} = open_gpio_pin(init_arg)
    state = %{init_arg: init_arg, gpio: gpio}
    Logger.info("SwitchServer started (#{inspect(self())}) with state: '#{inspect(state)}'")
    {:ok, state}
  end

  defp open_gpio_pin(init_arg) do
    pin = Pinout.label_to_pin(init_arg[:pin])
    open_gpio = Circuits.GPIO.open(pin, init_arg[:direction], Keyword.take(init_arg, [:initial_value]) )
    Logger.info("SwitchServer open GPIO #{inspect(pin)} with result: '#{inspect(open_gpio)}'")
    open_gpio
  end

  def handle_call(:turn_on, _from, state) do
    {:reply,
     Circuits.GPIO.write(state[:gpio], 1),
     state}
  end

  def handle_call(:turn_off, _from, state) do
    {:reply,
     Circuits.GPIO.write(state[:gpio], 0),
     state}
  end

  def handle_call(:get_value, _from, state) do
    {:reply,
     Circuits.GPIO.read(state[:gpio]),
     state}
  end

  def terminate(reason, state) do
    Circuits.GPIO.close(state[:gpio])
    Logger.info("Switch server terminate: reason='#{inspect(reason)}', state='#{inspect(state)}'")
    state
  end

end
