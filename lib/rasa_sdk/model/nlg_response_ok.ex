defmodule RasaSDK.Model.NLGResponseOk do
  @moduledoc """
  Action was executed successfully.
  """
  alias RasaSDK.Model.NLGResponse

  @derive [Poison.Encoder]
  defstruct [
    :response
  ]

  @type t :: %__MODULE__{
          response: NLGResponse | nil
        }
end

defimpl Poison.Decoder, for: NLGResponseOk do
  import RasaSDK.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:reponse, :struct, RasaSDK.Model.NLGResponse, options)
  end
end
