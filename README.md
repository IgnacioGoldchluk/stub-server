# StubServer

A stub server based on JSON configuration for mocking. It is highly encouraged not to use this tool, there are better alternatives and the base image is >700MB.

## Usage
1. Create a config folder with a `config.json` file defining your endpoints. For example:
```js
[
  {
    "route": "/base",
    "status_code": 200,
    "response": {
      "message": "Hello World!"
    }
  }
]
```
2. Add the service and volume to your `compose.yaml` file
```yaml
services:
  stub-server:
    image: igsomething/stub_server:latest
    restart: always
    container_name: stub-server
    volumes:
      - ./server_config:/app/lib/server_config/
    ports:
      - 4135:4135
volumes:
  server_config:
```
3. That's it, you can now send requests to the server.

## Configuration
Refer to [the example config file](/lib/server_config/config.json) for examples on responses that expect specific query parameters, request body parameters and HTTP request methods.

## Benefits
- Modifying files in the attached volume triggers recompilation. No need to restart the container.

## Limitations
- Heavy Docker image, over 700MB.
- Stateless. Requests do nothing and always return the same value.
- No logic. You cannot define an endpoint that returns part of the path in the response such as
```js
  {
    "route": "/users/:id", // This matches the literal string ":id"
    "method": "get",
    "status_code": 200,
    "response": {
      {
        "id": ":id" // This returns the literal string ":id"
      }
    }
  }