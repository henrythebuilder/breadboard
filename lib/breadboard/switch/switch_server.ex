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
    pin = Pinout.label_to_pin(init_arg[:pin])
    mode = init_arg[:mode]
    {:ok, gpio} = Circuits.GPIO.open(pin, mode)
    state = %{gpio_pin: pin,
              gpio: gpio}
    Logger.info("Switch server started (#{inspect(self())}) on pin '#{inspect(init_arg[:pin])}' as '#{inspect(pin)}', mode '#{inspect(mode)}', server state: '#{inspect(state)}'")
    {:ok, state}
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
    Logger.info("Switch server terminate: reason='#{inspect(reason)}', state='#{inspect(state)}'")
    state
  end

end
