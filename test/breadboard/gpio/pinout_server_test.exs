defmodule PinoutServerTest do
  use ExUnit.Case

  alias Breadboard.GPIO.PinoutServer

  test "server is alive with application" do
    assert Process.whereis(PinoutServer.server_name()) != nil
  end

  test "server respond to :reload_state" do
    pre_pid = Process.whereis(PinoutServer.server_name())
    GenServer.call(Breadboard.GPIO.PinoutServer.server_name(), {:reload_state})
    post_pid = Process.whereis(PinoutServer.server_name())
    refute pre_pid != post_pid
  end

  @tag platform_stub: true
  test "simple 'stub' call" do
    assert GenServer.call(PinoutServer.server_name(), {:label_to_pin, :gpio18}) == 18
  end

  @tag platform_sunxi: true
  test "simple 'sunxi' call" do
    assert GenServer.call(PinoutServer.server_name(), {:label_to_pin, :pa1}) == 1
  end
end

# SPDX-License-Identifier: Apache-2.0
