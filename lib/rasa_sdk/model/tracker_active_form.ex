defmodule RasaSDK.Model.TrackerActiveForm do
  @moduledoc """
  Name of the active form
  """

  @derive [Poison.Encoder]
  defstruct [
    :name,
    :validate,
    :rejected,
    :trigger_message
  ]

  @type t :: %__MODULE__{
               name: String.t() | nil,
               validate: boolean() | nil,
               rejected: boolean() | nil,
               trigger_message: Map | nil
             }
end

defimpl Poison.Decoder, for: RasaSDK.Model.TrackerActiveForm do
  def decode(value, _options) do
    value
  end
end
