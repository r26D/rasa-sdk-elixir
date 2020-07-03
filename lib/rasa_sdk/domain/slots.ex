defmodule RasaSDK.Domain.Slots do
  @moduledoc """
  This module handles getting a list of all the slots in use and outputting them in a format
  that can be used by the rasa chatbot
  """
  alias RasaSDK.Actions.{
    Registry
    }
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do

    slots = Registry.all_keys(opts)
            |> Enum.reduce(
                 %{},
                 fn {k, [{_, module}]}, acc ->
                   Map.merge(acc, module.slots_used)
                 end
               )

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(slots))
  end

end
