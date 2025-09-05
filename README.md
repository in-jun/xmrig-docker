# XMRig Docker

Containerized XMRig Monero miner

## Usage

```bash
docker build -t xmrig-docker .
docker run -d -e WALLET_ADDRESS="your_wallet_address" xmrig-docker
```

## Variables

- `WALLET_ADDRESS` - Monero wallet address (required)
- `POOL_URL` - Pool URL (default: kr.monero.herominers.com:1111)
- `WORKER_ID` - Worker ID (default: random 8 chars)