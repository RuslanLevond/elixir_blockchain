defmodule Blockchain do
  @moduledoc """
  Blockchain containing a list of connected blocks.
  """

  defstruct name: "New Blockchain", blocks: []

  @type t :: %__MODULE__{
          name: String.t(),
          blocks: list()
        }

  @doc """
  Creates a new blockchain with the genesis block already inserted.
  """
  @type new() :: t
  def new(), do: %Blockchain{blocks: [Block.genesis_block()]}

  @doc """
  Adds a new block with the transaction to the start of the blockchain.
  """
  @spec add_transaction(t, String.t()) :: t
  def add_transaction(%__MODULE__{} = blockchain, transaction) when is_binary(transaction) do
    last_block = last_block(blockchain)

    index = last_block.index + 1
    timestamp = DateTime.utc_now()
    data = transaction
    prevhash = last_block.hash

    new_block = Block.new(index, timestamp, data, prevhash)

    Map.update!(blockchain, :blocks, &[new_block | &1])
  end

  @doc """
  Gets last added block from the blockchain.
  """
  @spec last_block(t) :: Block.t()
  def last_block(%__MODULE__{blocks: [head | _tail]}), do: head

  @doc """
  Checks the whole blockchain to see if chains are connected and block's contents are not changed.
  """
  @spec valid_chain?(t) :: boolean
  def valid_chain?(%__MODULE__{} = blockchain) do
    Enum.chunk_every(blockchain.blocks, 2, 1)
    |> Enum.all?(fn [current_block | _last_block] = block_list ->
      valid_block?(block_list) && valid_hash?(current_block)
    end)
  end

  # Checks if two blocks are following each other.
  defp valid_block?([%Block{prevhash: curr_block_prev_hash}, %Block{hash: last_block_hash}]) do
    curr_block_prev_hash == last_block_hash
  end

  # When there is only one block (i.e. the last block), no need to check if it is in the chain because already has been checked.
  defp valid_block?([%Block{}]), do: true

  # Checks if the hash changed on the block.
  defp valid_hash?(%Block{hash: hash} = block), do: Block.generate_hash(block) == hash

  # TODO: Have processes as nodes. When a node adds a transaction, it sends the transaction to every node on the network, which will store in the queue and eventually will add to their blockchain if valid.
end
