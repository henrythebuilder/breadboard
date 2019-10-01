defmodule Breadboard.Switch do

  @moduledoc """
  This module manage the 'switch' operation on gpio.
  Any switch is supervised in the application

  ## Examples (for the default 'stub' reference)

      iex> Breadboard.set_platform(:stub)
      iex> {:ok, switch} = Breadboard.Switch.connect([pin: :gpio18, direction: :output])
      iex> Breadboard.Switch.turn_on(switch)
      :ok
      iex> Breadboard.Switch.get_value(switch)
      1

  ### switch with initial value

      iex> Breadboard.set_platform(:stub)
      iex> {:ok, switch1} = Breadboard.Switch.connect([pin: :gpio18, direction: :output, initial_value: 1])
      iex> {:ok, switch0} = Breadboard.Switch.connect([pin: "GPIO9", direction: :output, initial_value: 0])
      iex> Breadboard.Switch.get_value(switch0)
      0
      iex> Breadboard.Switch.get_value(switch1)
      1

  ### switch as input and output (Stub HAL with pair of GPIOs is connected)
      iex> if(Circuits.GPIO.info.name==:stub) do # only for Unit Test purpose
      ...> Breadboard.set_platform(:stub)
      ...> {:ok, switch0} = Breadboard.Switch.connect([pin: :gpio0, direction: :output, initial_value: 0])
      ...> {:ok, switch1} = Breadboard.Switch.connect([pin: :gpio1, direction: :input, initial_value: 0])
      ...> Breadboard.Switch.get_value(switch0)
      ...> Breadboard.Switch.get_value(switch1)
      ...> Breadboard.Switch.turn_on(switch0)
      ...> Breadboard.Switch.get_value(switch1)
      ...> end
      1

  ### Simple Interrupt test: open two pin as in and out plus a pin as test raised to one on irq notification
      iex> if(Circuits.GPIO.info.name==:stub) do # only for Unit Test purpose
      ...>   Breadboard.set_platform(:stub)
      ...>   defmodule InterruptsTest do
      ...>     use Breadboard.IRQ
      ...>     def interrupt_service_routine(_irq_info) do
      ...>       # on interrupt turn on 'test pin' value
      ...>       {:ok, switch_test} = Breadboard.Switch.connect([pin: :gpio3, direction: :output])
      ...>       Breadboard.Switch.turn_on(switch_test)
      ...>     end
      ...>   end
      ...>   {:ok, switch_in} = Breadboard.Switch.connect([pin: :gpio1, direction: :input])
      ...>   {:ok, switch_out} = Breadboard.Switch.connect([pin: :gpio1, direction: :output])
      ...>   {:ok, switch_test} = Breadboard.Switch.connect([pin: :gpio3, direction: :output, initial_value: 0])
      ...>   # pin value is 0
      ...>   0 = Breadboard.Switch.get_value(switch_test)
      ...>   :ok = Breadboard.Switch.set_interrupts(switch_in, [module: InterruptsTest, trigger: :both, opts: []])
      ...>   Breadboard.Switch.turn_on(switch_out)
      ...>   Process.sleep(50)
      ...>   Breadboard.Switch.get_value(switch_test)
      ...> end
      1

  ### turn_on/off an only input pin will terminate the switch

  """


  @doc """
  Connect to a pin.

  ## Options:
  * :pin - any valid 'pin label' managed by Pinout.label_to_pin
  * :direction - as defined in the Circuit.GPIO.open
  * :initial_value - as defined in the Circuit.GPIO.open

  ## Return values
  On success the function returns `{:ok, pid}`, where `pid` is the PID of the supervised 'switch'
  """
  def connect(options) do
    Breadboard.DynamicSupervisor.start_switch_server_child(options)
  end

  @doc """
  Set the value 1 of a switch
  """
  def turn_on(pid) do
    GenServer.call(pid, :turn_on)
  end

  @doc """
  Set the value 0 of a switch
  """
  def turn_off(pid) do
    GenServer.call(pid, :turn_off)
  end

  @doc """
  Read the current value of a switch
  """
  def get_value(pid) do
    GenServer.call(pid, :get_value)
  end

  @doc """
  Enable or disable pin value change notifications:

  ## Args
  * `pid` - the switch
  and key list with:
  * `trigger` - as defined in Circuits.GPIO.set_interrupts
  * `opts` - as defined in Circuits.GPIO.set_interrupts
  * `module` - module where notifications are sent by required specific function signatures defined into `Breadboard.IRQ`

  ## Return values
  :ok on success
  """
  def set_interrupts(pid, irq_opts) do
    GenServer.call(pid, {:set_interrupts, irq_opts})
  end

  @doc """
  Disconnect the switch
  """
  def disconnect(pid) do
    Breadboard.DynamicSupervisor.stop_switch_server_child(pid)
  end


end
