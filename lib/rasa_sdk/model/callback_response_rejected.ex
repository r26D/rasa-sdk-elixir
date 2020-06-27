defmodule RasaSDK.Model.CallbackResponseRejected do
  @moduledoc """
  Callback execution was rejected. This is the same as returning an &#x60;ActionExecutionRejected&#x60; event.
  """

  @derive [Poison.Encoder]
  defstruct [
    :callback_name,
    :error
  ]

  @type t :: %__MODULE__{
          callback_name: String.t() | nil,
          error: String.t() | nil
        }
end

defimpl Poison.Decoder, for: RasaSDK.Model.CallbackResponseRejected do
  def decode(value, _options) do
    value
  end
end
