defmodule RasaSDK.Actions.Registry do
  alias RasaSDK.Actions.Context
  alias RasaSDK.Actions.{
    Action,
    FormAction
    }

  def register_actions(modules) when is_list(modules) do
    register_actions({nil, modules})
  end

  def register_actions({prefix, modules}) do
    actions_table = get_actions_table()
    :ets.new(actions_table, [:set, :protected, :named_table])

    modules
    |> Enum.each(
         fn module ->
           if Action.is_action?(module) || FormAction.is_form_action?(module) do
             IO.puts("Registering #{module.name()}")
             :ets.insert(actions_table, {key_name(prefix, module.name()), module})
           end
         end
       )
  end


  defp key_name(nil, name), do: name

  defp key_name(prefix, name) do
    "#{prefix}/#{name}"
  end

  def execute(%Context{} = context), do: execute(context, prefix: nil)

  def execute(
        %Context{
          request: %{
            next_action: next_action
          }
        } = context,
        prefix: prefix
      ) do
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

  def all_keys(prefix: prefix) do
    key_stream(get_actions_table())
    |> Enum.map(&{String.replace(&1, "#{prefix}/", ""), :ets.lookup(get_actions_table(), &1)})
    |> Enum.into(%{})
  end

  def all_keys([]) do
    key_stream(get_actions_table())
    |> Enum.map(&{&1, :ets.lookup(get_actions_table(), &1)})
    |> Enum.into(%{})
  end
  #  https://stackoverflow.com/a/43842843
  defp key_stream(table_name) do
    Stream.resource(
      fn -> :ets.first(table_name) end,
      fn
        :"$end_of_table" -> {:halt, nil}
        previous_key -> {[previous_key], :ets.next(table_name, previous_key)}
      end,
      fn _ -> :ok end
    )
  end
end
