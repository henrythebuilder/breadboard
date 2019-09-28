defmodule SwitchTest do
  use ExUnit.Case

  if(Breadboard.GPIO.Utils.get_platform()==:stub) do
    doctest Breadboard.Switch
  end

end
