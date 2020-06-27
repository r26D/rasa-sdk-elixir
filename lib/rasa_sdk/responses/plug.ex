defmodule RasaSDK.Responses.Plug do
  import Plug.Conn
  alias RasaSDK.Responses.{Context, Registry}

  alias RasaSDK.Model.{
    NLGResponse,
    NLGResponseOk,
    NLGRequest
  }

  require Logger

  def init(options) do
    # initialize options
    options
  end

  def call(%Plug.Conn{body_params: body_params} = conn, opts) do
    context =
      body_params
      |> Poison.Decode.decode(as: %NLGRequest{})
      |> Context.new()

    #   IO.inspect(context.request)
    #      IO.puts("<<<< Slots >>>>")
    #      IO.inspect(context |> Context.current_slot_values)
    try do
      send_response(conn, Registry.execute(context, opts))
    rescue
      error ->
        formatted_error = Exception.format(:error, error, __STACKTRACE__)

        Logger.error(
          "Response #{context.request.template} failed with reason: #{formatted_error}"
        )

        context =
          context
          |> Context.set_error(context.request.template, Exception.message(error))

        send_response(conn, context)
    end
  end

  defp send_response(
         conn,
         %Context{
           response: %NLGResponseOk{
             response: %NLGResponse{} = response
           },
           error: nil
         }
       ) do
    #  IO.inspect(response)
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
