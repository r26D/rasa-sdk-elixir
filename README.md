# RasaSdk

API of the action server which is used by Rasa to execute custom actions.


## Rasa Action Server/SDK
The description of how to serve requests for Rasa is [here ](https://rasa.com/docs/rasa/api/action-server/#action-server)

[The OpenAPI specification ](https://rasa.com/docs/rasa/_static/spec/action-server.yml)


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
  [ {:rasa_sdk, git: "https://github.com/r26D/rasa-sdk-elixir.git"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/rasa_sdk](https://hexdocs.pm/rasa_sdk).