# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule RasaSdk.Model.ResponseRejected do
  @moduledoc """
  Action execution was rejected. This is the same as returning an &#x60;ActionExecutionRejected&#x60; event.
  """

  @derive [Jason.Encoder]
  defstruct [
    :action_name,
    :error
  ]

  @type t :: %__MODULE__{
    action_name: String.t | nil,
    error: String.t | nil
  }
end

defimpl Jason.Encoder, for: RasaSdk.Model.ResponseRejected do
  def decode(value, _options) do
    value
  end
end

