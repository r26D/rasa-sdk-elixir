defmodule RasaSDK.Model.EventBotData do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :elements,
    :quick_replies,
    :buttons,
    :attachments,
    :image,
    :custom
  ]

end

defimpl Poison.Decoder, for: RasaSDK.Model.EventBotData do
  def decode(value, _options) do

    value
  end
end
