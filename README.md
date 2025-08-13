# Drosera Network Manager

A comprehensive Linux shell script for managing Drosera Network nodes, traps, and operators on the Hoodi testnet.

## Overview

This bash script provides an interactive menu-driven interface for:
- Deploying new Drosera traps with proper configuration, operator registration, and 1 ETH bloom boost
- Setting up Discord Cadet role traps for community roles
- Relocating existing Drosera nodes to your machine
- Managing additional bloom boost functionality for trap performance
- Monitoring system status and logs via local containers or app.drosera.io
- Managing firewall configurations and system verification

## Features

### 🎯 Main Menu Options
1. **Install Dependencies** - Set up all required tools and dependencies
2. **Deploy new trap** - Create and deploy a new Drosera trap (includes operator registration)
3. **Deploy for Discord Cadet role** - Special setup for Discord role verification
4. **Relocate your Drosera** - Move existing Drosera nodes to this machine
5. **Buy unlimited call/request RPC** - Premium RPC service access via Discord
6. **Send bloom boost** - Send additional boost to your trap (beyond initial 1 ETH deployment boost)
7. **Check system** - Monitor system resources and Drosera processes
8. **Monitoring logs** - View and bridge logs from Docker containers or app.drosera.io
9. **Reconfigure UFW** - Manage firewall rules and ports
10. **Verify system** - Comprehensive system component verification
11. **Exit** - Close the application

### 🔧 System Requirements
- **OS**: Linux (Ubuntu/Debian recommended)
- **CPU**: Minimum 2 cores (4+ recommended)
- **RAM**: Minimum 4GB (8GB+ recommended)
- **Storage**: At least 20GB free space
- **Network**: Stable internet connection with open ports 31313-31316

### 📦 Dependencies
- Docker & Docker Compose
- Foundry (Forge)
- Drosera CLI
- UFW firewall
- Basic system utilities (curl, git, build-essential)

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/0xJhinkz/drosera-manager.git
cd drosera-manager
```

### 2. Make Script Executable
```bash
chmod +x drosera-manager.sh
```

### 3. Run the Manager
```bash
./drosera-manager.sh
```

### 4. First Time Setup
1. Select option **1** to install dependencies
2. The script will automatically install all required tools
3. Configure your settings when prompted

## Usage Guide

### First Time Setup
When you run the script for the first time, it will:
1. Check your system requirements
2. Offer to install missing dependencies
3. Create necessary directories
4. Present the main menu

### Configuration Process
The script will prompt you for:
- **ETH RPC URL** - Your Ethereum Hoodi RPC endpoint (Alchemy, QuickNode, etc.)
- **Private Key** - Your wallet private key (without 0x prefix)
- **Server IP** - Automatically detected or manually entered
- **Operator Addresses** - Addresses that will operate your trap
- **Discord Username** - For Cadet role verification (optional)

All configuration is saved to `.env` file for future use and Docker Compose integration.

### Deploying a New Trap
1. Select option **2** from the main menu
2. Configure your settings (RPC URL, private key, etc.)
3. The script creates embedded Foundry template with proper structure
4. Builds and deploys your trap contract
5. Automatically registers operators to your trap during deployment
6. Sends bloom boost (defaults to 1 ETH) to boost trap performance
7. Updates `drosera.toml` with your configuration and operator addresses

### Discord Cadet Role Setup
1. Select option **3** from the main menu
2. Enter your Discord username when prompted
3. The script creates a specialized Discord verification trap
4. Deploys the trap for community role verification

### Managing Operations
- **Send Bloom Boost** (Option 6): Additional boost for your trap performance (separate from deployment boost)
- **Relocate Drosera** (Option 4): Move existing nodes with Docker Compose setup
- **Operator Registration**: Automatically handled during trap deployment (Option 2)
- **Initial Bloom Boost**: Automatically sent during trap deployment (defaults to 1 ETH)

### Monitoring and Maintenance
- **System Check** (Option 7): Monitor CPU, memory, disk usage, and Docker containers
- **Log Monitoring** (Option 8): View real-time logs via local Docker containers or app.drosera.io
- **Firewall Management** (Option 9): Add/remove ports, reset UFW rules
- **System Verification** (Option 10): Comprehensive health check of all components

## Configuration Files

### drosera.toml
Located in `~/my-drosera-trap/drosera.toml`
```toml
ethereum_rpc = "https://ethereum-hoodi-rpc.publicnode.com"
drosera_rpc = "https://relay.hoodi.drosera.io"
eth_chain_id = 560048
drosera_address = "0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D"

