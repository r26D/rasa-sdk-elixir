defmodule RasaSDK.Model.NLGResponseRejected do
  @moduledoc """
  Response execution was rejected. This is the same as returning an &#x60;ActionExecutionRejected&#x60; event.
  """

  @derive [Poison.Encoder]
  defstruct [
    :response_name,
    :error
  ]

  @type t :: %__MODULE__{
          response_name: String.t() | nil,
          error: String.t() | nil
        }
end

defimpl Poison.Decoder, for: RasaSDK.Model.NLGResponseRejected do
  def decode(value, _options) do
    value
  end
end
