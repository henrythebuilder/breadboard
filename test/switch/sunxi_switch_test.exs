defmodule SunxiSwitchTest do
  use ExUnit.Case

  alias Breadboard.{Switch}

  @tag integration_sunxi: true
  test "Simple irq test with an external switch and interrupt: PA1 value is reflected to PA20 (a led)" do

    defmodule IRQSwitch do
      use Breadboard.IRQ
      alias Breadboard.{Switch}

      def interrupt_service_routine(irq_info = %IRQInfo{pin_number: pin_number, timestamp: timestamp, new_value: new_value, pin_label: pin_label}) do
        # on interrupt turn on/off 'test pin' value
        IO.puts("irq info='#{inspect(irq_info)}")
        {:ok, switch_test} = Switch.connect([pin: :pa20, direction: :output])
        case new_value do
          1 ->
            Switch.turn_on(switch_test)
          0 ->
            Switch.turn_off(switch_test)
        end
        ^new_value = Switch.get_value(switch_test)
      end
    end

    {:ok, switch_in} = Switch.connect([pin: :pa1, direction: :input])
    :ok = Switch.set_interrupts(switch_in, [module: IRQSwitch, trigger: :both, opts: []])
    IO.puts("Press button on breadboard connected to pin PA1")
    IO.gets("Return to exit")

  end


end
