defmodule Breadboard.Supervisor.Switch do

  @moduledoc false

  use Breadboard.Supervisor.Base, [child_module: Breadboard.Switch.SwitchServer]

end
