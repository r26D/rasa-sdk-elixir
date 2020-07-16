defmodule RasaSDK.Actions.Action do
  alias RasaSDK.Actions.Context

  @callback name() :: String.t()
  @callback run(Context.t()) :: Context.t()
  @callback slots_used() :: map()
  def is_action?(module) do
    RasaSDK.Actions.Action in (module.module_info(:attributes)[:behaviour] || [])
  end
  defmacro __using__(_) do
    quote do
      @behaviour RasaSDK.Actions.Action
      import RasaSDK.Actions.Context
      import RasaSDK.Actions.Events

      def name() do
        "#{__MODULE__}"
        |> String.split(".")
        |> Enum.reverse()
        |> Enum.at(0)
        |> Macro.underscore()
      end

      def run(%Context{} = context) do
        context
      end
      def slots_used() do
        %{}
      end
      defoverridable name: 0,
                    slots_used: 0,
                     run: 1
    end
  end


end
