# Blockchain Built in Elixir

## Installation

```curl
mix deps.get
```

## Running the library

```curl
iex -S mix
```

## Functionality

```elixir
# Create new blockchain with genesis block already created.
blockchain = Blockchain.new()

# Add transaction to the blockchain.
blockchain = Blockchain.add_transaction(blockchain, "Bob pays Alice 1 BTC")

# Verify if the blockchain is valid.
Blockchain.verify_chain?(blockchain)
```
