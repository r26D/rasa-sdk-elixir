# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule RasaSDK.Model.Domain do
  @moduledoc """
  The bot&#39;s domain.
  """
  alias RasaSDK.Model.DomainConfig
  alias RasaSDK.Model.SlotDescription
  alias RasaSDK.Model.TemplateDescription

  @derive [Poison.Encoder]
  defstruct [
    :config,
    :intents,
    :entities,
    :slots,
    :responses,
    :actions
  ]

  @type t :: %__MODULE__{
          config: DomainConfig | nil,
          intents: [Map] | nil,
          entities: [String.t()] | nil,
          slots: %{optional(String.t()) => SlotDescription} | nil,
          responses: %{optional(String.t()) => TemplateDescription} | nil,
          actions: [String.t()] | nil
        }
end

defimpl Poison.Decoder, for: RasaSDK.Model.Domain do
  import RasaSDK.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:config, :struct, RasaSDK.Model.DomainConfig, options)
    |> deserialize(:slots, :map, RasaSDK.Model.SlotDescription, options)
    |> deserialize(:responses, :map, RasaSDK.Model.TemplateDescription, options)
  end
end
