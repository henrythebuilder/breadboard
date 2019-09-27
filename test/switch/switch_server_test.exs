defmodule SwitchServerTest do
  use ExUnit.Case

  alias Breadboard.Switch.SwitchServer

  test "turn on/off operation" do
    {:ok, pid} = SwitchServer.start_link([pin: :gpio1, mode: :output])
    assert :ok == GenServer.call(pid, :turn_on)
    assert 1 == GenServer.call(pid, :get_value)
    assert :ok == GenServer.call(pid, :turn_off)
    assert 0 == GenServer.call(pid, :get_value)
  end

end
