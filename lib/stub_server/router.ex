defmodule StubServer.Router do
  use Plug.Router
  import StubServer.Routes
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["text/html", "application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  @external_resource server_spec = "lib/server_config/config.json"

  server_spec
  |> File.read!()
  |> Jason.decode!()
  |> Enum.each(&generate_params_matches/1)

  def response(_method, _route, _query_params, _body_params) do
    {404, nil}
  end

  defp content_from_resp(nil), do: "text/html"
  defp content_from_resp(resp) when is_map(resp) or is_list(resp), do: "application/json"

  match _ do
    conn = Plug.Conn.fetch_query_params(conn)
    %{request_path: path, query_params: qp, body_params: bp, method: method} = conn

    {status_code, response} = response(method, path, qp, bp)

    conn
    |> put_resp_content_type(content_from_resp(response))
    |> send_resp(status_code, response |> Jason.encode!())
  end
end
