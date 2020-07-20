defmodule RasaSDK.ExternalEvents.Client do
  alias RasaSDK.Model.ExternalEventResponse
  use Tesla
  plug Tesla.Middleware.BaseUrl, get_host()
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON

  def message(conversation_id, content) do
    post("/webhooks/callback/webhook",  Jason.encode!(%{sender: conversation_id, message: content}))
  end
  def channel_message(conversation_id, channel_name, message) when is_map(message) do
    IO.puts("Going to post to /webhooks/#{channel_name}/webhook #{ Jason.encode!( message )}")
    post("/webhooks/#{channel_name}/webhook",  Jason.encode!( message |> Map.put(:sender, conversation_id)))
  end


  def external_event(conversation_id, event_name, output_channel \\ "latest", entities \\ %{}) do
    case   post(
             "/conversations/#{conversation_id}/trigger_intent",
             Jason.encode!(%{name: event_name, entities: entities}),
             query: [
               output_channel: output_channel
             ]
           ) do
      {:ok, %{body: body}} ->
        body
        |> Poison.Decode.decode(as: %ExternalEventResponse{})
      reply -> reply
    end

  end
  defp get_host() do
    host = Application.get_env(:rasa_sdk, :external_action_host, "localhost")
    port = Application.get_env(:rasa_sdk, :external_action_port, "5005")
    "http://#{host}:#{port}"
  end
end