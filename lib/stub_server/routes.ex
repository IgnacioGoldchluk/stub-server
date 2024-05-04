defmodule StubServer.Routes do
  import Plug.Router

  defmacro generate(endpoint_info) do
    quote bind_quoted: [endpoint_info: endpoint_info] do
      %{"route" => route, "response" => resp} = endpoint_info
      method = Map.get(endpoint_info, "method", "get") |> String.to_atom()

      match route, via: method do
        var!(conn)
        |> send_resp(200, "hello")
      end
    end
  end
end
