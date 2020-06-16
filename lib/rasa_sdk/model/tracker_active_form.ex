# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule RasaSdk.Model.TrackerActiveForm do
  @moduledoc """
  Name of the active form
  """

  @derive [Jason.Encoder]
  defstruct [
    :name,
    :validate
  ]

  @type t :: %__MODULE__{
    name: String.t | nil,
    validate: boolean() | nil
  }
end

defimpl Jason.Encoder, for: RasaSdk.Model.TrackerActiveForm do
  def decode(value, _options) do
    value
  end
end

