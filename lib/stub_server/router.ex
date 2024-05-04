defmodule StubServer.Router do
  use Plug.Router
  import StubServer.Routes
  plug(:match)
  plug(:dispatch)

  @external_resource server_spec = "lib/stub_server.json"

  server_spec
  |> File.read!()
  |> Jason.decode!()
  |> Enum.each(&generate_route/1)

  server_spec
  |> File.read!()
  |> Jason.decode!()
  |> Enum.each(&generate_params_matches/1)

  match _ do
    send_resp(conn, :not_found, "")
  end
end
