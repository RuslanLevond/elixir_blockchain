defmodule Blockchain.RouterTest do
  use ExUnit.Case

  setup do
    router = start_supervised!(Blockchain.Router)
    %{router: router}
  end

  test "returns addresses after insertion", %{router: router} do
    assert [] == Blockchain.Router.get_all(router)

    host = "128.343.312.1"
    port = "1234"
    Blockchain.Router.put(router, host, port)
    assert [%{host: host, port: port}] == Blockchain.Router.get_all(router)
  end
end
