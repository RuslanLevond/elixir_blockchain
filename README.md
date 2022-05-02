# Blockchain Built in Elixir

## Installation

```curl
mix deps.get
```

## Running the library

```curl
BLOCKCHAIN_PORT=4001 iex -S mix
```

## Functionality

```elixir
# Add transaction to the blockchain.
Blockchain.Registry.add_transaction("Bob pays Alice 1 BTC")

# Gets Blockchain stored in Registry.
Blockchain.Registry.get_blockchain()

# Send message to Blockchain's node, requires targetted node to be running and accepting TCP messages.
Blockchain.Node.send_message('localhost', 4040, "Hello World")

# Adds an node's IP address to the Router.
Blockchain.Router.put('127.0.0.1', '4040')

# Gets all stored IP addresses.
Blockchain.Router.get_all()
```
