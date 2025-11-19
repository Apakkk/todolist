#!/bin/bash

echo "=========================================="
echo "Frontend Build Pipeline Started"
echo "=========================================="

# 1. Dependency Resolution
echo ""
echo "[1/4] Resolving Dependencies..."
npm ci
if [ $? -ne 0 ]; then
    echo "❌ Dependency resolution failed!"
    exit 1
fi
echo "✅ Dependencies resolved successfully"

# 2. Type Checking (Compile Check)
echo ""
echo "[2/4] Running Type Check..."
npm run typecheck
if [ $? -ne 0 ]; then
    echo "❌ Type check failed!"
    exit 1
fi
echo "✅ Type check passed"

# 3. Static Analysis (Linting)
echo ""
echo "[3/4] Running ESLint (Static Analysis)..."
npm run lint
if [ $? -ne 0 ]; then
    echo "⚠️  Linting issues found. Please fix them."
    exit 1
fi
echo "✅ Linting passed"

# 4. Build (Compile)
echo ""
echo "[4/4] Building Project..."
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi
echo "✅ Build completed successfully"

# Security Audit
echo ""
echo "Running Security Audit..."
npm audit --production --audit-level=moderate
if [ $? -ne 0 ]; then
    echo "⚠️  Security vulnerabilities detected. Review dependencies."
else
    echo "✅ No security vulnerabilities found"
fi

echo ""
echo "=========================================="
echo "Frontend Build Pipeline Completed"
echo "Build output: dist/"
echo "=========================================="
