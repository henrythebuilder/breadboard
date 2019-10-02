defmodule TestConfig do
  def exclude_test() do
    case Breadboard.get_platform() do
      :stub ->
        [:platform_sunxi]
      :sunxi ->
        [:platform_stub]
      _ ->
        IO.warn("Breadboarding platform undefined !!!")
        [:platform_stub, :platform_sunxi]
    end
  end
end

ExUnit.start([exclude: TestConfig.exclude_test])
