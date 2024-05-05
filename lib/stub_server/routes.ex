defmodule StubServer.Routes do
  defmacro generate_params_matches(endpoint_info) do
    quote bind_quoted: [endpoint_info: endpoint_info] do
      %{"route" => route} = endpoint_info
      query_params = Map.get(endpoint_info, "query_params", %{}) |> Macro.escape()
      body_params = Map.get(endpoint_info, "request_body", %{}) |> Macro.escape()
      resp = Map.get(endpoint_info, "response", %{}) |> Macro.escape()
      status_code = Map.get(endpoint_info, "status_code", 200)
      method = Map.get(endpoint_info, "method", "get") |> String.upcase()

      def response(unquote(method), unquote(route), q, b)
          when q == unquote(query_params) and b == unquote(body_params) do
        {unquote(status_code), unquote(resp)}
      end
    end
  end
end
