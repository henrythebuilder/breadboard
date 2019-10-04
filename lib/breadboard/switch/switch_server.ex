defmodule Breadboard.Switch.SwitchServer do

  @moduledoc false

  use GenServer

  require Logger

  @me __MODULE__

  alias Breadboard.Pinout
  alias Breadboard.Switch.SwitchServerCmd

  def start_link(init_arg) do
    GenServer.start_link(@me, init_arg)
  end

  def init(init_arg) do
    Process.flag(:trap_exit, true)
    {:ok, gpio} = SwitchServerCmd.open_gpio_pin(init_arg)
    state = %{init_arg: init_arg, gpio: gpio, pin_label: Pinout.pin_to_label(init_arg[:pin]) }
    Logger.debug("SwitchServer started (#{inspect(self())}) with state: '#{inspect(state)}'")
    {:ok, state}
  end

  def handle_call(:pin_number, _from, state) do
    {:reply,
     SwitchServerCmd.pin_number(state[:gpio]),
     state}
  end

  def handle_call({:set_value, value}, _from, state) do
    {:reply,
     SwitchServerCmd.set_value(state[:gpio], value),
     state}
  end

  def handle_call(:turn_on, from, state) do
    handle_call({:set_value, 1}, from, state)
  end

  def handle_call(:turn_off, from, state) do
    handle_call({:set_value, 0}, from, state)
  end

  def handle_call(:get_value, _from, state) do
    {:reply,
     SwitchServerCmd.get_value(state[:gpio]),
     state}
  end

  def handle_call({:set_interrupts, irq_opts}, _from, state) do
    {set_irq, irq_state} = SwitchServerCmd.set_interrupts(state[:gpio], irq_opts)
    {:reply, set_irq, Map.merge(state, irq_state)}
  end

  def handle_call({:set_direction, switch_direction}, _from, state) do
    {:reply,
     SwitchServerCmd.set_direction(state[:gpio], switch_direction),
     state}
  end

  def handle_call({:set_pull_mode, pull_mode}, _from, state) do
    {:reply,
     SwitchServerCmd.set_pull_mode(state[:gpio], pull_mode),
     state}
  end

  def handle_info({:circuits_gpio, pin_number, timestamp, value}, state) do
    SwitchServerCmd.irq_service_call(state.interrupts_module,
                                     state.pin_label,
                                     pin_number, timestamp, value)
    {:noreply, state}
  end

  def terminate(reason, state) do
    SwitchServerCmd.terminate(state[:gpio])
    Logger.debug("SwitchServer terminate: reason='#{inspect(reason)}', state='#{inspect(state)}'")
    state
  end

end
