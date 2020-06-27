defmodule RasaSDK.Responses.Index do
  @moduledoc """
  This module handles getting a list of all the responses available and outputting them in a format
  that can be used by the rasa chatbot during training.
  """
  alias RasaSDK.Responses.Registry
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    responses = Registry.list_keys(opts)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(responses))
  end
end
