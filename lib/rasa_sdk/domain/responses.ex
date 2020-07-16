defmodule RasaSDK.Domain.Responses do
  @moduledoc """
  This module handles getting a list of all the responses available and outputting them in a format
  that can be used by the rasa chatbot during training.
  """
  alias RasaSDK.Responses.{
    Response,
    MultiResponse,
    Registry}
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do

    responses = Registry.all_keys(opts)
                |> Enum.reduce(
                     %{},
                     fn {k, [{_, module}]}, acc ->
                       cond do
                         Response.is_response?(module) ->
                           Map.merge(acc, %{"#{k}" => [%{text: module.simple_text() || "Place Holder Text"}]})
                         MultiResponse.is_response?(module) ->
                           Map.merge(acc, %{"#{k}" => [%{text: module.simple_text(k) || "Place Holder Text"}]})
                         true -> nil
                       end

                     end
                   )


    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(responses))
  end
end
