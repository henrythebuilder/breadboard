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
                    %{interrupts_receiver: Keyword.get(irq_opts, :interrupts_receiver, nil)}
                  _ ->
                    %{}
                end
    {set_irq, irq_state}
  end

  def irq_service_call(interrupts_receiver, irq_info) do
    do_irq_call(interrupts_receiver, irq_info)
  end

  defp do_irq_call(interrupts_receiver, irq_info) when is_function(interrupts_receiver, 1) do
    interrupts_receiver.(irq_info)
  end

  defp do_irq_call(interrupts_receiver, irq_info) do
    send(interrupts_receiver, {:irq_service_call, irq_info})
  end

  def set_direction(gpio, switch_direction) do
    Circuits.GPIO.set_direction(gpio, switch_direction)
  end

  def set_pull_mode(gpio, pull_mode) do
    Circuits.GPIO.set_pull_mode(gpio, pull_mode)
  end

  def terminate(gpio) do
    close_gpio = Circuits.GPIO.close(gpio)
    Logger.debug("SwitchServer close GPIO #{inspect(gpio)} with result: '#{inspect(close_gpio)}'")
    close_gpio
  end
end
