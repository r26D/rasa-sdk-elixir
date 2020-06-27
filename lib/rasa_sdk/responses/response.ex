defmodule RasaSDK.Responses.Response do
  alias RasaSDK.Responses.Context
  alias RasaSDK.Model.NLGResponse

  @callback name() :: String.t()
  @callback run(Context.t()) :: Context.t()

  defmacro __using__(_) do
    quote do
      @behaviour RasaSDK.Responses.Response
      import RasaSDK.Responses.Context

      def name() do
        "#{__MODULE__}" |> String.split(".") |> Enum.reverse() |> Enum.at(0) |> Macro.underscore()
      end

      def preprocess(%Context{} = context), do: context
      def postprocess(%Context{} = context), do: context

      @doc """
          This is an overrideable method to make a response.
      """
      def respond(%Context{} = context) do
        case simple_text() do
          nil ->
            context

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

      defoverridable preprocess: 1,
                     postprocess: 1,
                     simple_text: 0,
                     name: 0,
                     personality: 0,
                     respond: 1
    end
  end
end
