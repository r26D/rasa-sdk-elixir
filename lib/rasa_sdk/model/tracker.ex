defmodule RasaSDK.Model.Tracker do
  @moduledoc """
  Conversation tracker which stores the conversation state.
  """
  alias RasaSDK.Model.ParseResult
  alias RasaSDK.Model.Event
  alias RasaSDK.Model.TrackerActiveForm

  @derive [Poison.Encoder]
  defstruct [
    :conversation_id,
    :sender_id,
    :slots,
    :latest_message_metadata,
    :latest_message,
    :latest_event_time,
    :followup_action,
    :paused,
    :events,
    :latest_input_channel,
    :latest_action_name,
    :active_form
  ]

  @type t :: %__MODULE__{
          conversation_id: String.t() | nil,
          sender_id: String.t() | nil,
          slots: [Map] | nil,
          latest_message_metadata: [Map] | nil, #experimental field DJE
          latest_message: ParseResult | nil,
          latest_event_time: float() | nil,
          followup_action: String.t() | nil,
          paused: boolean() | nil,
          events: [Event] | nil,
          latest_input_channel: String.t() | nil,
          latest_action_name: String.t() | nil,
          active_form: TrackerActiveForm | nil
        }
end

defimpl Poison.Decoder, for: RasaSDK.Model.Tracker do
  import RasaSDK.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:latest_message_metadata, :map, options)
    |> deserialize(:latest_message, :struct, RasaSDK.Model.ParseResult, options)
    |>  RasaSDK.Model.Event.deserialize_events(:events, options)
    |> deserialize(:active_form, :struct, RasaSDK.Model.TrackerActiveForm, options)
  end


end
