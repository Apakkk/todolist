#!/bin/bash

# Package and Containerization Script

# Renklendirme
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Versiyon oku
VERSION=$(grep '"version"' version.json | sed 's/.*"version": "\(.*\)".*/\1/')
BUILD_DATE=$(date +%Y%m%d-%H%M%S)
ARTIFACT_DIR="artifacts"

echo -e "${BLUE}=========================================="
echo -e "📦 Artifact & Containerization Pipeline"
echo -e "==========================================${NC}"
echo -e "Version: ${GREEN}v$VERSION${NC}"
echo -e "Build Date: $BUILD_DATE"
echo ""

# Artifact dizinini oluştur
mkdir -p $ARTIFACT_DIR/{frontend,backend}

# ============================================
# 1. TESTS
# ============================================
echo -e "${BLUE}[1/5] Running Tests...${NC}"

# Frontend tests (skipped - not implemented)
echo -e "${YELLOW}Skipping frontend tests (not implemented)${NC}"

# Backend tests
echo -e "${YELLOW}Running backend tests...${NC}"
cd backend
dotnet test ../backend.tests/TodoApi.Tests.csproj --configuration Release --verbosity quiet
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Backend tests failed!${NC}"
    exit 1
fi
cd ..
echo -e "${GREEN}✅ Backend tests passed${NC}"

# ============================================
# 2. FRONTEND ARTIFACT
# ============================================
echo ""
echo -e "${BLUE}[2/5] Building Frontend Artifact...${NC}"

# Build frontend
npm run build
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Frontend build failed!${NC}"
    exit 1
fi

# Frontend artifact oluştur (zip)
FRONTEND_ARTIFACT="$ARTIFACT_DIR/frontend/todoapp-frontend-v$VERSION-$BUILD_DATE.tar.gz"
tar -czf $FRONTEND_ARTIFACT -C dist .
echo -e "${GREEN}✅ Frontend artifact: $FRONTEND_ARTIFACT${NC}"
echo -e "   Size: $(du -h $FRONTEND_ARTIFACT | cut -f1)"

# ============================================
# 3. BACKEND ARTIFACT
# ============================================
echo ""
echo -e "${BLUE}[3/5] Building Backend Artifact...${NC}"

# Publish backend
cd backend
dotnet publish -c Release -o ../artifacts/backend/publish
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Backend publish failed!${NC}"
    exit 1
fi
cd ..

# Backend artifact oluştur (zip)
BACKEND_ARTIFACT="$ARTIFACT_DIR/backend/todoapp-backend-v$VERSION-$BUILD_DATE.tar.gz"
tar -czf $BACKEND_ARTIFACT -C $ARTIFACT_DIR/backend/publish .
echo -e "${GREEN}✅ Backend artifact: $BACKEND_ARTIFACT${NC}"
echo -e "   Size: $(du -h $BACKEND_ARTIFACT | cut -f1)"

# ============================================
# 4. DOCKER IMAGES
# ============================================
echo ""
echo -e "${BLUE}[4/5] Building Docker Images...${NC}"

# Backend Docker image
echo "Building backend image..."
docker build -t todoapp-backend:$VERSION -t todoapp-backend:latest ./backend
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Backend Docker build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Backend image: todoapp-backend:$VERSION${NC}"

# Frontend Docker image
echo "Building frontend image..."
docker build -t todoapp-frontend:$VERSION -t todoapp-frontend:latest .
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Frontend Docker build failed!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Frontend image: todoapp-frontend:$VERSION${NC}"

# ============================================
# 5. VERSION TAGGING & MANIFEST
# ============================================
echo ""
echo -e "${BLUE}[5/5] Creating Build Manifest...${NC}"

# Build manifest oluştur
cat > $ARTIFACT_DIR/build-manifest.json << EOF
{
  "version": "$VERSION",
  "buildDate": "$BUILD_DATE",
  "artifacts": {
    "frontend": {
      "file": "$(basename $FRONTEND_ARTIFACT)",
      "size": "$(du -h $FRONTEND_ARTIFACT | cut -f1)",
      "dockerImage": "todoapp-frontend:$VERSION"
    },
    "backend": {
      "file": "$(basename $BACKEND_ARTIFACT)",
      "size": "$(du -h $BACKEND_ARTIFACT | cut -f1)",
      "dockerImage": "todoapp-backend:$VERSION"
    }
  },
  "dockerImages": [
    "todoapp-frontend:$VERSION",
    "todoapp-backend:$VERSION",
    "postgres:15"
  ],
  "checksum": {
    "frontend": "$(shasum -a 256 $FRONTEND_ARTIFACT | cut -d' ' -f1)",
    "backend": "$(shasum -a 256 $BACKEND_ARTIFACT | cut -d' ' -f1)"
  }
}
EOF

echo -e "${GREEN}✅ Build manifest created${NC}"

# ============================================
# SUMMARY
# ============================================
echo ""
echo -e "${BLUE}=========================================="
echo -e "📊 Package Summary"
echo -e "==========================================${NC}"
echo -e "Version:        ${GREEN}v$VERSION${NC}"
echo -e "Build Date:     $BUILD_DATE"
echo ""
echo -e "${YELLOW}Artifacts:${NC}"
echo -e "  Frontend:     $FRONTEND_ARTIFACT"
echo -e "  Backend:      $BACKEND_ARTIFACT"
echo ""
echo -e "${YELLOW}Docker Images:${NC}"
docker images | grep -E "todoapp-(frontend|backend)" | grep "$VERSION"
echo ""
echo -e "${YELLOW}Total Size:${NC}"
echo -e "  Artifacts:    $(du -sh $ARTIFACT_DIR | cut -f1)"
echo ""
echo -e "${GREEN}✅ Package pipeline completed successfully!${NC}"
echo ""
echo -e "${BLUE}=========================================="
echo -e "Next Steps:"
echo -e "==========================================${NC}"
echo "1. Test containers:    docker-compose up"
echo "2. Save images:        docker save todoapp-frontend:$VERSION | gzip > todoapp-frontend-$VERSION.tar.gz"
echo "3. Push to registry:   docker push todoapp-frontend:$VERSION"
echo "4. Create git tag:     git tag v$VERSION && git push origin v$VERSION"
echo ""
