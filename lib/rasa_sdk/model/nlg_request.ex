defmodule RasaSDK.Model.NLGRequest do
  @moduledoc """
  Describes the action to be called and provides information on the current state of the conversation.
  """
  alias RasaSDK.Model.{
    Channel,
    Tracker
  }

  @derive [Poison.Encoder]
  defstruct [
    :arguments,
    :channel,
    :template,
    :tracker
  ]

  @type t :: %__MODULE__{
          arguments: [Map] | nil,
          channel: Channel | nil,
          template: String.t() | nil,
          tracker: Tracker | nil
        }
end

defimpl Poison.Decoder, for: RasaSDK.Model.NLGRequest do
  import RasaSDK.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:arguments, :map, options)
    |> deserialize(:channel, :struct, RasaSDK.Model.Channel, options)
    |> deserialize(:tracker, :struct, RasaSDK.Model.Tracker, options)
  end
end
