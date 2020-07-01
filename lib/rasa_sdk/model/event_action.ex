defmodule RasaSDK.Model.EventAction do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :event,
    :timestamp,
    :name,
    :policy,
    :confidence
  ]

  @type t :: %__MODULE__{
               event: String.t(),
               timestamp: integer() | nil,
               name: String.t(),
               policy: String.t(),
               confidence: float() | nil
             }
end

defimpl Poison.Decoder, for: RasaSDK.Model.EventAction do
  def decode(value, _options) do
    value
  end
end
