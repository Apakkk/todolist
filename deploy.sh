#!/bin/bash

# Deploy Script - Build, Package ve Deploy
# Tüm süreci otomatikleştirir

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================="
echo -e "🚀 Full Deployment Pipeline"
echo -e "==========================================${NC}"
echo ""

# 1. Package (Build + Containerize)
echo -e "${BLUE}[1/3] Building and Packaging...${NC}"
./package.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Package failed!${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Package completed${NC}"
echo ""

# 2. Stop existing containers
echo -e "${BLUE}[2/3] Stopping existing containers...${NC}"
docker-compose down
echo -e "${GREEN}✅ Containers stopped${NC}"
echo ""

# 3. Start new containers
echo -e "${BLUE}[3/3] Starting containers...${NC}"
docker-compose up -d

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Container start failed!${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Containers started${NC}"
echo ""

# Wait for health checks
echo -e "${YELLOW}⏳ Waiting for services to be healthy...${NC}"
sleep 5

# Check status
echo ""
echo -e "${BLUE}=========================================="
echo -e "📊 Deployment Status"
echo -e "==========================================${NC}"
docker-compose ps

echo ""
echo -e "${BLUE}=========================================="
echo -e "🎉 Deployment Complete!"
echo -e "==========================================${NC}"
echo ""
echo -e "Frontend:  ${GREEN}http://localhost${NC}"
echo -e "Backend:   ${GREEN}http://localhost:5275/api${NC}"
echo -e "Health:    ${GREEN}http://localhost:5275/api/health${NC}"
echo ""
echo -e "${YELLOW}View logs:${NC} docker-compose logs -f"
echo -e "${YELLOW}Stop all:${NC}  docker-compose down"
echo ""
