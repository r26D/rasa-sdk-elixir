defmodule RasaSDK.Responses.Context do
  alias RasaSDK.Model.{ParseResult, Tracker}

  alias RasaSDK.Model.{
    NLGRequest,
    NLGResponse,
    NLGResponseOk,
    NLGResponseRejected
    }

  require Logger

  defstruct [
    :request,
    :response,
    :error
  ]

  @type t :: %__MODULE__{
               request: NLGRequest.t(),
               response: NLGResponseOk.t(),
               error: NLGResponseRejected.t() | nil
             }

  def new(request) do
    %__MODULE__{
      request: request,
      response: %NLGResponseOk{
        response: %NLGResponse{}
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
  def conversation_id(
        %__MODULE__{
          request: %NLGRequest{
            tracker: %Tracker{
              sender_id: conversation_id
            }
          }
        }
      ),
      do: conversation_id

  @doc """
    Find the template from the request
  """
  def get_template(
        %__MODULE__{
          request: %NLGRequest{
            template: template
          }
        }
      ),
      do: template
  @doc """
    Looks in the tracker to find the active form.
  """
  def get_active_form(
        %__MODULE__{
          request: %NLGRequest{
            tracker: %Tracker{
              active_form: active_form
            }
          }
        }
      ), do: active_form

  @doc """
    Looks in the active form for the name
  """
  def get_active_form_name(context) do
    get_active_form(context)
    |> Map.get(:name)
  end

  @doc """
  Return the currently set values of the slots
  """
  def current_slot_values(
        %__MODULE__{
          request: %NLGRequest{
            tracker: %Tracker{
              slots: slots
            }
          }
        }
      ),
      do: slots

  @doc """
  Retrieves the value of a slot.
  """
  def get_slot(
        %__MODULE__{
          request: %NLGRequest{
            tracker: %Tracker{
              slots: slots
            }
          }
        },
        key
      ) do
    if Map.has_key?(slots, key) do
      Map.get(slots, key)
    else
      Logger.info("Tried to access non existent slot #{key}")
      nil
    end
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
          request: %NLGRequest{
            tracker: %Tracker{
              latest_message: nil
            }
          }
        },
        _,
        _
      ) do
    []
  end

  def get_latest_entities(
        %__MODULE__{
          request: %NLGRequest{
            tracker: %Tracker{
              latest_message: %ParseResult{
                entities: nil
              }
            }
          }
        },
        _,
        _
      ) do
    []
  end

  def get_latest_entities(
        %__MODULE__{
          request: %NLGRequest{
            tracker: %Tracker{
              latest_message: %ParseResult{
                entities: entities
              }
            }
          }
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
  def latest_input_channel(
        %__MODULE__{
          request: %NLGRequest{
            tracker: %Tracker{
              latest_input_channel: latest_input_channel
            }
          }
        }
      ) do
    latest_input_channel
  end

  def latest_event_time(
        %__MODULE__{
          request: %NLGRequest{
            tracker: %Tracker{
              latest_event_time: latest_event_time
            }
          }
        }
      ) do
    latest_event_time
  end

  def set_response(%__MODULE__{} = context, %NLGResponse{} = response) do
    Map.replace!(
      context,
      :response,
      %NLGResponseOk{
        response: response
      }
    )
  end

  def set_response(%__MODULE__{} = context, %NLGResponse{} = response, nil) do
    Map.replace!(
      context,
      :response,
      %NLGResponseOk{
        response: response
      }
    )
  end

  def set_response(%__MODULE__{} = context, %NLGResponse{} = response, personality) do
    Map.replace!(
      context,
      :response,
      %NLGResponseOk{
        response: response
                  |> personality.personalize(context)
      }
    )
  end

  def set_error(%__MODULE__{} = context, response_name, error) do
    Map.replace!(context, :error, %NLGResponseRejected{response_name: response_name, error: error})
  end
end
