#!/bin/bash

# Docker Compose Yardımcı Komutlar

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_menu() {
    echo -e "${BLUE}=========================================="
    echo -e "🐳 Docker Compose Management"
    echo -e "==========================================${NC}"
    echo ""
    echo "1) Start all services (foreground)"
    echo "2) Start all services (background)"
    echo "3) Stop all services"
    echo "4) Restart all services"
    echo "5) View logs"
    echo "6) View service status"
    echo "7) Rebuild images"
    echo "8) Clean up (remove containers & volumes)"
    echo "9) Run with specific version"
    echo "0) Exit"
    echo ""
}

start_foreground() {
    echo -e "${BLUE}Starting services in foreground...${NC}"
    docker-compose up
}

start_background() {
    echo -e "${BLUE}Starting services in background...${NC}"
    docker-compose up -d
    echo -e "${GREEN}✅ Services started!${NC}"
    docker-compose ps
}

stop_services() {
    echo -e "${YELLOW}Stopping services...${NC}"
    docker-compose down
    echo -e "${GREEN}✅ Services stopped!${NC}"
}

restart_services() {
    echo -e "${YELLOW}Restarting services...${NC}"
    docker-compose restart
    echo -e "${GREEN}✅ Services restarted!${NC}"
}

view_logs() {
    echo "Select service:"
    echo "1) All"
    echo "2) Frontend"
    echo "3) Backend"
    echo "4) Database"
    read -p "Choice: " choice
    
    case $choice in
        1) docker-compose logs -f ;;
        2) docker-compose logs -f frontend ;;
        3) docker-compose logs -f backend ;;
        4) docker-compose logs -f postgres ;;
        *) echo "Invalid choice" ;;
    esac
}

view_status() {
    echo -e "${BLUE}Service Status:${NC}"
    docker-compose ps
    echo ""
    echo -e "${BLUE}Container Health:${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

rebuild_images() {
    echo -e "${YELLOW}Rebuilding images...${NC}"
    docker-compose build --no-cache
    echo -e "${GREEN}✅ Images rebuilt!${NC}"
}

cleanup() {
    echo -e "${YELLOW}⚠️  This will remove all containers, networks, and volumes!${NC}"
    read -p "Are you sure? (y/n): " confirm
    
    if [ "$confirm" = "y" ]; then
        docker-compose down -v
        docker system prune -f
        echo -e "${GREEN}✅ Cleanup complete!${NC}"
    else
        echo "Cancelled."
    fi
}

run_with_version() {
    read -p "Enter version (e.g., 1.0.0): " version
    echo -e "${BLUE}Starting with version: $version${NC}"
    VERSION=$version docker-compose up -d
    echo -e "${GREEN}✅ Services started with version $version${NC}"
}

# Ana döngü
while true; do
    show_menu
    read -p "Enter your choice: " choice
    echo ""
    
    case $choice in
        1) start_foreground ;;
        2) start_background ;;
        3) stop_services ;;
        4) restart_services ;;
        5) view_logs ;;
        6) view_status ;;
        7) rebuild_images ;;
        8) cleanup ;;
        9) run_with_version ;;
        0) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid choice" ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    clear
done
