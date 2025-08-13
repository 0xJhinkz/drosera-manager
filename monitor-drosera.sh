#!/bin/bash

# Drosera Node Monitoring Script

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_error() { echo -e "${RED}ERROR: $1${NC}"; }
print_success() { echo -e "${GREEN}SUCCESS: $1${NC}"; }
print_warning() { echo -e "${YELLOW}WARNING: $1${NC}"; }
print_info() { echo -e "${BLUE}INFO: $1${NC}"; }

echo "=== Drosera Node Monitor ==="

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    print_error "docker-compose is not installed"
    exit 1
fi

# Function to show container status
show_status() {
    echo ""
    echo "=== Container Status ==="
    docker-compose ps
    
    if docker-compose ps | grep -q "Up"; then
        print_success "Drosera node is running"
        
        # Get container stats
        echo ""
        echo "=== Resource Usage ==="
        docker stats drosera-node --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
        
        # Check if ports are listening
        echo ""
        echo "=== Port Status ==="
        if netstat -tlnp 2>/dev/null | grep -q ":31313"; then
            print_success "P2P port 31313 is listening"
        else
            print_warning "P2P port 31313 is not listening"
        fi
        
        if netstat -tlnp 2>/dev/null | grep -q ":31314"; then
            print_success "API port 31314 is listening"
        else
            print_warning "API port 31314 is not listening"
        fi
        
    else
        print_error "Drosera node is not running"
        echo "Start with: ./start-drosera.sh"
    fi
}

# Function to show recent logs
show_logs() {
    echo ""
    echo "=== Recent Logs (last 20 lines) ==="
    docker-compose logs --tail=20 drosera-node
}

# Function to show real-time logs
follow_logs() {
    echo ""
    echo "=== Following Logs (Press Ctrl+C to stop) ==="
    docker-compose logs -f drosera-node
}

# Function to show disk usage
show_disk_usage() {
    echo ""
    echo "=== Data Directory Usage ==="
    if [ -d "data" ]; then
        du -sh data/ 2>/dev/null || echo "Unable to check data directory size"
    else
        echo "Data directory not found"
    fi
    
    if [ -d "logs" ]; then
        du -sh logs/ 2>/dev/null || echo "Unable to check logs directory size"
    else
        echo "Logs directory not found"
    fi
}

# Main menu
if [ "$1" = "" ]; then
    echo "Usage: $0 [status|logs|follow|disk|all]"
    echo ""
    echo "Commands:"
    echo "  status  - Show container status and port information"
    echo "  logs    - Show recent logs"
    echo "  follow  - Follow logs in real-time"
    echo "  disk    - Show disk usage"
    echo "  all     - Show all information"
    echo ""
    echo "Examples:"
    echo "  $0 status"
    echo "  $0 follow"
    exit 0
fi

case "$1" in
    "status")
        show_status
        ;;
    "logs")
        show_logs
        ;;
    "follow")
        follow_logs
        ;;
    "disk")
        show_disk_usage
        ;;
    "all")
        show_status
        show_disk_usage
        show_logs
        ;;
    *)
        print_error "Unknown command: $1"
        echo "Use: $0 [status|logs|follow|disk|all]"
        exit 1
        ;;
esac
