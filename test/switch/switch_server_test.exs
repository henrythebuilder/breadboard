defmodule SwitchServerTest do
  use ExUnit.Case, async: false

  alias Breadboard.Switch.SwitchServer

  setup_all do
    Breadboard.set_platform(:stub)
  end

  test "initial value 0" do
    {:ok, pid} = SwitchServer.start_link([pin: :gpio1, direction: :output, initial_value: 0])
    assert 0 == GenServer.call(pid, :get_value)
  end

  test "initial value 1" do
    {:ok, pid} = SwitchServer.start_link([pin: :gpio1, direction: :output, initial_value: 1])
    assert 1 == GenServer.call(pid, :get_value)
  end

  test "turn on/off operation" do
    {:ok, pid} = SwitchServer.start_link([pin: :gpio1, direction: :output])
    assert :ok == GenServer.call(pid, :turn_on)
    assert 1 == GenServer.call(pid, :get_value)
    assert :ok == GenServer.call(pid, :turn_off)
    assert 0 == GenServer.call(pid, :get_value)
  end

  test "turn_on/off an only input pin will terminate the switch" do
    Process.flag(:trap_exit, true)
    {:ok, pid} = SwitchServer.start_link([pin: :gpio1, direction: :input])
    assert catch_exit(GenServer.call(pid, :turn_off))
    assert_receive{:EXIT, ^pid, {:pin_not_input, _}}
  end


end
