defmodule SunxiJoystickTest do
  use ExUnit.Case

  alias Breadboard.{Joystick}

  @tag integration_sunxi_joystick: true
  test "Simple test for a default joystick integration" do
    {:ok, joystick} = Joystick.connect(i2c_bus_name: "i2c-0")

    read_values =
      Enum.map(
        1..60,
        fn n ->
          Process.sleep(500)
          values = Joystick.get_values(joystick)
          IO.puts("Joystick values (#{n}): #{inspect(values)}")
          [n, values]
        end
      )

    check =
      Enum.all?(read_values, fn [_n, value] ->
        keys = Keyword.keys(value)
        IO.puts(inspect(keys))
        Keyword.equal?(keys, [:x_axis, :y_axis, :push_button])
      end)

    assert check == true
  end
end
