defmodule RasaSDK.Deserializer do
  @moduledoc """
  Helper functions for deserializing responses into models
  """

  @doc """
  Update the provided model with a deserialization of a nested value
  """
  def deserialize(model, field, :map, _options) do
    model
    |> Map.get_and_update!(
      field,
      fn field_value ->
         if field_value == nil do
           {nil, nil}
           else
             {
               field_value,
               Map.new(
                 field_value,
                 fn {key, value} ->
                   try do
                     {String.to_existing_atom(key), value}
                   rescue
                     ArgumentError -> {String.to_atom(key), value}
                   end
                 end
               )
             }
         end

      end
    )
    |> get_model()
  end

  defp get_model({_, new_model}), do: new_model

  def deserialize(model, field, :list, mod, options) do
    if Code.ensure_loaded?(mod) do
      model
      |> Map.update!(field, &Poison.Decode.decode(&1, Keyword.merge(options, as: [struct(mod)])))
    else
      model
    end
  end

  def deserialize(model, field, :struct, mod, options) do
    if Code.ensure_loaded?(mod) do
      model
      |> Map.update!(field, &Poison.Decode.decode(&1, Keyword.merge(options, as: struct(mod))))
    else
      model
    end
  end

  def deserialize(model, field, :map, mod, options) do
    if Code.ensure_loaded?(mod) do
      model
      |> Map.update!(
        field,
        &Map.new(
          &1,
          fn {key, val} ->
            {key, Poison.Decode.decode(val, Keyword.merge(options, as: struct(mod)))}
          end
        )
      )
    else
      model
    end
  end

  def deserialize(model, field, :date, _, _options) do
    value = Map.get(model, field)

    case is_binary(value) do
      true ->
        case DateTime.from_iso8601(value) do
          {:ok, datetime, _offset} ->
            Map.put(model, field, datetime)

          _ ->
            model
        end

      false ->
        model
    end
  end
end
