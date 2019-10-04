defmodule Breadboard.Switch.SwitchServerCmd do

  @moduledoc false

  require Logger

  alias Breadboard.Pinout

  def open_gpio_pin(init_arg) do
    pin = Pinout.label_to_pin(init_arg[:pin])
    open_gpio = Circuits.GPIO.open(pin, init_arg[:direction], Keyword.take(init_arg, [:initial_value, :pull_mode]) )
    Logger.debug("SwitchServer open GPIO #{inspect(pin)} with result: '#{inspect(open_gpio)}'")
    open_gpio
  end

  def pin_number(gpio) do
    Circuits.GPIO.pin(gpio)
  end

  def set_value(gpio, value) do
    Circuits.GPIO.write(gpio, value)
  end

  def get_value(gpio) do
    Circuits.GPIO.read(gpio)
  end

  def set_interrupts(gpio, irq_opts) do
    set_irq = Circuits.GPIO.set_interrupts(gpio,
      Keyword.get(irq_opts, :trigger, :both),
      Keyword.get(irq_opts, :opts, []))
    irq_state = case set_irq do
                  :ok ->
                    %{interrupts_module: Keyword.get(irq_opts, :module, nil)}
                  _ ->
                    %{}
                end
    {set_irq, irq_state}
  end

  def irq_service_call(interrupts_module, pin_number, pin_label, timestamp, value) do
    args = [%Breadboard.IRQInfo{pin_number: pin_number,
                                timestamp: timestamp,
                                new_value: value,
                                pin_label: pin_label}]
    apply(interrupts_module, :interrupt_service_routine, args)
  end

  def set_direction(gpio, switch_direction) do
    Circuits.GPIO.set_direction(gpio, switch_direction)
  end

  def set_pull_mode(gpio, pull_mode) do
    Circuits.GPIO.set_pull_mode(gpio, pull_mode)
  end

  def terminate(gpio) do
    Circuits.GPIO.close(gpio)
  end
end
