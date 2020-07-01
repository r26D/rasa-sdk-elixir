defmodule RasaSDK.Model.EventSlot do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :event,
    :timestamp,
    :name,
    :value
  ]

  @type t :: %__MODULE__{
               event: String.t(),
               timestamp: integer() | nil,
               name: String.t()
             }
end

defimpl Poison.Decoder, for: RasaSDK.Model.EventSlot do
  def decode(value, _options) do
    value
  end
end
