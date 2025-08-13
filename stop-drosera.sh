#!/bin/bash

# Drosera Node Docker Stop Script
set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_error() { echo -e "${RED}ERROR: $1${NC}"; }
print_success() { echo -e "${GREEN}SUCCESS: $1${NC}"; }
print_warning() { echo -e "${YELLOW}WARNING: $1${NC}"; }
print_info() { echo -e "${YELLOW}INFO: $1${NC}"; }

echo "=== Stopping Drosera Node ==="

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    print_error "docker-compose is not installed"
    exit 1
fi

# Check if there are any running containers
if docker-compose ps | grep -q "Up"; then
    echo "Stopping running containers..."
    if docker-compose down; then
        print_success "Drosera node stopped successfully"
    else
        print_error "Failed to stop some containers"
        exit 1
    fi
else
    print_info "No running Drosera containers found"
fi

echo ""
echo "=== Cleanup Options ==="
echo "Container stopped. Data is preserved in ./data/ directory."
echo ""
echo "Available commands:"
echo "  View logs: docker-compose logs"
echo "  Start again: ./start-drosera.sh"
echo "  Remove all data: rm -rf data/ logs/ (WARNING: This deletes your database!)"
echo "  Remove unused Docker images: docker system prune"

# Show container status
echo ""
echo "=== Container Status ==="
docker-compose ps
