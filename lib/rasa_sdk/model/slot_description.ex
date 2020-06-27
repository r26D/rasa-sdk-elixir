defmodule RasaSDK.Model.SlotDescription do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :auto_fill,
    :initial_value,
    :type,
    :values
  ]

  @type t :: %__MODULE__{
          auto_fill: boolean(),
          initial_value: String.t() | nil,
          type: String.t(),
          values: [String.t()] | nil
        }
end

defimpl Poison.Decoder, for: RasaSDK.Model.SlotDescription do
  def decode(value, _options) do
    value
  end
end
