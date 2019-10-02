defmodule TestConfig do
  def exclude_test(excl) do
    case Breadboard.get_platform() do
      :stub ->
        [:platform_sunxi|excl]
      :sunxi ->
        [:platform_stub|excl]
      _ ->
        IO.warn("Breadboarding platform undefined !!!")
        [:platform_stub, :platform_sunxi|excl]
    end
  end
end

default_exclude = [:integration_sunxi]
ExUnit.start([exclude: TestConfig.exclude_test(default_exclude)])
