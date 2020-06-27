# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule RasaSDK.Model.ButtonResponse do
  @moduledoc """
  Text with buttons which should be sent to the user.
  """
  alias RasaSDK.Model.Button

  @derive [Poison.Encoder]
  defstruct [
    :text,
    :buttons
  ]

  @type t :: %__MODULE__{
          text: String.t() | nil,
          buttons: [Button] | nil
        }
end

defimpl Poison.Decoder, for: RasaSDK.Model.ButtonResponse do
  import RasaSDK.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:buttons, :list, RasaSDK.Model.Button, options)
  end
end
