defmodule TestConfig do
  def exclude_test() do
    case Breadboard.GPIO.Utils.get_platform() do
      :stub ->
        [:sunxi_test]
      :sunxi ->
        [:stub_test]
      _ ->
        IO.warn("Breadboarding platform undefined !!!")
        [:stub_test, :sunxi_test]
    end
  end
end

ExUnit.start([exclude: TestConfig.exclude_test])
