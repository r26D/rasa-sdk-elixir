defmodule RasaSDK.Actions.Registry do
  alias RasaSDK.Actions.Context

  def register_actions(modules) when is_list(modules) do
    register_actions({nil, modules})
  end

  def register_actions({prefix, modules}) do
    actions_table = get_actions_table()
    :ets.new(actions_table, [:set, :protected, :named_table])

    modules
    |> Enum.each(fn module ->
      if RasaSDK.Actions.Action in (module.module_info(:attributes)[:behaviour] || []) do
        :ets.insert(actions_table, {key_name(prefix, module.name()), module})
      end
    end)
  end

  defp key_name(nil, name), do: name

  defp key_name(prefix, name) do
    "#{prefix}/#{name}"
  end

  def execute(%Context{} = context), do: execute(context, prefix: nil)

  def execute(%Context{request: %{next_action: next_action}} = context, prefix: prefix) do
    case :ets.lookup(get_actions_table(), key_name(prefix, next_action)) do
      [] ->
        context
        |> Context.set_error(next_action, "action not found")

      [{_, module}] ->
        module.run(context)
    end
  end

  defp get_actions_table() do
    Application.get_env(:rasa_action, :actions_table, :rasa_actions)
  end
end
