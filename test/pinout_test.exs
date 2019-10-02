defmodule PinoutTest do
  use ExUnit.Case, async: false

  if(Breadboard.get_platform()==:stub ) do
    doctest Breadboard.Pinout
  end

end
