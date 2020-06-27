defmodule RasaSDK.Model.CallbackResponseOk do
  @moduledoc """
  Action was executed successfully.
  """
  alias RasaSDK.Model.CallbackResponse

  @derive [Poison.Encoder]
  defstruct [
    :response
  ]

  @type t :: %__MODULE__{
          response: CallbackResponse | nil
        }
end

defimpl Poison.Decoder, for: CallbackResponseOk do
  import RasaSDK.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:CallbackResponse, :struct, RasaSDK.Model.CallbackResponse, options)
  end
end
