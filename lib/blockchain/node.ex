defmodule Blockchain.Node do
  @moduledoc """
  Module for TCP communications, performing P2P communications with the use of IPs from router.

  Requirements:
  1. Tell everyone about new transaction on the network, after validating it locally.
  2. Synchronise with an already running node, getting a copy of blockchain and
  a list of addresses on the network.
  3. Informing everyone about new node on the network, saving its address.
  """
  require Logger

  @doc """
  Connect to the provided host and send a message.
  """
  def send_message(host, port, message) do
    {:ok, socket} = :gen_tcp.connect(host, port, [:binary])

    :ok = :gen_tcp.send(socket, message)
    :ok = :gen_tcp.close(socket)
  end

  @doc """
  Listens to the port until the socket becomes available.
  """
  def accept(port) do
    # Options below:
    # 1. `:binary` - receiving data as binary.
    # 2. `packet: 0` - receives data as a whole.
    # 3. `active: false` - blocks `gen_tcp.recv` until data is available.
    # 4. `reuseaddr: true` - allows to reuse the address if the listener crashes.

    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: 0, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  @doc """
  A loop accepting client connections, will serve for each connection.

  Each serve is ran under Task Supervisor as a separate task, to ensure no serve doesn't bring down the acceptor.
  """
  def loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Blockchain.TaskSupervisor, fn -> serve(client) end)

    # Assigns new pid for controlling the socket, so if acceptor crashes, serve will not crash with it.
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        IO.inspect(data: data)
        :gen_tcp.send(socket, data)
        serve(socket)
      {:error, :closed} ->
        IO.inspect("Closed connection")
    end
  end
end
