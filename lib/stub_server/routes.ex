defmodule StubServer.Routes do
  import Plug.Router

  defmacro generate_route(endpoint_info) do
    quote bind_quoted: [endpoint_info: endpoint_info] do
      %{"route" => route} = endpoint_info
      method = Map.get(endpoint_info, "method", "get") |> String.to_atom()
      status_code = Map.get(endpoint_info, "status_code", 200)

      escaped_resp =
        endpoint_info
        |> Map.get("response", %{})
        |> Macro.escape()

      match route, via: method do
        var!(conn)
        |> put_resp_content_type("application/json")
        |> send_resp(unquote(status_code), unquote(escaped_resp) |> Jason.encode!())
      end
    end
  end
end
