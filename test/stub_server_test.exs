defmodule StubServerTest do
  use ExUnit.Case
  doctest StubServer

  test "greets the world" do
    assert StubServer.hello() == :world
  end
end
