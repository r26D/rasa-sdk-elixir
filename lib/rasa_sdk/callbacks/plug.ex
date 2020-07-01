defmodule RasaSDK.Callbacks.Plug do
  @moduledoc """
  The rasa client can be configured to do call back - this module process those requests
  https://rasa.com/docs/rasa/user-guide/connectors/your-own-website/#rest-channels
  This ended up here instead of the Sdk because it is processing the same data that the Sdk generates.
  """
  import Plug.Conn
  alias RasaSDK.Callbacks.Context
  require Logger

  def init(opts), do: opts

  def call(%Plug.Conn{body_params: body_params} = conn, handler_module: handler_module) do
    context =
      body_params
      |> Poison.Decode.decode(as: %RasaSDK.Model.CallbackRequest{})
      |> Context.new()

    try do
      send_response(conn, handler_module.run(context))
    rescue
      error ->
        formatted_error = Exception.format(:error, error, __STACKTRACE__)

        Logger.error(
          "Callback failed with reason: #{formatted_error}"
        )

        context =
          context
          |> Context.set_error( Exception.message(error))

        send_response(conn, context)
    end
  end

  defp send_response(conn, %Context{response: response, error: nil}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(response))
  end

  defp send_response(conn, %Context{error: error}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Poison.encode!(error))
  end
end
