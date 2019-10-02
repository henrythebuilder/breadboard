defmodule PinoutServerTest do
  use ExUnit.Case, async: false

  alias Breadboard.GPIO.PinoutServer

  test "server is alive with application" do
    assert Process.whereis(PinoutServer.server_name() ) != nil
  end

  @tag stub_test: true
  test "simple 'stub' call" do
    assert GenServer.call(PinoutServer.server_name(), {:label_to_pin, :gpio18}) == 18

  end

  @tag sunxi_test: true
  test "simple 'sunxi' call" do
    assert GenServer.call(PinoutServer.server_name(), {:label_to_pin, :pa1}) == 1
  end

end
