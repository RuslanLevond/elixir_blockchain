defmodule Blockchain.RegistryTest do
  use ExUnit.Case

  setup do
    registry = start_supervised!(Blockchain.Registry)
    %{registry: registry}
  end

  test "returns blockchain with a new transaction after inserting one", %{registry: registry} do
    assert %Blockchain{blocks: blocks} = Blockchain.Registry.get_blockchain(registry)
    assert length(blocks) == 1

    transaction = "transaction_example"
    assert :ok == Blockchain.Registry.add_transaction(registry, transaction)

    blockchain = Blockchain.Registry.get_blockchain(registry)
    assert %Blockchain{blocks: blocks} = blockchain
    assert length(blocks) == 2
    assert %Block{data: ^transaction} = Blockchain.last_block(blockchain)
  end
end
