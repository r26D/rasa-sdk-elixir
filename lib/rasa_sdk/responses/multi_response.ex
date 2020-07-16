defmodule RasaSDK.Responses.MultiResponse do
  @defmodule """
        This module allows you to define a single module that can generate multiple utterances.
    The name of the response the system is looking for is passed in.
  """
  alias RasaSDK.Responses.Context
  alias RasaSDK.Model.NLGResponse

  @callback names() :: list()
  @callback run(Context.t(), String.t()) :: Context.t()
  def is_response?(module) do
    RasaSDK.Responses.MultiResponse in (module.module_info(:attributes)[:behaviour] || [])
  end
  defmacro __using__(_) do
    quote do
      @behaviour RasaSDK.Responses.MultiResponse
      import RasaSDK.Responses.Context

      def names() do
        []
      end

      def preprocess(%Context{} = context, response_name), do: context
      def postprocess(%Context{} = context, response_name), do: context

      @doc """
           This is an overrideable method to make a response.
      """
      def respond(%Context{} = context, response_name) do
        case simple_text(response_name) do
          nil ->
            case attachment(context, response_name) do
              nil -> context
              attachment_contents -> context
                                     |> set_response(%NLGResponse{attachment: attachment_contents, text: ""})
            end
          value ->
            context
            |> set_response(%NLGResponse{text: value}, personality())
        end
      end

      def personality(), do: nil

      def run(%Context{} = context, response_name) do
        context
        |> preprocess(response_name)
        |> respond(response_name)
        |> postprocess(response_name)
      end

      @doc """
        This is a text response. You can override this method to make a simple response.
      """
      def simple_text(response_name), do: nil
      @doc """
        This is a special attachment - rasa doesn't support the custom field in the API - it is only triggered if there is no text set
      """
      def attachment(_context, response_name), do: nil
      defoverridable preprocess: 2,
                     postprocess: 2,
                     attachment: 2,
                     simple_text: 1,
                     names: 0,
                     personality: 0,
                     respond: 2
    end
  end
end
