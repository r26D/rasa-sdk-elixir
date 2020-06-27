defmodule RasaSDK.Actions.Context do
  alias RasaSDK.Model.{ParseResult, Tracker}
  alias RasaSDK.Model.Request
  alias RasaSDK.Model.ResponseOk
  alias RasaSDK.Model.ResponseRejected

  require Logger

  defstruct [
    :request,
    :response,
    :error
  ]

  @type t :: %__MODULE__{
          request: Request.t(),
          response: ResponseOk.t(),
          error: ResponseRejected.t() | nil
        }

  def new(request) do
    %__MODULE__{
      request: request,
      response: %ResponseOk{
        events: [],
        responses: []
      },
      error: nil
    }
  end

  @doc """
  Return the conversation_id of the conversation
  """
  # https://github.com/RasaHQ/rasa/issues/6062
  # https://forum.rasa.com/t/conversation-and-sender-id/21890/4 sender_id and conversation_id are the same thing - but not both are being set
  # def conversation_id(%__MODULE__{request: %Request{tracker: %Tracker{conversation_id: conversation_id}}}),
  def conversation_id(%__MODULE__{request: %Request{sender_id: conversation_id}}),
    do: conversation_id

  @doc """
  Return the currently set values of the slots
  """
  def current_slot_values(%__MODULE__{request: %Request{tracker: %Tracker{slots: slots}}}),
    do: slots

  @doc """
  Retrieves the value of a slot.
  """
  def get_slot(%__MODULE__{request: %Request{tracker: %Tracker{slots: slots}}}, key) do
    if Map.has_key?(slots, key) do
      Map.get(slots, key)
    else
      Logger.info("Tried to access non existent slot #{key}")
      nil
    end
  end

  def set_slot(%__MODULE__{} = context, key, value) do
    update_in(
      context,
      [Access.key(:request), Access.key(:tracker), Access.key(:slots)],
      fn slots ->
        Map.put(slots, key, value)
      end
    )
  end

  def set_active_form(%__MODULE__{} = context, name, validate) do
    update_in(context, [Access.key(:request), Access.key(:tracker)], fn tracker ->
      Map.put(tracker, :active_form, %{name: name, validate: validate})
    end)
  end

  @doc """
  Get entity values found for the passed entity name in latest msg.

  If you are only interested in the first entity of a given type use
  `get_latest_entities(tracker, "my_entity_name") |> List.first()`.
  If no entity is found `nil` is the default result.
  """
  def get_latest_entities(context, entity_type, opts \\ [])

  def get_latest_entities(
        %__MODULE__{
          request: %Request{tracker: %Tracker{latest_message: nil}}
        },
        _,
        _
      ) do
    []
  end

  def get_latest_entities(
        %__MODULE__{
          request: %Request{tracker: %Tracker{latest_message: %ParseResult{entities: nil}}}
        },
        _,
        _
      ) do
    []
  end

  def get_latest_entities(
        %__MODULE__{
          request: %Request{tracker: %Tracker{latest_message: %ParseResult{entities: entities}}}
        },
        entity_type,
        opts
      ) do
    role = Keyword.get(opts, :role)
    group = Keyword.get(opts, :group)

    entities
    # |> Enum.filter(fn e -> e.entity == entity_type end)
    |> Enum.filter(&filter_entity_by(&1, :entity, entity_type))
    |> Enum.filter(&filter_entity_by(&1, :role, role))
    |> Enum.filter(&filter_entity_by(&1, :group, group))
  end

  defp filter_entity_by(_entity, _key, nil), do: true
  defp filter_entity_by(entity, field, value), do: Map.get(entity, field) == value

  @doc """
  Get the name of the input_channel of the latest UserUttered event
  """
  def latest_input_channel(%__MODULE__{
        request: %Request{tracker: %Tracker{latest_input_channel: latest_input_channel}}
      }) do
    latest_input_channel
  end

  def latest_event_time(%__MODULE__{
        request: %Request{tracker: %Tracker{latest_event_time: latest_event_time}}
      }) do
    latest_event_time
  end

  @default_message %{
    image: nil,
    json_message: nil,
    template: nil,
    attachment: nil,
    text: nil,
    buttons: nil
  }

  def utter_message(
        %__MODULE__{} = context,
        options \\ [],
        data \\ %{}
      ) do
    message =
      options
      |> Enum.into(@default_message)
      |> Map.merge(data)

    update_in(context, [Access.key(:response), Access.key(:responses)], fn responses ->
      responses ++ [message]
    end)
  end

  def add_event(%__MODULE__{} = context, event) do
    update_in(context, [Access.key(:response), Access.key(:events)], fn events ->
      if event.event == "slot" do
        case Enum.find_index(events, &(&1.event == "slot" and &1.name == event.name)) do
          nil ->
            events ++ [event]

          index ->
            List.replace_at(events, index, event)
        end
      else
        events ++ [event]
      end
    end)
  end

  def set_error(%__MODULE__{} = context, action_name, error) do
    Map.replace!(context, :error, %ResponseRejected{action_name: action_name, error: error})
  end
end
