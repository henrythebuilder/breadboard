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

  ### turn_on/off an only input pin will terminate the switch

  """


  @doc """
  Connect to a pin.

  Options:
  * :pin - any valid 'pin label' managed by Pinout.label_to_pin
  * :direction - as defined in the Circuit.GPIO.open
  * :initial_value - as defined in the Circuit.GPIO.open
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
  Disconnect the switch
  """
  def disconnect(pid) do
    Breadboard.DynamicSupervisor.stop_switch_server_child(pid)
  end


end
