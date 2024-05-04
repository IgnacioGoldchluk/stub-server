defmodule StubServer.Routes do
  import Plug.Router

  defmacro generate_params_matches(endpoint_info) do
    quote bind_quoted: [endpoint_info: endpoint_info] do
      %{"route" => route} = endpoint_info
      query_params = Map.get(endpoint_info, "query_params", %{}) |> Macro.escape()
      body_params = Map.get(endpoint_info, "request_body", %{}) |> Macro.escape()
      resp = Map.get(endpoint_info, "response", %{}) |> Macro.escape()

      def json_response(route, q, b)
          when q == unquote(query_params) and b == unquote(query_params),
          do: unquote(resp)
    end
  end

  defmacro generate_route(endpoint_info) do
    quote bind_quoted: [endpoint_info: endpoint_info] do
      %{"route" => route} = endpoint_info
      method = Map.get(endpoint_info, "method", "get") |> String.to_atom()
      status_code = Map.get(endpoint_info, "status_code", 200)

      match route, via: method do
        conn = var!(conn) |> Plug.Conn.fetch_query_params()

        %{request_path: path, query_params: params, body_params: body_params} = conn

        var!(conn)
        |> put_resp_content_type("application/json")
        |> send_resp(
          unquote(status_code),
          json_response(path, params, body_params) |> Jason.encode!()
        )
      end
    end
  end
end
