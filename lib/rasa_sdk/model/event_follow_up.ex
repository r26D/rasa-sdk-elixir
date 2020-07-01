defmodule RasaSDK.Model.EventFollowUp do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :event,
    :timestamp,
    :name

  ]

  @type t :: %__MODULE__{
               event: String.t(),
               name: String.t(),
               timestamp: integer() | nil
             }
end

defimpl Poison.Decoder, for: RasaSDK.Model.EventFollowUp do
  def decode(value, _options) do
    value
  end
end
