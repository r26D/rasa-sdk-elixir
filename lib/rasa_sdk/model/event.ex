defmodule RasaSDK.Model.Event do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :event,
    :timestamp,
    :name,
    :policy,
    :confidence,
    :text,
    :data,
    :parse_data,
    :input_channel,

  ]

  @type t :: %__MODULE__{
               event: String.t(),
               timestamp: integer() | nil
             }

  def deserialize_events(model, field, options) do
    model
    |> Map.update!(
          field,
          fn list -> list
            |> Enum.map(&Poison.Decode.decode(&1,Keyword.merge(options, as: struct(mod_name(&1)))))
          end
       )
  end
  def mod_name(%{"event" => "action"}), do: RasaSDK.Model.EventAction
  def mod_name(%{"event" => "bot"}), do: RasaSDK.Model.EventBot
  def mod_name(%{"event" => "follow_up"}), do: RasaSDK.Model.EventFollowUp
  def mod_name(%{"event" => "form"}), do: RasaSDK.Model.EventForm
  def mod_name(%{"event" => "session_start"}), do: RasaSDK.Model.EventSessionStart
  def mod_name(%{"event" => "slot"}), do: RasaSDK.Model.EventSlot
  def mod_name(%{"event" => "user"}), do: RasaSDK.Model.EventUser
  def mod_name(%{}), do: RasaSDK.Model.Event

end

defimpl Poison.Decoder, for: RasaSDK.Model.Event do
  def decode(value, _options) do
    value
  end
end
