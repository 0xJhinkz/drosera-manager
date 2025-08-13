#!/bin/bash

# Setup script for Drosera Trap Template
# This script initializes the Foundry project and installs dependencies

set -e

echo "🌱 Setting up Drosera Trap Template..."

# Check if we're in the right directory
if [[ ! -f "foundry.toml" ]]; then
    echo "❌ Error: foundry.toml not found. Are you in the right directory?"
    exit 1
fi

# Install Foundry if not present
if ! command -v forge &> /dev/null; then
    echo "📦 Installing Foundry..."
    curl -L https://foundry.paradigm.xyz | bash
    source ~/.bashrc
    foundryup
fi

# Install git submodules
echo "📦 Installing git submodules..."
git submodule update --init --recursive

# Install forge dependencies
echo "🔨 Installing forge dependencies..."
forge install foundry-rs/forge-std@v1.8.2 --no-commit
forge install drosera-network/drosera-contracts --no-commit
forge install OpenZeppelin/openzeppelin-contracts@v5.0.2 --no-commit

# Build the project
echo "🏗️  Building project..."
forge build

# Run tests
echo "🧪 Running tests..."
forge test

# Copy environment file
if [[ ! -f ".env" ]]; then
    echo "📄 Creating .env file from template..."
    cp env.example .env
    echo "✅ Please edit .env file with your configuration"
else
    echo "⚠️  .env file already exists, skipping copy"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Edit .env file with your private key and configuration"
echo "2. Edit drosera.toml with your operator addresses and trap configuration"
echo "3. Customize src/Trap.sol for your monitoring needs"
echo "4. Deploy with: DROSERA_PRIVATE_KEY=\$PRIVATE_KEY drosera apply"
echo ""
echo "🚀 Happy trapping!"
