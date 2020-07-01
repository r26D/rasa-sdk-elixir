defmodule RasaSDK.Model.EventSessionStart do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :event,
    :timestamp

  ]

  @type t :: %__MODULE__{
               event: String.t(),
               timestamp: integer() | nil

             }
end

defimpl Poison.Decoder, for: RasaSDK.Model.EventSessionStart do
  def decode(value, _options) do
    value
  end
end
