defmodule Breadboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      %{
        id: Breadboard.GPIO.PinoutServer,
        start: {Breadboard.GPIO.PinoutServer, :start_link, []}
      },
      %{
        id: Breadboard.Supervisor.Switch,
        start: {Breadboard.Supervisor.Switch, :start_link, []}
      },
      %{
        id: Breadboard.Supervisor.Joystick ,
        start: {Breadboard.Supervisor.Joystick, :start_link, []}
      },
      # Starts a worker by calling: Breadboard.Worker.start_link(arg)
      # {Breadboard.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Breadboard.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# SPDX-License-Identifier: Apache-2.0
