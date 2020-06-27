# RasaSDK

**This is not an OFFICIAL SDK**

This code is based on the OpenAPI specification and
other documentation available on their website, but
none of the maintainers work for Rasa.

**BREAKING CHANGE**

Originally this library used RasaSdk - but it now used RasaSDK to follow the naming
conventions.

### Demo Server
There are a lot of moving pieces to working with Rasa.  This library tries to cover a lot of them.
I found that it was sometime difficult to see how they work in practice, so there is another repository
that demonstrates the library in action.

If you want to see this in action you can checkout the  [elixir-rasa-action-server](https://github.com/r26D/elixir-rasa-action-server)
which demonstrates how to use both libraries to serve up a fork [helpdesk-assistant](https://github.com/r26D/helpdesk-assistant)  example from Rasa.


## Rasa Action Server/SDK
The description of how to serve requests for Rasa is [here ](https://rasa.com/docs/rasa/api/action-server/#action-server)

[The OpenAPI specification ](https://rasa.com/docs/rasa/_static/spec/action-server.yml)

This allows you to do both custom actions and forms.

## RasaNLG

This allows you to serve NLG (Natural Language Generation) requests for the [Rasa Chatbot](https://rasa.com) in Elixir

Unlike the Rasa Action Server there isn't an OpenAPI spec for this interface.

This code was heavily based on work by the OpenAPI generator and David White, the author of the [rasa-sdk-elixir](https://github.com/whitedr/rasa-sdk-elixir) project.

~~I used code from that project to bootstrap this project. I included the apache license from that project in this one.~~
This code has been merged into this repo to have everything in one place.


## Rest 

The rest client is a work in progress. This is needed to communicate to the Rasa bot
and trigger external events.

## Callback

Rasa has a Rest API that allows you to interact with the chatbot. If you submit
an external event there is no way for the client to get the new data.  Rasa recommends
using a different channel.  

[Callback Channel Docs](https://rasa.com/docs/rasa/user-guide/connectors/your-own-website/#id3)

This library has a plug that allows you to process those callback requests.



### Updating the openapi 

If you want to use the generate.sh script you need to install the openapi-generator cli - go [here](https://github.com/OpenAPITools/openapi-generator#1---installation)

If you want to use the docker_generate.sh - just install docker and run the script



### Building

To install the required dependencies and to build the elixir project, run:
```
mix local.hex --force
mix do deps.get, compile
```

## Installation

The package can be installed
by adding `rasa_sdk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [ {:rasa_sdk, git: "~0.0.1"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/rasa_sdk](https://hexdocs.pm/rasa_sdk).