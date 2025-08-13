# Makefile for Drosera Trap Development

# Default target
.PHONY: help
help:
	@echo "🌱 Drosera Trap Development Commands"
	@echo ""
	@echo "Setup:"
	@echo "  setup           Initialize the project and install dependencies"
	@echo "  clean           Clean build artifacts"
	@echo ""
	@echo "Development:"
	@echo "  build           Compile contracts"
	@echo "  test            Run tests"
	@echo "  test-v          Run tests with verbose output"
	@echo "  fmt             Format code"
	@echo "  lint            Check code formatting"
	@echo ""
	@echo "Deployment:"
	@echo "  deploy-local    Deploy to local network"
	@echo "  deploy-hoodi    Deploy to Hoodi testnet"
	@echo "  verify          Verify contracts on Etherscan"
	@echo ""
	@echo "Drosera:"
	@echo "  dryrun          Test trap configuration"
	@echo "  apply           Deploy trap with Drosera"
	@echo "  status          Check trap status"

# Setup commands
.PHONY: setup
setup:
	@chmod +x setup.sh
	@./setup.sh

.PHONY: clean
clean:
	@forge clean

# Development commands
.PHONY: build
build:
	@forge build

.PHONY: test
test:
	@forge test

.PHONY: test-v
test-v:
	@forge test -vvv

.PHONY: fmt
fmt:
	@forge fmt

.PHONY: lint
lint:
	@forge fmt --check

# Deployment commands
.PHONY: deploy-local
deploy-local:
	@forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --private-key $(PRIVATE_KEY) --broadcast

.PHONY: deploy-hoodi
deploy-hoodi:
	@forge script script/Deploy.s.sol --rpc-url https://ethereum-hoodi-rpc.publicnode.com --private-key $(PRIVATE_KEY) --broadcast --verify

.PHONY: verify
verify:
	@forge verify-contract $(CONTRACT_ADDRESS) src/Trap.sol:Trap --chain-id 560048 --etherscan-api-key $(ETHERSCAN_API_KEY)

# Drosera commands
.PHONY: dryrun
dryrun:
	@drosera dryrun

.PHONY: apply
apply:
	@DROSERA_PRIVATE_KEY=$(PRIVATE_KEY) drosera apply

.PHONY: status
status:
	@drosera status

# Install dependencies
.PHONY: install
install:
	@forge install

# Update dependencies
.PHONY: update
update:
	@forge update
