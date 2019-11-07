defmodule SwitchServerTest do
  use ExUnit.Case

  alias Breadboard.Switch.SwitchServer

  @tag platform_stub: true
  test "pin number and pin label" do
    {:ok, pid} = SwitchServer.start_link([pin: :gpio18, direction: :output, initial_value: 0])
    assert 18 == GenServer.call(pid, :pin_number)
    assert :gpio18 == GenServer.call(pid, :pin_label)
  end

  @tag platform_stub: true
  test "initial value 0" do
    {:ok, pid} = SwitchServer.start_link([pin: :gpio1, direction: :output, initial_value: 0])
    assert 0 == GenServer.call(pid, :get_value)
  end

  @tag platform_stub: true
  test "initial value 1" do
    {:ok, pid} = SwitchServer.start_link([pin: :gpio1, direction: :output, initial_value: 1])
    assert 1 == GenServer.call(pid, :get_value)
  end

  @tag platform_stub: true
  test "turn on/off operation" do
    {:ok, pid} = SwitchServer.start_link([pin: :gpio1, direction: :output])
    assert :ok == GenServer.call(pid, :turn_on)
    assert 1 == GenServer.call(pid, :get_value)
    assert :ok == GenServer.call(pid, :turn_off)
    assert 0 == GenServer.call(pid, :get_value)
  end

  @tag platform_stub: true
  test "turn on/off operation by 'set_value" do
    {:ok, pid} = SwitchServer.start_link([pin: :gpio1, direction: :output])
    assert :ok == GenServer.call(pid, {:set_value, 1})
    assert 1 == GenServer.call(pid, :get_value)
    assert :ok == GenServer.call(pid, {:set_value, 0})
    assert 0 == GenServer.call(pid, :get_value)
  end

  @tag platform_stub: true
  test "turn_on/off an only input pin will terminate the switch" do
    Process.flag(:trap_exit, true)
    {:ok, pid} = SwitchServer.start_link([pin: :gpio1, direction: :input])
    assert catch_exit(GenServer.call(pid, :turn_off))
    assert_receive{:EXIT, ^pid, {:pin_not_input, _}}
  end

  defmodule InterruptsTest do

    def interrupt_service_routine(_irq_info = %Breadboard.IRQInfo{}) do
      {:ok, pid_test} = SwitchServer.start_link([pin: :gpio3, direction: :output])
      GenServer.call(pid_test, :turn_on)
    end

  end

  @tag platform_stub: true
  test "Manage pin interrupts (enable/disable) by function" do
    {:ok, pid0} = SwitchServer.start_link([pin: :gpio1, direction: :input])
    {:ok, pid1} = SwitchServer.start_link([pin: :gpio1, direction: :output])
    {:ok, pid_test} = SwitchServer.start_link([pin: :gpio3, direction: :output, initial_value: 0])
    :ok = GenServer.call(pid0, {:set_interrupts, [opts: [], interrupts_receiver: &InterruptsTest.interrupt_service_routine/1, trigger: :both]})
    GenServer.call(pid1, :turn_on)
    Process.sleep(10)
    assert 1 == GenServer.call(pid_test, :get_value)
    GenServer.call(pid_test, :turn_off)
    assert 0 == GenServer.call(pid_test, :get_value)
    :ok = GenServer.call(pid0, {:set_interrupts, [trigger: :none]})
    GenServer.call(pid1, :turn_on)
    Process.sleep(10)
    assert 0 == GenServer.call(pid_test, :get_value)
  end

  @tag platform_stub: true
  test "Manage pin interrupts (enable/disable) by message" do
    {:ok, pid1} = SwitchServer.start_link([pin: :gpio1, direction: :output, initial_value: 0])
    {:ok, pid0} = SwitchServer.start_link([pin: :gpio1, direction: :input])
    :ok = GenServer.call(pid0, {:set_interrupts, [opts: [], interrupts_receiver: self(), trigger: :both]})

    # after calling set_interrupts, the calling process will receive an initial message with the state of the pin
    assert_receive {:irq_service_call, %Breadboard.IRQInfo{new_value: 0, pin_label: :gpio1, pin_number: 1}}

    GenServer.call(pid1, :turn_on)
    assert_receive {:irq_service_call, %Breadboard.IRQInfo{new_value: 1, pin_label: :gpio1, pin_number: 1}}

    GenServer.call(pid1, :turn_off)
    assert_receive {:irq_service_call, %Breadboard.IRQInfo{new_value: 0, pin_label: :gpio1, pin_number: 1}}
  end


end

# SPDX-License-Identifier: Apache-2.0
