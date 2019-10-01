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
    state = %{init_arg: init_arg, gpio: gpio, pin_label: Pinout.pin_to_label(init_arg[:pin]) }
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

  def handle_call({:set_interrupts, irq_opts}, _from, state) do
    Circuits.GPIO.set_interrupts(state[:gpio],
                                 Keyword.get(irq_opts, :trigger, :both),
                                 Keyword.get(irq_opts, :opts, []))
    {:reply,
     :ok,
     Map.put(state, :interrupts_module, Keyword.get(irq_opts, :module, nil))}
  end

  def handle_info({:circuits_gpio, pin_number, timestamp, value}, state) do
    args = [%Breadboard.IRQInfo{pin_number: pin_number, timestamp: timestamp, new_value: value, pin_label: state.pin_label}]
    apply(state.interrupts_module, :interrupt_service_routine, args)
    {:noreply, state}
  end

  def terminate(reason, state) do
    Circuits.GPIO.close(state[:gpio])
    Logger.info("SwitchServer terminate: reason='#{inspect(reason)}', state='#{inspect(state)}'")
    state
  end

end
