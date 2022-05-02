defmodule Blockchain.Application do
  use Application

  @impl true
  def start(_type, _args) do
    port = String.to_integer(System.get_env("BLOCKCHAIN_PORT") || "4040")

    children = [
      {Task.Supervisor, name: Blockchain.TaskSupervisor},
      {Blockchain.Router, name: Blockchain.Router},
      {Blockchain.Registry, name: Blockchain.Registry},
      # The acceptor would be restarted if it goes down.
      Supervisor.child_spec({Task, fn -> Blockchain.Node.accept(port) end}, restart: :permanent)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blockchain.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
