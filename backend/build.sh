#!/bin/bash

echo "=========================================="
echo "Backend Build Pipeline Started"
echo "=========================================="

# 1. Dependency Resolution
echo ""
echo "[1/3] Resolving Dependencies..."
dotnet restore TodoApi.csproj
if [ $? -ne 0 ]; then
    echo "❌ Dependency resolution failed!"
    exit 1
fi
echo "✅ Dependencies resolved successfully"

# 2. Compile (Build)
echo ""
echo "[2/3] Building Project..."
dotnet build TodoApi.csproj --configuration Release --no-restore
if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi
echo "✅ Build completed successfully"

# 3. Static Analysis
echo ""
echo "[3/3] Running Static Analysis..."

# Code Style Check
echo "  → Checking code formatting..."
dotnet format TodoApi.csproj --verify-no-changes --verbosity quiet
if [ $? -ne 0 ]; then
    echo "⚠️  Code formatting issues found. Run 'dotnet format' to fix."
else
    echo "✅ Code formatting is correct"
fi

# Security Vulnerabilities
echo "  → Checking for security vulnerabilities..."
dotnet list TodoApi.csproj package --vulnerable --include-transitive 2>&1 | grep -q "no vulnerable packages"
if [ $? -eq 0 ]; then
    echo "✅ No security vulnerabilities found"
else
    echo "⚠️  Security vulnerabilities detected. Review dependencies."
fi

echo ""
echo "=========================================="
echo "Backend Build Pipeline Completed"
echo "=========================================="
