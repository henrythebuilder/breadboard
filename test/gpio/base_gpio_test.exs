defmodule BaseGPIOTest do
  use ExUnit.Case


  defmodule TestGPIOPin do
    use Breadboard.GPIO.BaseGPIOHelper

    @pinout_map %{
      0 => [pin_name: "GPIO0"],
      1 => [pin_name: "GPIO1", sysfs: 345],
      2 => [pin_name: "SPECIFIC_GPIO_NAME"],
      3 => [pin_name: "GPIO3", pin: 5],
      5 => [pin_name: "GPIO5", pin_key: "gpio5"],
      6 => [],
      7 => [pin_name: "gpio7"],
      8 => [pin_name: "GPIO 8"],
      44 => [pin: 44, sysfs: 444, pin_key: :pin_44, pin_label: :gpio_44, pin_name: "GPIO_44"]
    }

    def pinout_definition(), do: @pinout_map

    def pin_to_sysfs_pin(pin_number, info) do
      pin_number
    end

  end

  defmodule TestGPIO do

    @pinout_map TestGPIOPin.build_pinout_map()

    use Breadboard.GPIO.BaseGPIO

    def pinout_map(), do: @pinout_map

  end

  test "helper module test" do

    expected_pinout = %{
     {:pin, 0}            => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:sysfs, 0}          => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:pin_key, :pin0}    => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:pin_label, :gpio0} => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],
     {:pin_name, "GPIO0"} => [pin: 0, sysfs: 0, pin_key: :pin0, pin_label: :gpio0, pin_name: "GPIO0"],

     {:pin, 1}            => [pin: 1, sysfs: 345, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:sysfs, 345}          => [pin: 1, sysfs: 345, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:pin_key, :pin1}    => [pin: 1, sysfs: 345, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:pin_label, :gpio1} => [pin: 1, sysfs: 345, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],
     {:pin_name, "GPIO1"} => [pin: 1, sysfs: 345, pin_key: :pin1, pin_label: :gpio1, pin_name: "GPIO1"],

     {:pin, 2}            => [pin: 2, sysfs: 2, pin_key: :pin2, pin_label: :specific_gpio_name, pin_name: "SPECIFIC_GPIO_NAME"],
     {:sysfs, 2}          => [pin: 2, sysfs: 2, pin_key: :pin2, pin_label: :specific_gpio_name, pin_name: "SPECIFIC_GPIO_NAME"],
     {:pin_key, :pin2}    => [pin: 2, sysfs: 2, pin_key: :pin2, pin_label: :specific_gpio_name, pin_name: "SPECIFIC_GPIO_NAME"],
     {:pin_label, :specific_gpio_name} => [pin: 2, sysfs: 2, pin_key: :pin2, pin_label: :specific_gpio_name, pin_name: "SPECIFIC_GPIO_NAME"],
     {:pin_name, "SPECIFIC_GPIO_NAME"} => [pin: 2, sysfs: 2, pin_key: :pin2, pin_label: :specific_gpio_name, pin_name: "SPECIFIC_GPIO_NAME"],

     {:pin, 3}            => [pin: 3, sysfs: 3, pin_key: :pin3, pin_label: :gpio3, pin_name: "GPIO3"],
     {:sysfs, 3}          => [pin: 3, sysfs: 3, pin_key: :pin3, pin_label: :gpio3, pin_name: "GPIO3"],
     {:pin_key, :pin3}    => [pin: 3, sysfs: 3, pin_key: :pin3, pin_label: :gpio3, pin_name: "GPIO3"],
     {:pin_label, :gpio3} => [pin: 3, sysfs: 3, pin_key: :pin3, pin_label: :gpio3, pin_name: "GPIO3"],
     {:pin_name, "GPIO3"} => [pin: 3, sysfs: 3, pin_key: :pin3, pin_label: :gpio3, pin_name: "GPIO3"],

     {:pin, 44}            => [pin: 44, sysfs: 444, pin_key: :pin_44, pin_label: :gpio_44, pin_name: "GPIO_44"],
     {:sysfs, 444}          => [pin: 44, sysfs: 444, pin_key: :pin_44, pin_label: :gpio_44, pin_name: "GPIO_44"],
     {:pin_key, :pin_44}    => [pin: 44, sysfs: 444, pin_key: :pin_44, pin_label: :gpio_44, pin_name: "GPIO_44"],
     {:pin_label, :gpio_44} => [pin: 44, sysfs: 444, pin_key: :pin_44, pin_label: :gpio_44, pin_name: "GPIO_44"],
     {:pin_name, "GPIO_44"} => [pin: 44, sysfs: 444, pin_key: :pin_44, pin_label: :gpio_44, pin_name: "GPIO_44"],

     {:pin, 5}            => [pin: 5, sysfs: 5, pin_key: "gpio5", pin_label: :gpio5, pin_name: "GPIO5"],
     {:sysfs, 5}          => [pin: 5, sysfs: 5, pin_key: "gpio5", pin_label: :gpio5, pin_name: "GPIO5"],
     {:pin_key, "gpio5"}    => [pin: 5, sysfs: 5, pin_key: "gpio5", pin_label: :gpio5, pin_name: "GPIO5"],
     {:pin_label, :gpio5} => [pin: 5, sysfs: 5, pin_key: "gpio5", pin_label: :gpio5, pin_name: "GPIO5"],
     {:pin_name, "GPIO5"} => [pin: 5, sysfs: 5, pin_key: "gpio5", pin_label: :gpio5, pin_name: "GPIO5"],

     {:pin, 6}            => [pin: 6, sysfs: 6, pin_key: :pin6, pin_label: :gpio6, pin_name: "GPIO6"],
     {:sysfs, 6}          => [pin: 6, sysfs: 6, pin_key: :pin6, pin_label: :gpio6, pin_name: "GPIO6"],
     {:pin_key, :pin6}    => [pin: 6, sysfs: 6, pin_key: :pin6, pin_label: :gpio6, pin_name: "GPIO6"],
     {:pin_label, :gpio6} => [pin: 6, sysfs: 6, pin_key: :pin6, pin_label: :gpio6, pin_name: "GPIO6"],
     {:pin_name, "GPIO6"} => [pin: 6, sysfs: 6, pin_key: :pin6, pin_label: :gpio6, pin_name: "GPIO6"],

    {:pin, 7}            => [pin: 7, sysfs: 7, pin_key: :pin7, pin_label: :gpio7, pin_name: "gpio7"],
     {:sysfs, 7}          => [pin: 7, sysfs: 7, pin_key: :pin7, pin_label: :gpio7, pin_name: "gpio7"],
     {:pin_key, :pin7}    => [pin: 7, sysfs: 7, pin_key: :pin7, pin_label: :gpio7, pin_name: "gpio7"],
     {:pin_label, :gpio7} => [pin: 7, sysfs: 7, pin_key: :pin7, pin_label: :gpio7, pin_name: "gpio7"],
     {:pin_name, "gpio7"} => [pin: 7, sysfs: 7, pin_key: :pin7, pin_label: :gpio7, pin_name: "gpio7"],

     {:pin, 8}            => [pin: 8, sysfs: 8, pin_key: :pin8, pin_label: :"gpio 8", pin_name: "GPIO 8"],
     {:sysfs, 8}          => [pin: 8, sysfs: 8, pin_key: :pin8, pin_label: :"gpio 8", pin_name: "GPIO 8"],
     {:pin_key, :pin8}    => [pin: 8, sysfs: 8, pin_key: :pin8, pin_label: :"gpio 8", pin_name: "GPIO 8"],
     {:pin_label, :"gpio 8"} => [pin: 8, sysfs: 8, pin_key: :pin8, pin_label: :"gpio 8", pin_name: "GPIO 8"],
     {:pin_name, "GPIO 8"} => [pin: 8, sysfs: 8, pin_key: :pin8, pin_label: :"gpio 8", pin_name: "GPIO 8"],
    }

    Enum.each(expected_pinout, fn{key, value} ->
      test_info = Map.get(TestGPIO.pinout_map(), key)
      refute(test_info == nil, "Error on fetch key #{inspect key} on test value, got nil")
      assert(Keyword.equal?(value, test_info))
    end)

  end

end
