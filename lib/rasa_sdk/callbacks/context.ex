defmodule RasaSDK.Callbacks.Context do
  alias RasaSDK.Model.{
    CallbackRequest,
    CallbackResponseOk,
    CallbackResponseRejected,
    CallbackResponse
  }

  require Logger

  defstruct [
    :request,
    :response,
    :error
  ]

  @type t :: %__MODULE__{
          request: CallbackRequest.t(),
          response: CallbackResponseOk.t(),
          error: CallbackResponseRejected.t() | nil
        }

  def new(request) do
    %__MODULE__{
      request: request,
      response: %CallbackResponseOk{},
      error: nil
    }
  end

  def set_response(%__MODULE__{} = context, %CallbackResponse{} = response) do
    Map.replace!(
      context,
      :response,
      %CallbackResponseOk{
        response: response
      }
    )
  end

  def set_error(%__MODULE__{} = context, error) do
    Map.replace!(context, :error, %CallbackResponseRejected{
      error: error
    })
  end
end
