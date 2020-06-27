defmodule RasaSDK.Model.CallbackResponse do
  @moduledoc """
    This is for the response to a callback call. The documentation doesn't show if they actually do wanything with the response.
  """

  @derive [Poison.Encoder]
  defstruct [
    :message
  ]

  @type t :: %__MODULE__{
          message: String.t()
        }
end

defimpl Poison.Decoder, for: RasaSDK.Model.CallbackResponse do
  # import RasaSDK.Deserializer
  def decode(value, _options) do
    value
  end
end
