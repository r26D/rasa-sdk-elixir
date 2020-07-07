defmodule RasaSDK.Responses.Response do
  alias RasaSDK.Responses.Context
  alias RasaSDK.Model.NLGResponse

  @callback name() :: String.t()
  @callback run(Context.t()) :: Context.t()
  def is_response?(module) do
    RasaSDK.Responses.Response in (module.module_info(:attributes)[:behaviour] || [])
  end
  defmacro __using__(_) do
    quote do
      @behaviour RasaSDK.Responses.Response
      import RasaSDK.Responses.Context

      def name() do
        "#{__MODULE__}"
        |> String.split(".")
        |> Enum.reverse()
        |> Enum.at(0)
        |> Macro.underscore()
      end

      def preprocess(%Context{} = context), do: context
      def postprocess(%Context{} = context), do: context

      @doc """
           This is an overrideable method to make a response.
      """
      def respond(%Context{} = context) do
      case simple_text() do
          nil ->
            case attachment(context) do
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

      def run(%Context{} = context) do
        context
        |> preprocess()
        |> respond()
        |> postprocess()
      end

      @doc """
        This is a text response. You can override this method to make a simple response.
      """
      def simple_text(), do: nil
      @doc """
        This is a special attachment - rasa doesn't support the custom field in the API - it is only triggered if there is no text set
      """
      def attachment(_context), do: nil
      defoverridable preprocess: 1,
                     postprocess: 1,
                     attachment: 1,
                     simple_text: 0,
                     name: 0,
                     personality: 0,
                     respond: 1
    end
  end
end
