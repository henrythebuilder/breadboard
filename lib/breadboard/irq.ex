defmodule Breadboard.IRQInfo do
  @moduledoc """
  A struct used to handle interrups notification information
  """

  defstruct pin_number: nil, timestamp: nil, new_value: nil, pin_label: nil

  @type t :: %__MODULE__{pin_number: pos_integer(), timestamp: integer(), new_value: 0|1 , pin_label: :atom}
end

defmodule Breadboard.IRQ do

  @moduledoc """
  A behaviour module for handle interrupts notification
  """

  @doc """
  Invoked when the pin value change based on trigger parameter
  """
  @callback interrupt_service_routine( irq_info :: Breadboard.IRQInfo.t ) :: any

  defmacro __using__(_opts) do

    quote do

      @behaviour Breadboard.IRQ

      alias Breadboard.{IRQ, IRQInfo}

    end

  end

end
