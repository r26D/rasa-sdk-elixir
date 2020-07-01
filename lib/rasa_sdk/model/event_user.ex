defmodule RasaSDK.Model.EventUser do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :event,
    :timestamp,
    :text,
    :input_channel,
    :message_id,
    :parse_data,
    :metadata
  ]

  @type t :: %__MODULE__{
               event: String.t(),
               timestamp: integer() | nil,
               text: String.t(),
               input_channel: String.t(),
               message_id: String.t(),
               parse_data: [RasaSDK.Model.ParseResult] | nil,
               metadata: [Map] | nil
             }
end

defimpl Poison.Decoder, for: RasaSDK.Model.EventUser do
  import RasaSDK.Deserializer
  def decode(value, options) do
    value
    |> deserialize(:parse_data, :struct, RasaSDK.Model.ParseResult, options)
  end
end
