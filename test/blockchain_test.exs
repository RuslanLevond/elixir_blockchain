defmodule BlockchainTest do
  use ExUnit.Case
  doctest Blockchain

  describe "new/0" do
    test "returns blockchain with a genesis block" do
      blockchain = Blockchain.new()
      genesis_block = Blockchain.last_block(blockchain)

      assert %Blockchain{} = blockchain
      assert length(blockchain.blocks) == 1
      assert genesis_block.index == 0
    end
  end

  describe "last_block/1" do
    test "returns last block added to the blockchain" do
      transaction = "one"
      blockchain = Blockchain.new()
      blockchain = Blockchain.add_transaction(blockchain, transaction)
      last_block = Blockchain.last_block(blockchain)

      assert last_block.data == transaction
    end
  end

  describe "add_transaction/2" do
    test "returns a blockchain with a new transaction block" do
      data = "new transaction"
      blockchain = Blockchain.new()
      blockchain = Blockchain.add_transaction(blockchain, data)
      last_transaction = Blockchain.last_block(blockchain)

      assert %Blockchain{} = blockchain
      assert length(blockchain.blocks) == 2

      assert last_transaction.index == 1
      assert last_transaction.data == data
    end

    test "adds a block with the previous hash pointing to the previous block" do
      blockchain = Blockchain.new()
      blockchain = Blockchain.add_transaction(blockchain, "one")
      block_one = Blockchain.last_block(blockchain)
      blockchain = Blockchain.add_transaction(blockchain, "two")
      block_two = Blockchain.last_block(blockchain)

      assert block_two.prevhash == block_one.hash
    end
  end

  describe "valid_chain?/1" do
    test "returns true when blockchain is valid" do
      assert Blockchain.new()
             |> Blockchain.add_transaction("New Transaction")
             |> Blockchain.valid_chain?()
    end

    test "returns false when one of the block's contents has changed in the blockchain" do
      blockchain = Blockchain.new() |> Blockchain.add_transaction("New Transaction")
      assert Blockchain.valid_chain?(blockchain)

      [last_block | tail] = blockchain.blocks
      modified_last_block = Map.replace(last_block, :data, "Modified data")
      modified_blockchain = Map.replace(blockchain, :blocks, [modified_last_block | tail])

      refute Blockchain.valid_chain?(modified_blockchain)
    end

    test "returns false when one of the block's hash has changed in the blockchain" do
      blockchain = Blockchain.new() |> Blockchain.add_transaction("New Transaction")
      assert Blockchain.valid_chain?(blockchain)

      [last_block | [genesis_block]] = blockchain.blocks
      modified_genesis_block = Map.replace(genesis_block, :hash, "NEW HASH")
      modified_blockchain = Map.replace(blockchain, :blocks, [last_block, modified_genesis_block])

      refute Blockchain.valid_chain?(modified_blockchain)
    end
  end
end