[traps]
[traps.mytrap]
path = "out/Trap.sol/Trap.json"
response_contract = "0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608"
response_function = "respond(string)"
cooldown_period_blocks = 33
min_number_of_operators = 1
max_number_of_operators = 2
block_sample_size = 10
private_trap = true
whitelist = ["YOUR_OPERATOR_ADDRESS"]
address = "YOUR_TRAP_CONFIG_ADDRESS"
```

### docker-compose.yaml
Located in `~/Drosera-Network/docker-compose.yaml`
```yaml
version: '3.8'
services:
  operator1:
    image: ghcr.io/drosera-network/drosera-operator:latest
    network_mode: host
    command: ["node"]
    environment:
      - DRO__ETH__CHAIN_ID=560048
      - DRO__ETH__RPC_URL=https://rpc.hoodi.ethpandaops.io
      - DRO__ETH__PRIVATE_KEY=${OP1_KEY}
      - DRO__NETWORK__P2P_PORT=31313
      - DRO__SERVER__PORT=31314
      - DRO__NETWORK__EXTERNAL_P2P_ADDRESS=${SERVER_IP}
      - DRO__DISABLE_DNR_CONFIRMATION=true
      - DRO__LOG__LEVEL=debug
    volumes:
      - op1_data:/data
    restart: always
volumes:
  op1_data:
```

### .env
The `.env` file is used for both development and Docker configurations.
```bash
# ===========================================
# Drosera Node Configuration (for Docker)
# ===========================================

# Required: Your Ethereum private key for the node (without 0x prefix)
ETH_PRIVATE_KEY=your_private_key_here

# Required: Your VPS external IP address
VPS_IP=your_vps_ip_here

# Optional: Ethereum RPC URLs (both should be the same)
ETH_RPC_URL=https://rpc.hoodi.ethpandaops.io
ETH_BACKUP_RPC_URL=https://rpc.hoodi.ethpandaops.io

# Optional: Drosera contract address (default provided)
DROSERA_ADDRESS=0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D

# ===========================================
# Development/Deployment Configuration
# ===========================================

# Network Configuration
ETH_CHAIN_ID=560048
DROSERA_ADDRESS=0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D

# Private Keys
PRIVATE_KEY=your_private_key_here

# RPC Configuration
RPC_URL=https://ethereum-hoodi-rpc.publicnode.com

# Operator Configuration
OPERATOR_ADDRESS_1=0x...
OPERATOR_ADDRESS_2=0x...

# Trap Configuration
RESPONSE_CONTRACT=0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608

# Discord Configuration
DISCORD_USERNAME=your_discord_username

# Etherscan API (optional)
ETHERSCAN_API_KEY=your_etherscan_api_key_here
```

## Docker Setup (Alternative Method)

In addition to the interactive manager script, you can run Drosera nodes using Docker Compose for containerized deployment.

### Docker Files

- `docker-compose.yml` - Main Docker Compose configuration
- `env.example` - Environment variables template (use for both development and Docker)
- `start-drosera.sh` - Linux start script
- `stop-drosera.sh` - Linux stop script
- `monitor-drosera.sh` - Linux monitoring script

### Docker Quick Start

#### 1. Prerequisites
- Docker and Docker Compose installed
- Your Ethereum private key
- Your server's external IP address

#### 2. Configure Environment
Copy the environment template and fill in your values:
```bash
cp env.example .env
nano .env
```

#### 3. Required Docker Configuration
Edit `.env` and set these required values for Docker:
```env
ETH_PRIVATE_KEY=your_ethereum_private_key_here
VPS_IP=your_server_external_ip_here
```

#### 4. Start the Docker Node
```bash
chmod +x start-drosera.sh stop-drosera.sh monitor-drosera.sh
./start-drosera.sh
```

#### 5. Monitor the Docker Node
```bash
# Show status and basic info
./monitor-drosera.sh status

# Follow logs in real-time
./monitor-drosera.sh follow

# Show all monitoring information
./monitor-drosera.sh all

# View logs directly
docker-compose logs -f
```

#### 6. Stop the Docker Node
```bash
./stop-drosera.sh
```

### Docker Configuration Details

The Docker setup mirrors the systemd service configuration:

- **Database file**: `/home/drosera/.drosera/drosera.db` (mapped to `./data/drosera.db`)
- **P2P port**: 31313
- **Server port**: 31314
- **ETH RPC URL**: `https://rpc.hoodi.ethpandaops.io` (same as backup)
- **ETH Backup RPC URL**: `https://rpc.hoodi.ethpandaops.io` (same as primary)
- **Drosera contract**: `0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D` (configurable)
- **Network mode**: Host (direct access to server network)
- **File limits**: 65535 (matches systemd configuration)

