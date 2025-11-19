#!/bin/bash

echo "=========================================="
echo "🚀 Full Stack Build Pipeline"
echo "=========================================="

BUILD_START=$(date +%s)
FRONTEND_SUCCESS=false
BACKEND_SUCCESS=false

# Frontend Build
echo ""
echo "📦 Building Frontend..."
echo "=========================================="
cd "$(dirname "$0")"
if ./build.sh; then
    FRONTEND_SUCCESS=true
    echo "✅ Frontend build successful"
else
    echo "❌ Frontend build failed"
fi

# Backend Build
echo ""
echo "📦 Building Backend..."
echo "=========================================="
cd backend
if ./build.sh; then
    BACKEND_SUCCESS=true
    echo "✅ Backend build successful"
else
    echo "❌ Backend build failed"
fi

# Summary
BUILD_END=$(date +%s)
BUILD_DURATION=$((BUILD_END - BUILD_START))

echo ""
echo "=========================================="
echo "📊 Build Summary"
echo "=========================================="
echo "Frontend: $([ "$FRONTEND_SUCCESS" = true ] && echo "✅ PASSED" || echo "❌ FAILED")"
echo "Backend:  $([ "$BACKEND_SUCCESS" = true ] && echo "✅ PASSED" || echo "❌ FAILED")"
echo "Duration: ${BUILD_DURATION}s"
echo "=========================================="

# Exit with error if any build failed
if [ "$FRONTEND_SUCCESS" = false ] || [ "$BACKEND_SUCCESS" = false ]; then
    echo "❌ Build pipeline failed!"
    exit 1
fi

echo "✅ All builds completed successfully!"
exit 0
