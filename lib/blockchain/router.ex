defmodule Blockchain.Router do
  @moduledoc """
  Router manages a list of IPs of P2P connections a node has.

  The IPs will be stored in the list in the following way:
  => [%{host: "127.0.0.1", port: "4040"}, %{host: "244.4.23.1", port: "4222"}]
  """
  use GenServer

  @doc """
  Starts the router.
  """
  def start_link(state \\ [], opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  @doc """
  Adds an address to the router.
  """
  def put(server \\ __MODULE__, host, port) do
    GenServer.cast(server, {:put, host, port})
  end

  @doc """
  Gets all address from the router.
  """
  def get_all(server \\ __MODULE__) do
    GenServer.call(server, :get_all)
  end

  # Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:put, host, port}, state) do
    {:noreply, [%{host: host, port: port} | state]}
  end

  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end
end
