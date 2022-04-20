defmodule BlockTest do
  use ExUnit.Case
  doctest Block

  describe "new/4" do
    test "returns block" do
      index = 11
      time = DateTime.utc_now()
      prevhash = :crypto.hash(:sha256, "test") |> Base.encode16()
      data = "test data"

      block = Block.new(index, time, data, prevhash)
      assert %Block{} = block
      assert block.index == index
      assert block.timestamp == time
      assert block.prevhash == prevhash
      assert block.data == data
      assert block.hash
    end
  end

  describe "genesis_block/0" do
    test "returns genesis block" do
      genesis_block = Block.genesis_block()
      assert %Block{} = genesis_block
      assert genesis_block.index == 0
      assert genesis_block.timestamp
      assert genesis_block.prevhash == ""
      assert genesis_block.data
      assert genesis_block.hash
    end
  end

  describe "generate_hash/4" do
    test "returns correct hash for the given variables" do
      index = 1
      timestamp = DateTime.utc_now()
      data = "EXAMPLE DATA"
      prevhash = "EXAMPLE HASH"
      hash = :crypto.hash(:sha256, "#{index}#{timestamp}#{data}#{prevhash}") |> Base.encode16()

      assert hash == Block.generate_hash(index, timestamp, data, prevhash)
    end
  end
end
