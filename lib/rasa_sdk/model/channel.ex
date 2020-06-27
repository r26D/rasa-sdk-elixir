defmodule RasaSDK.Model.Channel do
  @moduledoc """
  This is the channel being used for the communication - important if you are talking to slack
  or something that requires different output formats
  """

  @derive [Poison.Encoder]
  defstruct [
    :name
  ]

  @type t :: %__MODULE__{
          name: String.t() | nil
        }
end

defimpl Poison.Decoder, for: RasaSDK.Model.Channel do
  def decode(value, _options) do
    value
  end
end
