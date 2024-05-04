defmodule StubServer.Router do
  use Plug.Router
  import StubServer.Routes
  plug(:match)
  plug(:dispatch)

  @external_resource server_spec = "lib/stub_server.json"

  server_spec
  |> File.read!()
  |> Jason.decode!()
  |> Enum.each(fn endpoint -> generate(endpoint) end)

  match _ do
    send_resp(conn, :not_found, "")
  end
end
