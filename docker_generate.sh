#!/usr/bin/env bash

docker run --rm --volume "${PWD}:/local" openapitools/openapi-generator-cli:v4.3.1 generate \
    -i /local/openapi/specs/action-server.yml \
    -g elixir \
    -t /local/openapi/elixir \
    -o /local \
    --additional-properties=invokerPackage=RasaSdk


