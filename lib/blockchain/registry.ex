defmodule Blockchain.Registry do
  @moduledoc """
  Registry that manages and stores the blockchain.
  """
  use GenServer

  @doc """
  Starts the registry with a new blockchain.
  """
  def start_link(blockchain \\ Blockchain.new(), opts) do
    GenServer.start_link(__MODULE__, blockchain, opts)
  end

  @doc """
  Adds a transaction to the registry.
  """
  def add_transaction(server \\ __MODULE__, transaction) do
    GenServer.call(server, {:put, transaction})
  end

  @doc """
  Gets the blockchain store on the registry.
  """
  def get_blockchain(server \\ __MODULE__) do
    GenServer.call(server, :get)
  end

  # Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_call({:put, transaction}, _from, state) do
    updated_blockchain = Blockchain.add_transaction(state, transaction)

    if Blockchain.valid_chain?(updated_blockchain) do
      {:reply, :ok, updated_blockchain}
    else
      {:reply, {:error, :invalid}, state}
    end
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
