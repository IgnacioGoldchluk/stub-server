defmodule StubServerTest do
  use ExUnit.Case, async: false
  use Plug.Test

  alias StubServer.Router

  @opts Router.init([])

  describe "default values" do
    test "method is get" do
      conn = conn(:get, "/base")

      conn = Router.call(conn, @opts)

      assert conn.status == 200
      assert conn.resp_body |> Jason.decode!() == %{"hello" => "world"}
    end

    test "response is empty map" do
      conn = conn(:get, "/empty-response")

      conn = Router.call(conn, @opts)

      assert conn.status == 200
      assert conn.resp_body |> Jason.decode!() == %{}
    end
  end

  describe "methods" do
    test "post routes to a different response" do
      conn = conn(:post, "/base")

      conn = Router.call(conn, @opts)

      assert conn.status == 201
      assert conn.resp_body |> Jason.decode!() == %{"data" => %{"id" => 1, "why" => "same route"}}
    end
  end

  describe "query params" do
    test "returns response if query_params matches in route" do
      conn = conn(:get, "/with/query-params?world=true")

      conn = Router.call(conn, @opts)

      assert conn.status == 200
      assert conn.resp_body |> Jason.decode!() == %{"bye" => "people"}
    end

    test "returns not found if request contains extra body params" do
      conn = conn(:get, "/with/query-params?world=true", %{"a" => "b"}) |> Router.call(@opts)

      assert conn.status == 404
    end

    test "returns not found if request contains extra query params" do
      conn = conn(:get, "/with/query-params?world=true&something=else") |> Router.call(@opts)

      assert conn.status == 404
    end
  end

  describe "request body" do
    test "returns response if body_params matches in route" do
      conn = conn(:delete, "/with/request-body", %{"id" => 2}) |> Router.call(@opts)

      assert conn.status == 204
    end

    test "returns not found if request contains extra body params" do
      conn = conn(:delete, "/with/request-body", %{"id" => 2, "y" => "ext"}) |> Router.call(@opts)
      assert conn.status == 404
    end

    test "returns not found if request contains extra query_params" do
      conn = conn(:delete, "/with/request-body?and=q", %{"id" => 2}) |> Router.call(@opts)
      assert conn.status == 404
    end
  end
end
