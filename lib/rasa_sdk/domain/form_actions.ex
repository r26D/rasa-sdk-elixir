defmodule RasaSDK.Domain.FormActions do
  @moduledoc """
  This module handles getting a list of all the form actions available and outputting them in a format
  that can be used by the rasa chatbot
  """
  alias RasaSDK.Actions.{
    Registry,
    FormAction
    }
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do

    actions = Registry.all_keys(opts)
              |> Enum.map(
                   fn {k, [{_, module}]} ->
                     if FormAction.is_form_action?(module), do: k, else: nil
                   end
                 )
              |> Enum.filter(&(&1 != nil))
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(actions))
  end

end
