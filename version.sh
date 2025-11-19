#!/bin/bash

# Version Management Script
VERSION_FILE="version.json"

# Renklendirme
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Versiyon bilgisini oku
read_version() {
    if [ -f "$VERSION_FILE" ]; then
        VERSION=$(grep '"version"' $VERSION_FILE | sed 's/.*"version": "\(.*\)".*/\1/')
        echo "$VERSION"
    else
        echo "1.0.0"
    fi
}

# Versiyon güncelle
update_version() {
    local current_version=$1
    local version_type=$2
    
    IFS='.' read -ra VERSION_PARTS <<< "$current_version"
    local major="${VERSION_PARTS[0]}"
    local minor="${VERSION_PARTS[1]}"
    local patch="${VERSION_PARTS[2]}"
    
    case $version_type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# Ana fonksiyon
main() {
    echo -e "${BLUE}=========================================="
    echo -e "📦 Version Management"
    echo -e "==========================================${NC}"
    echo ""
    
    current_version=$(read_version)
    echo -e "Current Version: ${GREEN}$current_version${NC}"
    echo ""
    echo "Select version bump type:"
    echo "1) Patch (bug fixes)       - $current_version -> $(update_version $current_version patch)"
    echo "2) Minor (new features)    - $current_version -> $(update_version $current_version minor)"
    echo "3) Major (breaking changes)- $current_version -> $(update_version $current_version major)"
    echo "4) Keep current version"
    echo ""
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1)
            new_version=$(update_version $current_version patch)
            ;;
        2)
            new_version=$(update_version $current_version minor)
            ;;
        3)
            new_version=$(update_version $current_version major)
            ;;
        4)
            new_version=$current_version
            echo -e "${YELLOW}Keeping current version${NC}"
            ;;
        *)
            echo "Invalid choice. Keeping current version."
            new_version=$current_version
            ;;
    esac
    
    # version.json güncelle
    BUILD_DATE=$(date +%Y-%m-%d)
    cat > $VERSION_FILE << EOF
{
  "version": "$new_version",
  "buildDate": "$BUILD_DATE",
  "name": "TodoList Full Stack Application"
}
EOF
    
    echo ""
    echo -e "${GREEN}✅ Version updated to: $new_version${NC}"
    echo -e "📅 Build date: $BUILD_DATE"
    echo ""
    
    # Git tag oluştur
    read -p "Create git tag? (y/n): " create_tag
    if [ "$create_tag" = "y" ]; then
        git tag -a "v$new_version" -m "Release version $new_version"
        echo -e "${GREEN}✅ Git tag 'v$new_version' created${NC}"
        echo "Push tag with: git push origin v$new_version"
    fi
    
    echo ""
    echo -e "${BLUE}=========================================="
    echo -e "Version: v$new_version"
    echo -e "==========================================${NC}"
}

main
