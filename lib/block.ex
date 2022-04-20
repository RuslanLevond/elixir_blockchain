defmodule Block do
  @moduledoc """
  Block containing a record of a transaction.
  """

  defstruct [:index, :timestamp, :data, :prevhash, :hash]

  @type index :: integer()
  @type timestamp :: DateTime.t()
  @type data :: String.t()
  @type hash :: String.t()

  @type t :: %__MODULE__{
          index: index(),
          timestamp: timeout(),
          data: data(),
          prevhash: hash(),
          hash: hash()
        }

  @doc """
  Creates a new block.
  """
  @spec new(index, timeout, data, hash) :: t
  def new(index, timestamp, data, prevhash) do
    hash = generate_hash(index, timestamp, data, prevhash)

    %Block{index: index, timestamp: timestamp, data: data, prevhash: prevhash, hash: hash}
  end

  @doc """
  Creates a genesis block, the very first block of the blockchain.
  """
  @spec genesis_block() :: t
  def genesis_block() do
    new(0, DateTime.utc_now(), "genesis block transaction", "")
  end

  @doc """
  Generates a hash for the block based on the passed in content.
  """
  @spec generate_hash(index, timeout, data, hash) :: hash
  def generate_hash(index, timestamp, data, prevhash) do
    content = [index, timestamp, data, prevhash] |> Enum.join()
    :crypto.hash(:sha256, content) |> Base.encode16()
  end

  @spec generate_hash(t) :: hash
  def generate_hash(%__MODULE__{
        index: index,
        timestamp: timestamp,
        data: data,
        prevhash: prevhash
      }) do
    generate_hash(index, timestamp, data, prevhash)
  end
end
