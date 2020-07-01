defmodule RasaSDK.Model.ExternalEventResponse do
  @moduledoc """
  This handles the response from the Rasa server when you trigger an external event.
  """
  alias RasaSDK.Model.{
    Message,
    Tracker
    }
  @derive [Poison.Encoder]
  defstruct [
    :messages,
    :tracker
  ]

  @type t :: %__MODULE__{
               messages: [Message] | nil,
               tracker: Tracker | nil
             }
end

defimpl Poison.Decoder, for: RasaSDK.Model.ExternalEventResponse do
  import RasaSDK.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:tracker, :struct, RasaSDK.Model.Tracker, options)
    |> deserialize(:messages, :list, RasaSDK.Model.Message, options)
  end
end
