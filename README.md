# XMRig Docker

Containerized XMRig Monero miner

## Usage

```bash
# Use pre-built image
docker run -d -e WALLET_ADDRESS="your_wallet" injundev/xmrig:latest

# Or build locally
docker build -t xmrig-docker .
docker run -d -e WALLET_ADDRESS="your_wallet" xmrig-docker
```

## Variables

- `WALLET_ADDRESS` - Monero wallet address (required)
- `POOL_URL` - Pool URL (default: gulf.moneroocean.stream:10001)
- `WORKER_ID` - Worker ID (default: random 8 chars)