defmodule RasaSDK.Model.EventBot do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :event,
    :timestamp,
    :text,
    :data,
    :metadata
  ]

  @type t :: %__MODULE__{
               event: String.t(),
               timestamp: integer() | nil,
               text: String.t(),
               data: [RasaSDK.Model.EventBotData] | nil,
               metadata: [Map] | nil
             }
end

defimpl Poison.Decoder, for: RasaSDK.Model.EventBot do
  import RasaSDK.Deserializer
  def decode(value, options) do
    value
    |> deserialize(:data, :struct, RasaSDK.Model.EventBotData, options)
  end
end
