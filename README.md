# Drosera Network Manager

A comprehensive Linux shell script for managing Drosera Network nodes, traps, and operators on the Hoodi testnet.

## Overview

This bash script provides an interactive menu-driven interface for:
- Deploying new Drosera traps with proper configuration
- Setting up Discord Cadet role traps for community roles
- Relocating existing Drosera nodes to your machine
- Managing operators with bloom boost and opt-in functionality
- Monitoring system status and logs
- Managing firewall configurations and system verification

## Features

### 🎯 Main Menu Options
1. **Install Dependencies** - Set up all required tools and dependencies
2. **Deploy new trap** - Create and deploy a new Drosera trap
3. **Deploy for Discord Cadet role** - Special setup for Discord role verification
4. **Relocate your Drosera** - Move existing Drosera nodes to this machine
5. **Buy unlimited call/request RPC** - Premium RPC service access via Discord
6. **Send bloom boost** - Boost your trap performance
7. **Opt-in operators** - Register operators to your trap
8. **Check system** - Monitor system resources and Drosera processes
9. **Monitoring logs** - View and bridge logs from Docker containers
10. **Reconfigure UFW** - Manage firewall rules and ports
11. **Verify system** - Comprehensive system component verification
12. **Exit** - Close the application

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
5. Updates `drosera.toml` with your configuration

### Discord Cadet Role Setup
1. Select option **3** from the main menu
2. Enter your Discord username when prompted
3. The script creates a specialized Discord verification trap
4. Deploys the trap for community role verification

### Managing Operators
- **Send Bloom Boost** (Option 6): Boost your trap performance
- **Opt-in Operators** (Option 7): Register operators to your trap
- **Relocate Drosera** (Option 4): Move existing nodes with Docker Compose setup

### Monitoring and Maintenance
- **System Check** (Option 8): Monitor CPU, memory, disk usage, and Docker containers
- **Log Monitoring** (Option 9): View real-time logs, check trap status, bridge logs to files
- **Firewall Management** (Option 10): Add/remove ports, reset UFW rules
- **System Verification** (Option 11): Comprehensive health check of all components

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
Located in `~/my-drosera-trap/.env`
```bash
# Network Configuration
ETH_RPC_URL=https://your-rpc-url-here
ETH_BACKUP_RPC_URL=https://rpc.hoodi.ethpandaops.io
ETH_CHAIN_ID=560048
DROSERA_ADDRESS=0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D

# Private Keys
DROSERA_PRIVATE_KEY=your_private_key_here
ETH_PRIVATE_KEY=your_private_key_here

# Server Configuration
VPS_IP=your.server.ip
SERVER_IP=your.server.ip

# Operator Configuration
OPERATOR_ADDRESS_1=0x...
OPERATOR_ADDRESS_2=0x...

# Trap Configuration
TRAP_CONFIG_ADDRESS=0x...
RESPONSE_CONTRACT=0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608

# Discord Configuration
DISCORD_USERNAME=your_discord_username
```

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

#### Check operator logs
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
