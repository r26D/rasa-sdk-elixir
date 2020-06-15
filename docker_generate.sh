docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate \
    -i /local/openapi/specs/action-server.yml \
    -g elixir \
    -t /local/openapi/elixir \
    -o /local v\
    --additional-properties=invokerPackage=RasaSdk


