defmodule Breadboard.Switch do
  @moduledoc """
  Manage the 'switch' operation on gpio.

  Any *switch* is supervised in the application, but if the *switch* (*child*) process crashed is never restarted.

  ## Examples

  ### Turn on/off the switch

      iex> if(Breadboard.get_platform()==:stub ) do
      iex> {:ok, switch} = Breadboard.Switch.connect([pin: :gpio18, direction: :output])
      iex> Breadboard.Switch.turn_on(switch)
      iex> 1 = Breadboard.Switch.get_value(switch)
      iex> Breadboard.Switch.turn_off(switch)
      iex> 0 = Breadboard.Switch.get_value(switch)
      iex> Breadboard.Switch.set_value(switch, 1)
      iex> 1 = Breadboard.Switch.get_value(switch)
      iex> Breadboard.Switch.set_value(switch, 0)
      iex> 0 = Breadboard.Switch.get_value(switch)
      iex> nil
      iex> end
      nil

  ### Pin/Label of the switch

      iex> if(Breadboard.get_platform()==:stub ) do
      iex> {:ok, switch} = Breadboard.Switch.connect([pin: :gpio5, direction: :output])
      iex> 5 = Breadboard.Switch.pin_number(switch)
      iex> :gpio5 = Breadboard.Switch.pin_label(switch)
      iex> nil
      iex> end
      nil

      iex> if(Breadboard.get_platform()==:sunxi ) do
      iex> {:ok, switch} = Breadboard.Switch.connect([pin: :pa6, direction: :input])
      iex> 6 = Breadboard.Switch.pin_number(switch)
      iex> :pa6 = Breadboard.Switch.pin_label(switch)
      iex> nil
      iex> end
      nil

  ### Switch with initial value

      iex> if(Breadboard.get_platform()==:stub ) do
      iex> {:ok, switch1} = Breadboard.Switch.connect([pin: :gpio18, direction: :output, initial_value: 1])
      iex> {:ok, switch0} = Breadboard.Switch.connect([pin: "GPIO9", direction: :output, initial_value: 0])
      iex> 0 = Breadboard.Switch.get_value(switch0)
      iex> 1 = Breadboard.Switch.get_value(switch1)
      iex> nil
      iex> end
      nil

  ### Switch as input and output (Stub HAL with pair of GPIOs is connected)
      iex> if(Breadboard.get_platform()==:stub ) do # only for Unit Test purpose
      ...> {:ok, switch0} = Breadboard.Switch.connect([pin: :gpio0, direction: :input, initial_value: 0])
      ...> :ok = Breadboard.Switch.set_direction(switch0, :output)
      ...> {:ok, switch1} = Breadboard.Switch.connect([pin: :gpio1, direction: :input, initial_value: 0])
      ...> Breadboard.Switch.get_value(switch0)
      ...> Breadboard.Switch.get_value(switch1)
      ...> Breadboard.Switch.turn_on(switch0)
      ...> 1 = Breadboard.Switch.get_value(switch1)
      ...> Breadboard.Switch.disconnect(switch0)
      ...> Breadboard.Switch.disconnect(switch1)
      ...> nil
      ...> end
      nil

  ### Simple Interrupt test, by function:
      iex> if(Breadboard.get_platform()==:stub ) do # only for Unit Test purpose
      ...>   defmodule InterruptsTest do
      ...>     def interrupt_service_routine(_irq_info=%Breadboard.IRQInfo{}) do
      ...>       # on interrupt turn on 'test pin' value
      ...>       {:ok, switch_test} = Breadboard.Switch.connect([pin: :gpio3, direction: :output])
      ...>       Breadboard.Switch.turn_on(switch_test)
      ...>       Breadboard.Switch.disconnect(switch_test)
      ...>     end
      ...>   end
      ...>   # open two pin as in and out ...
      ...>   {:ok, switch_in} = Breadboard.Switch.connect([pin: :gpio1, direction: :input])
      ...>   {:ok, switch_out} = Breadboard.Switch.connect([pin: :gpio1, direction: :output])
      ...>   # ... plus a pin as test raised to one on irq notification
      ...>   {:ok, switch_test} = Breadboard.Switch.connect([pin: :gpio3, direction: :output, initial_value: 0])
      ...>   # pin value is 0
      ...>   0 = Breadboard.Switch.get_value(switch_test)
      ...>   :ok = Breadboard.Switch.set_interrupts(switch_in, [interrupts_receiver: &InterruptsTest.interrupt_service_routine/1, trigger: :both, opts: []])
      ...>   Breadboard.Switch.turn_on(switch_out)
      ...>   Process.sleep(50)
      ...>   1 = Breadboard.Switch.get_value(switch_test)
      ...>   Breadboard.Switch.disconnect(switch_in)
      ...>   Breadboard.Switch.disconnect(switch_out)
      ...>   Breadboard.Switch.disconnect(switch_test)
      ...>   nil
      ...> end
      nil

  ### ... and by message:
      iex> if(Breadboard.get_platform()==:stub ) do # only for Unit Test purpose
      ...>   {:ok, switch_in} = Breadboard.Switch.connect([pin: :gpio1, direction: :input])
      ...>   {:ok, switch_out} = Breadboard.Switch.connect([pin: :gpio1, direction: :output, initial_value: 0])
      ...>   # pin value is 0
      ...>   0 = Breadboard.Switch.get_value(switch_in)
      ...>   :ok = Breadboard.Switch.set_interrupts(switch_in, [interrupts_receiver: self(), trigger: :rising, opts: []])
      ...>   Breadboard.Switch.turn_on(switch_out)
      ...>   receive do
      ...>     {:irq_service_call, %Breadboard.IRQInfo{pin_number: 1, pin_label: :gpio1, new_value: 1}} ->
      ...>       :ok
      ...>     _bad_msg ->
      ...>       raise(RuntimeError, "Unexpected message received")
      ...>   after
      ...>     1000 ->
      ...>       raise(RuntimeError, "NO message received")
      ...>   end
      ...>   1 = Breadboard.Switch.get_value(switch_in)
      ...>   nil
      ...> end
      nil

  """

  @typedoc "Switch value: 0/1 - as in `t:Circuits.GPIO.value/0`"
  @type value :: Circuits.GPIO.value()

  @typedoc "The Switch direction (input or output) - as in `t:Circuits.GPIO.pin_direction/0`"
  @type switch_direction :: Circuits.GPIO.pin_direction()

  @typedoc "Pull mode as defined in `t:Circuits.GPIO.pull_mode/0`"
  @type pull_mode :: Circuits.GPIO.pull_mode()

  @typedoc "Options for `Breadboard.Switch.connect/1`"
  @type connect_options ::
          {:pin, any()}
          | {:direction, switch_direction}
          | {:initial_value, value() | :not_set}
          | {:pull_mode, pull_mode()}

  require Logger

  @doc """
  Connect to a GPIO pin.

  Options:

  * `:pin` - any valid 'pin label' managed by `Breadboard.Pinout.label_to_pin/1`
  * `:direction` - as defined in the Circuit.GPIO.open
  * `:initial_value` - as defined in the Circuit.GPIO.open
  * `:pull_mode` - as defined in the Circuit.GPIO.open

  Return values:
  On success the function returns `{:ok, switch}`, where `switch` is the PID of the supervised 'Switch'
  """
  @spec connect(connect_options()) :: {:ok, reference()} | {:error, atom()}
  def connect(options) do
    Breadboard.Supervisor.Switch.start_child(options)
  end

  @doc """
  Set the value 1 of a switch (only for `:output` switch)
  """
  @spec turn_on(GenServer.server()) :: :ok
  def turn_on(switch) do
    GenServer.call(switch, :turn_on)
  end

  @doc """
  Set the value 0 of a switch (only for `:output` switch)
  """
  @spec turn_off(GenServer.server()) :: :ok
  def turn_off(switch) do
    GenServer.call(switch, :turn_off)
  end

  @doc """
  Read the current value of a switch
  """
  @spec get_value(GenServer.server()) :: value()
  def get_value(switch) do
    GenServer.call(switch, :get_value)
  end

  @doc """
  Set the value for a switch (only for `:output` switch)
  """
  @spec set_value(GenServer.server(), value()) :: :ok
  def set_value(switch, value) do
    GenServer.call(switch, {:set_value, value})
  end

  @doc """
  Enable or disable pin value change notifications:

  * `switch` - the switch
  * `irq_opts` - keyword list with:
    - `trigger` - as defined in `Circuits.GPIO.set_interrupts/3`
    - `opts` - as defined in `Circuits.GPIO.set_interrupts/3`
    - `interrupts_receiver` - where notifications are sent: a *function* or a *receiver*

  *interrupts_receiver*:
  * when *function*: notifications are sent invoking the specific function with a single argument: a struct of type `Breadboard.IRQInfo`
  * when *receiver*: notifications are sent by sending a message to the given destination identified by *receiver* as defined in `Kernel.send/2` in the form: `{:irq_service_call, Breadboard.IRQInfo}`

  ## Return values
  `:ok` on success
  """
  @spec set_interrupts(GenServer.server(), list()) :: :ok | {:error, atom()}
  def set_interrupts(switch, irq_opts) do
    GenServer.call(switch, {:set_interrupts, irq_opts})
  end

  @doc """
  Get the Switch pin number
  """
  @spec pin_number(GenServer.server()) :: non_neg_integer()
  def pin_number(switch) do
    GenServer.call(switch, :pin_number)
  end

  @doc """
  Get the Switch pin label
  """
  @spec pin_label(GenServer.server()) :: atom()
  def pin_label(switch) do
    GenServer.call(switch, :pin_label)
  end

  @doc """
  Change the direction of the Switch
  """
  @spec set_direction(GenServer.server(), switch_direction()) :: :ok | {:error, atom()}
  def set_direction(switch, switch_direction) do
    GenServer.call(switch, {:set_direction, switch_direction})
  end

  @doc """
  Enable/disable internal pull-up/pull-down resistor

  ## Exaple
      iex> if(Breadboard.get_platform()==:stub ) do
      iex> {:ok, switch} = Breadboard.Switch.connect([pin: :gpio18, direction: :output])
      iex> :ok = Breadboard.Switch.set_pull_mode(switch, :pullup)
      iex> nil
      iex> end
      nil

  """
  @spec set_pull_mode(GenServer.server(), pull_mode()) :: :ok | {:error, atom()}
  def set_pull_mode(switch, pull_mode) do
    GenServer.call(switch, {:set_pull_mode, pull_mode})
  end

  @doc """
  Disconnect the switch from the pin
  """
  @spec disconnect(GenServer.server()) :: :ok | {:error, :not_found}
  def disconnect(switch) do
    Breadboard.Supervisor.Switch.stop_child(switch)
  end
end

# SPDX-License-Identifier: Apache-2.0
