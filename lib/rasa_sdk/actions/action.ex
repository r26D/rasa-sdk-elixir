defmodule RasaSdk.Actions.Action do
  alias RasaSdk.Actions.Context

  @callback name() :: String.t()
  @callback run(Context.t()) :: Context.t()

  defmacro __using__(_) do
    quote do
      @behaviour RasaSdk.Actions.Action
      import RasaSdk.Actions.Context
      import RasaSdk.Actions.Events

      def name() do
        "#{__MODULE__}"|>String.split(".")|>Enum.reverse|>Enum.at(0)|>Macro.underscore()
      end
      defoverridable  name: 0
    end
  end
end
