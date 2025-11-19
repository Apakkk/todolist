#!/bin/bash

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}📊 TodoList Test Runner${NC}"
echo -e "${BLUE}========================================${NC}"

# Navigate to backend.tests directory
cd backend.tests || { echo -e "${RED}❌ backend.tests directory not found${NC}"; exit 1; }

echo -e "${YELLOW}📋 Available Options:${NC}"
echo "1) Run all tests"
echo "2) Run tests with code coverage"
echo "3) Run specific test class"
echo "4) Run verbose tests"
echo "5) Run tests and generate report"
echo ""
read -p "Select option (1-5): " choice

case $choice in
    1)
        echo -e "${BLUE}🧪 Running all tests...${NC}"
        dotnet test
        ;;
    2)
        echo -e "${BLUE}📊 Running tests with code coverage...${NC}"
        dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
        echo -e "${GREEN}✅ Coverage report generated: coverage.opencover.xml${NC}"
        ;;
    3)
        read -p "Enter test class name (e.g., JwtServiceTests): " testClass
        echo -e "${BLUE}🧪 Running ${testClass}...${NC}"
        dotnet test --filter "ClassName~${testClass}"
        ;;
    4)
        echo -e "${BLUE}📝 Running tests with verbose output...${NC}"
        dotnet test -v detailed
        ;;
    5)
        echo -e "${BLUE}📊 Running tests and generating reports...${NC}"
        dotnet test --logger "trx" --collect:"XPlat Code Coverage"
        echo -e "${GREEN}✅ Test reports generated${NC}"
        echo -e "${YELLOW}📁 Check TestResults/ directory for reports${NC}"
        ;;
    *)
        echo -e "${RED}❌ Invalid option${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}✅ Done!${NC}"
