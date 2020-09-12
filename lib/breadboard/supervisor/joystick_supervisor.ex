defmodule Breadboard.Supervisor.Joystick do
  @moduledoc false

  use Breadboard.Supervisor.Base, child_module: Breadboard.Joystick.JoystickServer
end
