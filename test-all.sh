#!/bin/bash

set -e

START_TIME=$(date +%s)

echo "=========================================="
echo "🧪 Full Test Suite"
echo "=========================================="
echo ""

# Frontend Tests
echo "📦 [1/2] Frontend Tests"
echo "=========================================="
./test.sh
echo ""

# Backend Tests
echo "🔧 [2/2] Backend Tests"
echo "=========================================="
cd backend
./test.sh
cd ..
echo ""

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "=========================================="
echo "✅ All Tests Passed!"
echo "=========================================="
echo "Duration: ${DURATION}s"
echo ""
