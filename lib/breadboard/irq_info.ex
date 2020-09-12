defmodule Breadboard.IRQInfo do
  @moduledoc """
  A struct used to handle interrups notification information
  """

  defstruct pin_number: nil, timestamp: nil, new_value: nil, pin_label: nil

  @type t :: %__MODULE__{
          pin_number: pos_integer(),
          timestamp: integer(),
          new_value: 0 | 1,
          pin_label: :atom
        }
end

# SPDX-License-Identifier: Apache-2.0
