#!/bin/bash

# Drosera Node Docker Start Script
set -e  # Exit on any error

echo "=== Starting Drosera Node with Docker Compose ==="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_error() { echo -e "${RED}ERROR: $1${NC}"; }
print_success() { echo -e "${GREEN}SUCCESS: $1${NC}"; }
print_warning() { echo -e "${YELLOW}WARNING: $1${NC}"; }

# Check if .env file exists
if [ ! -f .env ]; then
    print_error ".env file not found!"
    echo "Please copy env.example to .env and configure your settings:"
    echo "  cp env.example .env"
    echo "  nano .env"
    echo ""
    echo "Required variables for Docker node:"
    echo "  - ETH_PRIVATE_KEY: Your Ethereum private key (without 0x prefix)"
    echo "  - VPS_IP: Your server's external IP address"
    exit 1
fi

# Load environment variables for validation
source .env

# Validate required environment variables
echo "Validating configuration..."

if [ -z "$ETH_PRIVATE_KEY" ] || [ "$ETH_PRIVATE_KEY" = "your_private_key_here" ]; then
    print_error "ETH_PRIVATE_KEY is not set or still contains placeholder value"
    echo "Please set your Ethereum private key in .env file"
    exit 1
fi

if [ -z "$VPS_IP" ] || [ "$VPS_IP" = "your_vps_ip_here" ]; then
    print_error "VPS_IP is not set or still contains placeholder value"
    echo "Please set your server's external IP address in .env file"
    exit 1
fi

# Validate private key format (basic check - should be 64 hex characters)
if ! [[ "$ETH_PRIVATE_KEY" =~ ^[0-9a-fA-F]{64}$ ]]; then
    print_warning "ETH_PRIVATE_KEY doesn't look like a valid 64-character hex private key"
    echo "Make sure your private key is correct (64 hex characters, no 0x prefix)"
fi

# Validate IP address format (basic check)
if ! [[ "$VPS_IP" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    print_warning "VPS_IP doesn't look like a valid IP address format"
    echo "Make sure your IP address is in correct format (e.g., 192.168.1.100)"
fi

print_success "Configuration validation passed"

# Create required directories
echo "Creating required directories..."
mkdir -p data logs
chmod 755 data logs

# Check if Docker is running
echo "Checking Docker availability..."
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running or not accessible"
    echo "Please start Docker first or check Docker permissions"
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    print_error "docker-compose is not installed"
    echo "Please install docker-compose first:"
    echo "  sudo apt-get update && sudo apt-get install docker-compose"
    exit 1
fi

# Stop any existing container
echo "Stopping any existing Drosera containers..."
docker-compose down > /dev/null 2>&1 || true

echo "Starting Drosera node..."
if docker-compose up -d; then
    print_success "Drosera node container started successfully!"
    
    echo ""
    echo "=== Container Information ==="
    echo "Container name: drosera-node"
    echo "Network mode: host (using your server's network directly)"
    echo ""
    echo "=== Ports ==="
    echo "  - P2P: 31313"
    echo "  - API: 31314"
    echo ""
    echo "=== Useful Commands ==="
    echo "  View logs: docker-compose logs -f"
    echo "  Stop node: ./stop-drosera.sh"
    echo "  Restart: docker-compose restart"
    echo "  Status: docker-compose ps"
    echo ""
    echo "=== Data Directories ==="
    echo "  Database: ./data/"
    echo "  Logs: ./logs/"
    
    # Wait a moment and check if container is still running
    sleep 3
    if docker-compose ps | grep -q "Up"; then
        print_success "Node is running successfully!"
    else
        print_error "Node container exited unexpectedly"
        echo "Check logs with: docker-compose logs"
        exit 1
    fi
else
    print_error "Failed to start Drosera node"
    echo "Check the error messages above or run: docker-compose logs"
    exit 1
fi
