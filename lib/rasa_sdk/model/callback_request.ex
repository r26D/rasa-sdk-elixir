defmodule RasaSDK.Model.CallbackRequest do
  @moduledoc """

  """
  alias RasaSDK.Model.{
    Button,
    Attachment,
    Element
  }

  # DJE - it isn't clear if you can return multiple text and have Rasa pick
  @derive [Poison.Encoder]
  defstruct [
    :recipient_id,
    :text,
    :image,
    :elements,
    :attachments,
    :buttons
  ]

  @type t :: %__MODULE__{
          recipient_id: String.t(),
          text: String.t(),
          image: String.t(),
          elements: [Element] | nil,
          attachments: [Attachment] | nil,
          buttons: [Button] | nil
        }
end

defimpl Poison.Decoder, for: RasaSDK.Model.CallbackRequest do
  import RasaSDK.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:buttons, :list, RasaSDK.Model.Button, options)
    |> deserialize(:elements, :list, RasaSDK.Model.Element, options)
    |> deserialize(:attachments, :list, RasaSDK.Model.Attachment, options)
  end
end
