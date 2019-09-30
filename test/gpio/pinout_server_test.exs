defmodule PinoutServerTest do
  use ExUnit.Case, async: false

  alias Breadboard.GPIO.PinoutServer

  test "server is alive with application" do
    assert Process.whereis(PinoutServer.server_name() ) != nil
  end

  test "check platform configuration" do
    Breadboard.set_platform(:stub)
    assert Breadboard.GPIO.Utils.get_platform() == :stub
    Breadboard.set_platform(:sunxi)
    assert Breadboard.GPIO.Utils.get_platform() == :sunxi
  end

  test "simple 'stub' call" do
    Breadboard.set_platform(:stub)
    assert GenServer.call(PinoutServer.server_name(), {:label_to_pin, :gpio18}) == 18

  end

  test "simple 'sunxi' call" do
    Breadboard.set_platform(:sunxi)
    assert GenServer.call(PinoutServer.server_name(), {:label_to_pin, :pa1}) == 1
  end


end
