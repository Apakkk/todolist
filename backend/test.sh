#!/bin/bash

set -e

cd "$(dirname "$0")"

echo "=========================================="
echo "🧪 Backend Test Pipeline"
echo "=========================================="

echo ""
echo "[1/3] Restoring Test Dependencies..."
dotnet restore ../backend.tests/TodoApi.Tests.csproj

echo ""
echo "[2/3] Building Test Project..."
dotnet build ../backend.tests/TodoApi.Tests.csproj --configuration Release --no-restore

echo ""
echo "[3/3] Running Tests..."
dotnet test ../backend.tests/TodoApi.Tests.csproj --configuration Release --no-build --verbosity normal

echo ""
echo "✅ Backend tests passed!"