### Docker Data Persistence

- **Database and node data**: `./data/` directory (mapped to `/home/drosera/.drosera/` in container)
- **Logs**: `./logs/` directory (mapped to `/var/log/drosera/` in container)

**Important:** Data directories have proper read/write permissions set automatically.

### Docker Troubleshooting

#### Check if Docker is running:
```bash
docker info
```

#### View detailed logs:
```bash
docker-compose logs drosera-node
```

#### Restart the service:
```bash
docker-compose restart
```

#### Reset everything (CAUTION - deletes data):
```bash
docker-compose down -v
rm -rf data/ logs/
```

### Docker Security Notes

- Keep your `.env` file secure and never commit it to version control
- The private key in `.env` has full access to your Ethereum account
- Consider using a dedicated key for the Drosera node

## Port Configuration

The script automatically configures these ports:
- **31313**: Operator 1 P2P port
- **31314**: Operator 1 server port
- **31315**: Operator 2 P2P port (if configured)
- **31316**: Operator 2 server port (if configured)
- **22**: SSH access

## Troubleshooting

### Common Issues

#### "Docker not installed"
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose

# Or use the script's dependency installer (Option 1)
# which will install Docker automatically
```

#### "Forge command not found"
```bash
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup
```

#### "Permission denied" errors
```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in, or run:
newgrp docker
```

#### Firewall issues
```bash
# Check UFW status
sudo ufw status

# Reset UFW rules
sudo ufw reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 31313/tcp
sudo ufw allow 31314/tcp
sudo ufw --force enable
```

### Log Analysis

#### Option 1: View logs via app.drosera.io (Recommended)
Visit [app.drosera.io](https://app.drosera.io) to view comprehensive logs and node status from the web interface.

#### Option 2: Check operator logs locally
```bash
cd ~/Drosera-Network
docker-compose logs -f operator1
docker-compose logs -f operator2
```

#### Check trap status
```bash
cd ~/my-drosera-trap
drosera dryrun
```

#### Verify network connectivity
```bash
# Test Hoodi RPC
curl -s https://ethereum-hoodi-rpc.publicnode.com

# Test Drosera relay
curl -s https://relay.hoodi.drosera.io
```

## Security Considerations

- **Never share your private keys**
- **Use strong passwords for your system**
- **Keep your system updated**
- **Monitor logs regularly for suspicious activity**
- **Use firewall rules to restrict access**

## Support and Resources

- **Official Documentation**: [https://dev.drosera.io/](https://dev.drosera.io/)
- **Discord Community**: [https://discord.com/invite/drosera](https://discord.com/invite/drosera)
- **Main Repository**: [https://github.com/0xJhinkz/drosera-manager](https://github.com/0xJhinkz/drosera-manager)
- **Original Guide**: [https://github.com/izmerGhub/Drosera-Hoodi-Guide-Setup--Izmer](https://github.com/izmerGhub/Drosera-Hoodi-Guide-Setup--Izmer)

## GitHub Integration & Automation

This repository includes several GitHub Actions workflows for automation:

### 🔔 Discord Notifications
- **Push notifications**: Get notified when code is updated
- **Pull request alerts**: Track PR activity
- **Release announcements**: Celebrate new releases
- **Test results**: Monitor script validation status

### 🧪 Automated Testing
- **Script syntax validation**: Ensures all scripts are syntactically correct
- **Cross-platform testing**: Tests on Ubuntu and Windows
- **Shellcheck analysis**: Static analysis for shell scripts
- **PowerShell validation**: Syntax checking for Windows scripts

### 📊 Continuous Integration
- **Automatic validation** on every push and PR
- **Multi-platform support** testing
- **Real-time Discord notifications** for all activities

The Discord webhook integration keeps you informed about all repository activity, making it easy to stay updated on the latest changes and improvements.

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve this script.

## License

This script is provided as-is for educational and operational purposes. Please ensure compliance with Drosera Network's terms of service and your local regulations.

## Disclaimer

This script automates the setup process for Drosera Network nodes. Users are responsible for:
- Ensuring compliance with network rules
- Managing their private keys securely
- Monitoring their node's performance
- Understanding the risks of running blockchain infrastructure

---

**Happy node running! 🚀**
