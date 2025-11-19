#!/bin/bash

set -e

echo "=========================================="
echo "🧪 Frontend Test Pipeline"
echo "=========================================="

echo ""
echo "[1/2] Running Unit Tests..."
npm test -- --run

echo ""
echo "[2/2] Running Tests with Coverage..."
npm run test:coverage

echo ""
echo "✅ Frontend tests passed!"
