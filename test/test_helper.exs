defmodule TestConfig do
  @default_exclude [:integration_sunxi]

  def exclude_test() do
    excl = @default_exclude
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

  def after_suite_callback(res) do
    Breadboard.disconnect_all_gpios()
    IO.puts(inspect(res))
  end
end

ExUnit.after_suite(&TestConfig.after_suite_callback/1)

ExUnit.start([exclude: TestConfig.exclude_test()])


# SPDX-License-Identifier: Apache-2.0
